import Foundation
import Vapor
import Fluent

// After creating/modifying/deleting a consultation, an email is going to be sent to the client.
// It is used to send emails because every appointment has consultations.
// In this way, it can be used to send emails about both online and not online appointments.
struct JitsiConsultationMiddleware: ModelMiddleware {
    
    private let application: Application
    
    init(application: Application) {
        self.application = application
    }
    
    func create(model: JitsiConsultation, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        return next.create(model, on: db).flatMap {
            model.$appointment.load(on: db).throwingFlatMap {
                if model.subject == .client {
                    let appointmentId = try model.appointment.requireID()
                    return self.sendEmailForClient(appointmentId, cause: .created, db: db)
                }
                return db.eventLoop.makeSucceededFuture(())
            }
        }
    }
    
    func update(model: JitsiConsultation, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        
        return next.update(model, on: db).flatMap {
            model.$appointment.load(on: db).throwingFlatMap {
                if model.subject == .client {
                    let appointmentId = try model.appointment.requireID()
                    return self.sendEmailForClient(appointmentId, cause: .modified, db: db)
                }
                return db.eventLoop.makeSucceededFuture(())
            }
        }
    }
    
    func delete(model: JitsiConsultation, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        
        return next.delete(model, force: force, on: db).flatMap {
            model.$appointment.load(on: db).throwingFlatMap {
                if model.subject == .client {
                    let appointmentId = try model.appointment.requireID()
                    return self.sendEmailForClient(appointmentId, cause: .cancelled, db: db)
                }
                return db.eventLoop.makeSucceededFuture(())
            }
        }
    }
    
    private func sendEmailForClient(_ appointmentId: UUID, cause: AppointmentEmailCause, db: Database) -> EventLoopFuture<Void> {
        return AppointmentRepository.getAppointmentForAdminById(appointmentId, db: db).throwingFlatMap { appointment in
            if let client = appointment.client {
                return try EmailRepository.sendAppointmentEmailForClient(cause,
                                                                     client: client,
                                                                     appointment: appointment,
                                                                     app: self.application).map { _ in }
            } else {
                return db.eventLoop.makeSucceededFuture(())
            }
        }
    }
}
