import Foundation
import Fluent
import Vapor


struct AppointmentRepository {
    static func getAppointmentsForEmployee(_ employee: Employee, from: Date? = nil, to: Date? = nil, clientName: String? = nil, db: Database) throws -> EventLoopFuture<[Appointment]> {
        return Self.appointmentQueryParameters(children: employee.$appointments, from: from, to: to, db: db)
            .all()
    }
    
    static func getAppointmentsForClient(_ client: Client, from: Date? = nil, to: Date? = nil, db: Database) throws -> EventLoopFuture<[Appointment]> {
       return  Self.appointmentQueryParameters(children: client.$appointments, from: from, to: to, db: db)
            .filter(\.$isPrivate == false)
            .all()
    }
    
    static func getAppointmentsForAdmin(from: Date? = nil, to: Date? = nil, db: Database) throws -> EventLoopFuture<[Appointment]> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            let query = Self.appointmentQueryParameters(children: organization.$appointments, from: from, to: to, db: db)
            return query.all()
        }
    }
    
    static func getAppointmentForEmployeeById(_ id: UUID, employee: Employee, db: Database) -> EventLoopFuture<Appointment> {
        return Self.appointmentQueryParameters(children: employee.$appointments, id: id, db: db)
            .first()
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.appointment))
    }
    
    static func getAppointmentForClientById(_ id: UUID, client: Client, db: Database) -> EventLoopFuture<Appointment> {
        return  Self.appointmentQueryParameters(children: client.$appointments, id: id, db: db)
            .filter(\.$isPrivate == false)
            .first()
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.appointment))
    }
    
    static func getAppointmentForAdminById(_ id: UUID, db: Database) -> EventLoopFuture<Appointment> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return Self.appointmentQueryParameters(children: organization.$appointments, id: id, db: db)
                .first()
                .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.appointment))
        }
    }
    
    private static func tryGetAppointmentById(_ id: UUID, db: Database) -> EventLoopFuture<Appointment?> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return Self.appointmentQueryParameters(children: organization.$appointments, id: id, db: db)
                .first()
        }
    }
    
    static func createOrModifyAppointment(_ appointmentData: CommonAppointment, db: Database) throws -> EventLoopFuture<Appointment> {
        
        // Checks if all data exist that is needed.
        // If appointment is online, place is not required to be set.
        guard let clientId = UUID(uuidString: appointmentData.client?._id ?? ""),
              let activityId = UUID(uuidString: appointmentData.activity?._id ?? ""),
              let employeeId = UUID(uuidString: appointmentData.employee._id ?? ""),
              appointmentData.price != nil,
              let online = appointmentData.online,
              ((!online && appointmentData.place != nil) || online) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.missing)
        }
        return Self.saveAppointment(appointmentData, clientId: clientId, activityId: activityId, employeeId: employeeId, db: db)
        
    }
    
    static func createOrModifyAppointmentForEmployee(_ appointmentData: CommonAppointment, employee: Employee, db: Database) throws -> EventLoopFuture<Appointment> {
        // Checks if employee wants to create/modify appointment for other employee.
        guard let employeeId = try? employee.requireID(),
              UUID(uuidString: appointmentData.employee._id ?? "") == employeeId else {
            throw Abort(.badRequest, reason: AbortReason.InconsistentData.Appointment.associatedEmployee)
        }
        
        // If appointment is private, no need to check data to exist, because obligatory fields are non optional.
        if appointmentData.isPrivate {
            return Self.saveAppointment(appointmentData, clientId: nil, activityId: nil, employeeId: employeeId, db: db)
        } else {
            // Checks if all data exist that is needed for nonprivate appointment.
            // If appointment is online, place is not required to be set.
            guard let clientId = UUID(uuidString: appointmentData.client?._id ?? ""),
                  let activityId = UUID(uuidString: appointmentData.activity?._id ?? ""),
                  appointmentData.price != nil,
                  let online = appointmentData.online,
                  ((!online && appointmentData.place != nil) || online) else {
                throw Abort(.badRequest, reason: AbortReason.ParameterError.missing)
            }
            return Self.saveAppointment(appointmentData, clientId: clientId, activityId: activityId, employeeId: employeeId, db: db)
        }
    }
    
    private static func saveAppointment(_ appointmentData: CommonAppointment, clientId: UUID? = nil, activityId: UUID? = nil, employeeId: UUID, db: Database) -> EventLoopFuture<Appointment> {
        // Checks if appointment exists.
        return Self.tryGetAppointmentById(UUID(uuidString: appointmentData._id ?? "") ?? UUID(), db: db).throwingFlatMap { appointmentFromDb in
            // Appointment cannot end before start.
            if appointmentData.endTime < appointmentData.startTime {
                throw Abort(.badRequest, reason: AbortReason.InconsistentData.Appointment.timeOrder)
            }
            if appointmentData._id != nil, appointmentFromDb?.id != nil {
                // Appointments with start time set before the actual day cannot be modified.
                let today = Date().setTimeToBeginningOfTheDay()
                if appointmentFromDb!.startsAt < today {
                    throw Abort(.badRequest, reason: AbortReason.InconsistentData.Appointment.modifiable)
                }
                
                let now = Date().milliseconds()
                if appointmentData.startTime < now {
                    throw Abort(.badRequest, reason: AbortReason.InconsistentData.Appointment.earliestTimeForExisting)
                }
            } else {
                // Start of the appointment cannot be set before the tomorrow.
                let tomorrow = Date().modifyDateByDay(number: 1).setTimeToBeginningOfTheDay().milliseconds()
                if appointmentData.startTime < tomorrow {
                    throw Abort(.badRequest, reason: AbortReason.InconsistentData.Appointment.earliestTimeForNew)
                }
            }
            
            let appointment = appointmentData.toModel(from: appointmentFromDb)
            // If appointment is online, place need to be set as online.
            if let isOnline = appointment.isOnline, isOnline {
                appointment.place = "Online"
            }
            appointment.$client.id = clientId
            appointment.$activity.id = activityId
            appointment.$employee.id = employeeId
            
            return OrganizationRepository.getOrganization(db: db).throwingFlatMap { organization in
               
                // Checks if activity is associated with employee.
                if activityId != nil {
                    guard let employee = organization.employees.first(where: { e in
                        e.id == employeeId
                    }), employee.activities.contains(where: { a in
                        a.id == activityId
                    }) else {
                        throw Abort(.badRequest, reason: AbortReason.InconsistentData.Appointment.activityAssociatedEmployee)
                    }
                }
                // Safe without requireID, because organization exists.
                appointment.$organization.id = organization.id!
                return appointment.save(on: db).flatMap {
                    let id = try! appointment.requireID()
                    return Self.getAppointmentForAdminById(id, db: db).throwingFlatMap { savedAppointment in
                        // For nonprivate appointments, consutations need to be created so as to send emails for clients.
                        if savedAppointment.isPrivate {
                            return db.eventLoop.makeSucceededFuture(savedAppointment)
                        } else {
                            return try JitsiRepository.createOrModifyConsultation(appointment: savedAppointment, db: db)
                                .map { savedAppointment }
                        }
                    }
                }
            }
        }
    }
    
    static func cancelAppointmentForEmployee(_ id: UUID, employee: Employee, db: Database) -> EventLoopFuture<Void> {
        Self.getAppointmentForEmployeeById(id, employee: employee, db: db).throwingFlatMap { appointment in
            return try Self.commonCancelAppointment(appointment: appointment, db: db)
        }
    }
    
    static func cancelAppointmentForClient(_ id: UUID, client: Client, db: Database) -> EventLoopFuture<Void> {
        Self.getAppointmentForClientById(id, client: client, db: db).throwingFlatMap { appointment in
            return try Self.commonCancelAppointment(appointment: appointment, db: db)
        }
    }
    
    static func cancelAppointmentForAdmin(_ id: UUID, db: Database) -> EventLoopFuture<Void> {
        Self.getAppointmentForAdminById(id, db: db).throwingFlatMap { appointment in
            return try Self.commonCancelAppointment(appointment: appointment, db: db)
        }
    }
    
    private static func commonCancelAppointment(appointment: Appointment, db: Database) throws -> EventLoopFuture<Void> {
        return try JitsiRepository.deleteConsultation(appointment: appointment, db: db).flatMap {
            appointment.delete(on: db)
        }
    }
    
    // Creates query that contains all required connections loaded.
    private static func appointmentQueryParameters<T>(children: ChildrenProperty<T, Appointment>, id: UUID? = nil, from: Date? = nil, to: Date? = nil, clientName: String?=nil, db: Database) -> QueryBuilder<Appointment> {
        var query = children.query(on: db)
        
        if let id = id {
            query = query
                .filter(\.$id == id)
        }
            
        query = query
            .with(\.$client) { client in
                client.with(\.$personalInfos)
            }
            .with(\.$activity)
            .with(\.$employee) { employee in
                employee.with(\.$activities)
            }
            .with(\.$organization)
        
        if let from = from, let to = to {
            query = query.group { group in
                group
                    .filter(\.$startsAt >= from)
                    .filter(\.$startsAt <= to)
            }
        }
        
        if let clientName = clientName {
            query = query
                .join(Client.self, on: \Appointment.$client.$id == \Client.$id)
                .filter(Client.self, \.$name ~~ clientName) //contains
        }
        
        return query
    }
}
