import Foundation
import Fluent
import Vapor
import JWT

struct AdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let admin = routes.grouped("admin")
        let tokenAuthenticatedAdmin = admin.grouped(
            [
                WebTokenAuthenticator(),
                Employee.guardMiddleware()
            ])
        let credentialsAuthenticatedAdmin = admin.grouped(
            [
                WebCredentialsAuthenticator(),
                Employee.guardMiddleware()
        ])
        
        tokenAuthenticatedAdmin.get("organization", use: getOrganization)
        tokenAuthenticatedAdmin.put("organization", use: modifyOrganization)
        tokenAuthenticatedAdmin.get("report", use: getReport)
        tokenAuthenticatedAdmin.get("activities", use: getActivities)
        tokenAuthenticatedAdmin.post("activities", use: createActivity)
        tokenAuthenticatedAdmin.delete("activities",":activityId", use: deleteActivity)
        tokenAuthenticatedAdmin.get("clients", use: getClients)
        tokenAuthenticatedAdmin.post("clients", use: createClient)
        tokenAuthenticatedAdmin.put("clients", use: modifyClient)
        tokenAuthenticatedAdmin.get("appointments", use: getAppointments)
        tokenAuthenticatedAdmin.post("appointments", use: createAppointment)
        tokenAuthenticatedAdmin.put("appointments", use: modifyAppointment)
        tokenAuthenticatedAdmin.get("appointmentCreationData", use: getDataForAppointmentCreation)
        tokenAuthenticatedAdmin.get("employees", use: getEmployees)
        tokenAuthenticatedAdmin.post("employees", use: createEmployee)
        tokenAuthenticatedAdmin.put("employees", use: modifyEmployee)
        tokenAuthenticatedAdmin.delete("employees",":employeeId", use: deleteEmployee)
        
        tokenAuthenticatedAdmin.get("overview", use: getOverview)
        admin.post("forgottenPassword", use: setForgottenPassword)
        admin.post("newPassword", use: setNewPassword)
        
        let tokenAuthenticatedAdminById = tokenAuthenticatedAdmin.grouped("appointments", ":appointmentId")
        tokenAuthenticatedAdminById.get(use: getAppointment)
        tokenAuthenticatedAdminById.delete(use: deleteAppointment)
        
        credentialsAuthenticatedAdmin.post("login", use: login)
    }
    
    func login(req: Request) throws -> EventLoopFuture<Response> {
        let admin = try req.auth.require(Employee.self)
        
        let token = try WebJWTToken(employee: admin)
        
        let signedToken = try req.application.jwt.signers.sign(token)
        
        return CommonToken(token: signedToken).encodeResponse(for: req)
    }
    
    func setForgottenPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let emailData = try? req.content.decode(ForAdminRequestPassword.self) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return PasswordRepository.setResetPasswordForEmployee(emailData.email, db: req.db).flatMap { passwordReset in
            EmailRepository.sendResetPasswordEmailForEmployee(
                passwordReset: passwordReset,
                request: req).map { result in
                    switch result {
                    case .success:
                        return HTTPStatus(statusCode: 200)
                    case .failure:
                        return HTTPStatus(statusCode: 400)
                    }
                }
        }
    }
    
    func setNewPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let passwordResetData = try? req.content.decode(CommonPasswordReset.self) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return PasswordRepository.resetPassword(passwordResetData, db: req.db).map {
            return HTTPStatus(statusCode: 200)
        }
    }
    
    func getOverview(req: Request) throws -> EventLoopFuture<ForAdminOverview> {
        try req.auth.require(Employee.self)
        var todaysMidnight = Date().setTimeToBeginningOfTheDay()
        if let todaysMidnightParameter = try? req.query.get(Int64.self , at: "todaysDate") {
            todaysMidnight = todaysMidnightParameter.millisecondsToDate()
        }
        
        let tomorrowsMidnight = todaysMidnight.add24HoursToDate()

        return OrganizationRepository.getOrganization(db: req.db).map { organization in
            let appointmentsToday = organization.appointments.filter({ appointment in
                appointment.startsAt >= todaysMidnight &&
                appointment.startsAt < tomorrowsMidnight
            })
            let onlineAppointmentsToday = appointmentsToday.filter({ appointment in
                if let isOnline = appointment.isOnline {
                    return isOnline
                }
                return false
            })
            let activeEmployeesToday = appointmentsToday.reduce(into: [:]) { counts, appointment in
                counts[appointment.employee.name] = ""
            }
            return ForAdminOverview(
                appointmentsToday: appointmentsToday.count,
                onlineAppointmentsToday: onlineAppointmentsToday.count,
                registeredUsers: organization.clients.count,
                activeEmployeesToday: activeEmployeesToday.keys.count)
        }
    }
    
    func getOrganization(req: Request) throws -> EventLoopFuture<ForAdminOrganization> {
        try req.auth.require(Employee.self)

        return OrganizationRepository.getOrganization(db: req.db).throwingFlatMap { organization in
            return EmployeeRepository.getDefaultContact(db: req.db).flatMapThrowing { defaultContact in
                return try ForAdminOrganization(model: organization, defaultContact: defaultContact)
            }
        }
    }
    
    func modifyOrganization(req: Request) throws -> EventLoopFuture<ForAdminOrganization> {
        try req.auth.require(Employee.self)
        
        guard let organizationData = try? req.content.decode(ForAdminOrganization.self),
              organizationData.isValid() else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return OrganizationRepository.modifyOrganization(organizationData, db: req.db).flatMapThrowing { organization in
            guard let defaultContact = organization.employees.first(where: { employee in
                employee.role == .defaultContact
            }) else {
                throw Abort(.notFound)
            }
            return try ForAdminOrganization(model: organization, defaultContact: defaultContact)
        }
    }
    
    func getAppointments(req: Request) throws -> EventLoopFuture<[CommonAppointment]> {
        try req.auth.require(Employee.self)
        
        var startDate: Date? = nil
        if let startParameter = try? req.query.get(Int64.self , at: "startDate") {
            startDate = startParameter.millisecondsToDate()
        }
        
        var endDate: Date? = nil
        if let endParameter = try? req.query.get(Int64.self , at: "endDate") {
            endDate = endParameter.millisecondsToDate()
        }
        
        if (endDate == nil && startDate != nil) ||
            (endDate != nil && startDate == nil) {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest, reason:  AbortReason.ParameterError.date))
        }
        
        return try  AppointmentRepository.getAppointmentsForAdmin(from: startDate, to: endDate,db: req.db).flatMapThrowing { appointments in
            return try appointments.compactMap { appointment in
                try CommonAppointment(model: appointment)
            }
        }
    }
    
    func createAppointment(req: Request) throws -> EventLoopFuture<CommonAppointment> {
        try req.auth.require(Employee.self)
        
        let appointmentData = try req.content.decode(CommonAppointment.self)
        
        guard appointmentData.isValid(canBeNil: ["_id", "place"]), appointmentData._id == nil else {
            throw Abort(.badRequest, reason:  AbortReason.ParameterError.newAppointment)
        }
        
        return try AppointmentRepository.createOrModifyAppointment(appointmentData, db: req.db).flatMapThrowing { appointment in
            return try CommonAppointment(model: appointment)
        }        
    }
    
    func modifyAppointment(req: Request) throws -> EventLoopFuture<CommonAppointment> {
        try req.auth.require(Employee.self)
        
        let appointmentData = try req.content.decode(CommonAppointment.self)
        
        guard appointmentData.isValid() else {
            throw Abort(.badRequest, reason:  AbortReason.ParameterError.missing)
        }
        return try AppointmentRepository.createOrModifyAppointment(
            appointmentData,
            db: req.db).flatMapThrowing {updatedAppointment in
                return try CommonAppointment(model: updatedAppointment)
            }
    }
    
    func deleteAppointment(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try req.auth.require(Employee.self)
        guard let idParameter = req.parameters.get("appointmentId"),
              let appointmentId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        return AppointmentRepository.cancelAppointmentForAdmin(appointmentId, db: req.db).map {
            HTTPStatus(statusCode: 200)
        }
    }
    
    func getAppointment(req: Request) throws -> EventLoopFuture<CommonAppointment> {
        try req.auth.require(Employee.self)
        guard let idParameter = req.parameters.get("appointmentId"),
              let appointmentId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        return AppointmentRepository.getAppointmentForAdminById(appointmentId, db: req.db).flatMapThrowing { appointment in
            try CommonAppointment(model: appointment)
        }
    }
    
    func getClients(req: Request) throws -> EventLoopFuture<[CommonClient]> {
        try req.auth.require(Employee.self)

        return ClientRepository.getClients(db: req.db).flatMapThrowing { clients in
            return try clients.compactMap { client in
                try CommonClient(model: client)
            }
        }
    }
    
    func createClient(req: Request) throws -> EventLoopFuture<CommonClient> {
        let admin = try req.auth.require(Employee.self)
        
        guard let clientData = try? req.content.decode(CommonClient.self),
              clientData.isValid(canBeNil: ["_id"]) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return try ClientRepository.createOrModifyClient(admin, clientData: clientData, db: req.db).flatMapThrowing { client in
            return try CommonClient(model: client)
        }
    }
    
    func modifyClient(req: Request) throws -> EventLoopFuture<CommonClient> {
        let admin = try req.auth.require(Employee.self)
        
        guard let clientData = try? req.content.decode(CommonClient.self),
              clientData.isValid() else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return try ClientRepository.createOrModifyClient(admin, clientData: clientData, db: req.db).flatMapThrowing { client in
            return try CommonClient(model: client)
        }
    }
    
    func getEmployees(req: Request) throws -> EventLoopFuture<[CommonEmployee]> {
        try req.auth.require(Employee.self)
        
        return EmployeeRepository.getEmployees(roles: [.general], db: req.db).flatMapThrowing { employees in
            return try employees.compactMap { employee in
                try CommonEmployee(model: employee)
            }
        }
    }
    
    func createEmployee(req: Request) throws -> EventLoopFuture<CommonEmployee> {
        try req.auth.require(Employee.self)
        
        guard let employeeData = try? req.content.decode(CommonEmployee.self),
              employeeData.isValid(canBeNil: ["_id"]) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        // default password is set to employee
        return try EmployeeRepository.createOrModifyEmployee(employeeData, db: req.db).flatMapThrowing { employee in
            return try CommonEmployee(model: employee)
        }
    }
    
    func modifyEmployee(req: Request) throws -> EventLoopFuture<CommonEmployee> {
        try req.auth.require(Employee.self)
        
        guard let employeeData = try? req.content.decode(CommonEmployee.self),
              employeeData.isValid() else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return try EmployeeRepository.createOrModifyEmployee(employeeData, db: req.db).flatMapThrowing { employee in
            return try CommonEmployee(model: employee)
        }
    }
    
    func deleteEmployee(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try req.auth.require(Employee.self)
        guard let idParameter = req.parameters.get("employeeId"),
              let employeeId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return EmployeeRepository.deleteEmployeeById(employeeId, db: req.db).map {
            HTTPStatus(statusCode: 200)
        }
    }
    
    func getActivities(req: Request) throws -> EventLoopFuture<[CommonActivity]> {
        try req.auth.require(Employee.self)

        return ActivityRepository.getActivities(db: req.db).flatMapThrowing { activities in
            return try activities.compactMap { activity in  try CommonActivity(model: activity)
                }
            }
    }
    
    func createActivity(req: Request) throws -> EventLoopFuture<CommonActivity> {
        try req.auth.require(Employee.self)
        
        guard let activityData = try? req.content.decode(CommonActivity.self),
              activityData.isValid(canBeNil: ["_id"]) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return ActivityRepository.createActivity(activityData, db: req.db).flatMapThrowing { activity in
            return try CommonActivity(model: activity)
        }
    }
    
    func deleteActivity(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try req.auth.require(Employee.self)
        guard let idParameter = req.parameters.get("activityId"),
              let activityId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return ActivityRepository.deleteActivityById(activityId, db: req.db).map {
            HTTPStatus(statusCode: 200)
        }
    }
    
    func getReport(req: Request) throws -> EventLoopFuture<ForAdminReport> {
        let admin = try req.auth.require(Employee.self)

        guard let startParameter = try? req.query.get(Int64.self , at: "startDate"),
              let endParameter = try? req.query.get(Int64.self , at: "endDate") else {
            throw Abort(.badRequest, reason:  AbortReason.ParameterError.date)
        }
        
        let startDate = startParameter.millisecondsToDate()
        let endDate = endParameter.millisecondsToDate()
        
        return try ReportRepository.createReportForAdmin(admin, from: startDate, to: endDate, db: req.db)
    }
    
    func getDataForAppointmentCreation(req: Request) throws -> EventLoopFuture<CommonDataForAppointmentCreation> {
        try req.auth.require(Employee.self)
        
        return OrganizationRepository.getOrganization(db: req.db).throwingFlatMap { organization in
            let activities = try organization.activities.compactMap { activity in  try CommonActivity(model: activity)
            }
            let clients = try organization.clients.compactMap { client in  try CommonClient(model: client)
            }
            return EmployeeRepository.getEmployees(roles: [.general], db: req.db).flatMapThrowing { generalEmployees in
                let employees = try generalEmployees.compactMap { employee in  try CommonEmployee(model: employee)
                }
                return CommonDataForAppointmentCreation(
                    activities: activities,
                    clients: clients,
                    employees: employees,
                    places: organization.addresses)
            }
        }
    }
}


