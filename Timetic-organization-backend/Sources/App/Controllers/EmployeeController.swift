import Foundation
import Fluent
import Vapor
import JWT

struct EmployeeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let employee = routes.grouped("employee")
        let authenticatedEmployee = employee.grouped(
            [MobileEmployeeTokenAuthenticator(),
             Employee.guardMiddleware()
        ])
        let loginEmployee = employee.grouped(
            [MobileEmployeeBasicAuthenticator(),
             Employee.guardMiddleware()
            ])
        let refreshEmployee = employee.grouped(
            [MobileEmployeeRefreshTokenAuthenticator(),
             Employee.guardMiddleware()
            ])
        loginEmployee.get("login", use: login)
        authenticatedEmployee.get("logout", use: logout)
        employee.get("forgottenPassword", use: getForgottenPassword)
        employee.post("forgottenPassword", use: setForgottenPassword)
        refreshEmployee.get("refresh", use: refreshToken)

        authenticatedEmployee.get("organization", use: getOrganization)
        authenticatedEmployee.get("appointments", use: getAppointments)
        authenticatedEmployee.post("appointments", use: createAppointment)
        authenticatedEmployee.put("appointments", use: modifyAppointment)
        authenticatedEmployee.get("appointmentCreationData", use: getDataForAppointmentCreation)
        authenticatedEmployee.get("clients", use: getClients)
        authenticatedEmployee.get("report", use: getReport)
        authenticatedEmployee.post("clients", use: createClient)
        authenticatedEmployee.get("consultation", use: getConsultation)

        let authenticatedEmployeeById = authenticatedEmployee.grouped("appointments",":appointmentId")
        authenticatedEmployeeById.get(use: getAppointment)
        authenticatedEmployeeById.delete(use: deleteAppointment)
        
    }
    
    func login(req: Request) throws -> EventLoopFuture<ForEmployeeLoginData> {
        let employee = try req.auth.require(Employee.self)
        
        let token = try MobileJWTToken(employee: employee, purpose: .refresh)
        
        let signedToken = try req.application.jwt.signers.sign(token)
        
        employee.refreshToken = signedToken
        
        return employee.save(on: req.db).throwingFlatMap {
            let employeeId = try employee.requireID()
            return EmployeeRepository.getEmployeeById(employeeId, db: req.db).flatMapThrowing { employeeFromDb in
                return try ForEmployeeLoginData(employee: employeeFromDb,
                                                token: signedToken)
            }
        }
    }
    
    func logout(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let employee =  try req.auth.require(Employee.self)
        employee.refreshToken = nil
        return employee.save(on: req.db).flatMap {
            req.auth.logout(Employee.self)
            return req.eventLoop.makeSucceededFuture(HTTPStatus(statusCode: 200))
        }
    }
    
    func getForgottenPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let email = try? req.query.get(String.self , at: "email") else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return PasswordRepository.setResetPasswordForEmployee(email, db: req.db).flatMap { passwordReset in
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
    
    func setForgottenPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let passwordResetData = try? req.content.decode(CommonPasswordReset.self) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return PasswordRepository.resetPassword(passwordResetData, db: req.db).map {
            return HTTPStatus(statusCode: 200)
        }
    }
    
    func refreshToken(req: Request) throws -> EventLoopFuture<CommonToken> {
        let employee = try req.auth.require(Employee.self)

        let token = try MobileJWTToken(employee: employee, purpose: .access)
        
        let signedToken = try req.application.jwt.signers.sign(token)
        
        return req.eventLoop.makeSucceededFuture(CommonToken(token: signedToken))
    }
    
    func getOrganization(req: Request) throws -> EventLoopFuture<ForEmployeeOrganization> {
        try req.auth.require(Employee.self)

        return OrganizationRepository.getOrganization(db: req.db).flatMapThrowing { organization in
            return try ForEmployeeOrganization(model: organization)
        }
    }
    
    func getAppointments(req: Request) throws -> EventLoopFuture<[CommonAppointment]> {
        let employee = try req.auth.require(Employee.self)

        var startDate: Date? = nil
        if let startParameter = try? req.query.get(Int64.self , at: "startDate") {
            startDate = startParameter.millisecondsToDate().setTimeToBeginningOfTheDay()
        }
        
        var endDate: Date? = nil
        if let endParameter = try? req.query.get(Int64.self , at: "endDate") {
            endDate = endParameter.millisecondsToDate().setTimeToEndOfTheDay()
        }
        
        if (endDate == nil && startDate != nil) ||
            (endDate != nil && startDate == nil) {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: AbortReason.ParameterError.date))
        }
        
        let clientName = try? req.query.get(String.self , at: "clientName")
        
        return try AppointmentRepository.getAppointmentsForEmployee(employee, from: startDate, to: endDate, clientName: clientName, db: req.db).flatMapThrowing { appointments in
            return try appointments.compactMap { appointment in
                return try CommonAppointment(model: appointment)
            }
        }
    }
    
    func createAppointment(req: Request) throws -> EventLoopFuture<CommonAppointment> {
        let employee = try req.auth.require(Employee.self)

        let appointmentData = try req.content.decode(CommonAppointment.self)
        
        guard appointmentData.isValid(canBeNil: ["_id","client","activity","place","price","online"]), appointmentData._id == nil else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.newAppointment)
        }
        
        return try AppointmentRepository.createOrModifyAppointmentForEmployee(appointmentData, employee: employee, db: req.db).flatMapThrowing { appointment in
            return try CommonAppointment(model: appointment)
        }
    }
    
    func modifyAppointment(req: Request) throws -> EventLoopFuture<CommonAppointment> {
        let employee = try req.auth.require(Employee.self)
        
        let appointmentData = try req.content.decode(CommonAppointment.self)
        
        guard appointmentData.isValid(canBeNil: ["client","activity","place","price","online"]) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.missing)
        }
        return try AppointmentRepository.createOrModifyAppointmentForEmployee(appointmentData, employee: employee, db: req.db).flatMapThrowing {updatedAppointment in
                return try CommonAppointment(model: updatedAppointment)
            }
    }
    
    func getDataForAppointmentCreation(req: Request) throws -> EventLoopFuture<CommonDataForAppointmentCreation> {
        let employee = try req.auth.require(Employee.self)
        
        return OrganizationRepository.getOrganization(db: req.db).throwingFlatMap { organization in
            let clients = try organization.clients.compactMap { client in
                try CommonClient(model: client)
            }
            return employee.$activities.load(on: req.db).flatMapThrowing {
                let employees = [try CommonEmployee(model: employee)]
                let activities = try employee.activities.compactMap { activity in
                    try CommonActivity(model: activity)
                }
                
                return CommonDataForAppointmentCreation(
                    activities: activities,
                    clients: clients,
                    employees: employees,
                    places: organization.addresses)
            }
        }
    }
    
    func getAppointment(req: Request) throws -> EventLoopFuture<CommonAppointment> {
        let employee = try req.auth.require(Employee.self)
        guard let idParameter = req.parameters.get("appointmentId"),
              let appointmentId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        return AppointmentRepository.getAppointmentForEmployeeById(appointmentId, employee: employee, db: req.db).flatMapThrowing { appointment in
            try CommonAppointment(model: appointment)
        }
    }
    
    func deleteAppointment(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let employee = try req.auth.require(Employee.self)
        guard let idParameter = req.parameters.get("appointmentId"),
              let appointmentId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        return AppointmentRepository.cancelAppointmentForEmployee(appointmentId, employee: employee, db: req.db).map {
            HTTPStatus(statusCode: 200)
        }
    }
    
    func getClients(req: Request) throws -> EventLoopFuture<[CommonClient]> {
        try req.auth.require(Employee.self)

        return ClientRepository.getClients(db: req.db).flatMapThrowing { clients in
            try clients.compactMap { client in  try CommonClient(model: client)
            }
        }
    }
    
    func getReport(req: Request) throws -> EventLoopFuture<ForEmployeeReport> {
        let employee = try req.auth.require(Employee.self)
        
         guard let startParameter = try? req.query.get(Int64.self , at: "startDate"),
               let endParameter = try? req.query.get(Int64.self , at: "endDate") else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        let startDate = startParameter.millisecondsToDate()
        let endDate = endParameter.millisecondsToDate()
        
        return try ReportRepository.createReportForEmployee(employee, from: startDate, to: endDate, db: req.db)
    }
    
    func createClient(req: Request) throws -> EventLoopFuture<CommonClient> {
        let employee = try req.auth.require(Employee.self)
        
        guard let clientData = try? req.content.decode(CommonClient.self),
              clientData.isValid(canBeNil: ["_id"]) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return try ClientRepository.createOrModifyClient(employee, clientData: clientData, db: req.db).flatMapThrowing { client in
            return try CommonClient(model: client)
        }
    }
    
    func getConsultation(req: Request) throws -> EventLoopFuture<CommonConsultation> {
        let employee = try req.auth.require(Employee.self)
        guard let idParameter = try? req.query.get(String.self, at: "appointmentId"),
              let appointmentId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        return AppointmentRepository.getAppointmentForEmployeeById(appointmentId, employee: employee, db: req.db).throwingFlatMap { appointment in
            return try JitsiRepository.getConsultationByAppointmentId(appointmentId, subject: .employee, db: req.db).flatMapThrowing { consultation in
                return CommonConsultation(url: try consultation.getTokenizedUrl(jitsiServerUrl: appointment.organization.jitsiUrl))
            }
        }

    }
}
