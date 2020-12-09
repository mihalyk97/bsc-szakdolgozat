import Foundation
import Vapor
import Fluent
import JWTKit

struct JitsiRepository {
    
    static var signers: JWTSigners?
    
    static func getConsultationById(_ consultationId: UUID, db: Database) throws -> EventLoopFuture<JitsiConsultation> {
        return JitsiConsultation.query(on: db)
            .filter(\.$id == consultationId)
            .with(\.$appointment)
            .first()
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.consultation))
            .flatMapThrowing { consultation in
                guard let isOnline = consultation.appointment.isOnline, isOnline else {
                    throw Abort(.badRequest, reason: AbortReason.InconsistentData.Consultation.nonOnlineAppointment)
                }
                return consultation
            }
    }
    
    static func getConsultationByAppointmentId(_ appointmentId: UUID, subject: JitsiConsultationSubject, db: Database) throws -> EventLoopFuture<JitsiConsultation> {
        return try Self.tryGetConsultationByAppointmentId(appointmentId, subject: subject, db: db)
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.consultation)).flatMapThrowing { consultation in
                guard let isOnline = consultation.appointment.isOnline, isOnline else {
                    throw Abort(.badRequest, reason: AbortReason.InconsistentData.Consultation.nonOnlineAppointment)
                }
                return consultation
            }
        
    }
    
    static func tryGetConsultationByAppointmentId(_ appointmentId: UUID, subject: JitsiConsultationSubject, db: Database) throws -> EventLoopFuture<JitsiConsultation?> {
        return JitsiConsultation.query(on: db)
                .with(\.$appointment)
                .filter(\.$appointment.$id == appointmentId)
                .filter(\.$subject == subject)
                .first()
    }
    
    static func createOrModifyConsultation(appointment: Appointment, db: Database) throws -> EventLoopFuture<Void> {
        var futures: [EventLoopFuture<Void>] = []
        
        // Checks if the jwt signers has been set for the repository
        guard let signers = signers else {
            throw Abort(.internalServerError, reason: AbortReason.InconsistentData.Configuration.error)
        }
        
        guard let appointmentId = try? appointment.requireID() else {
            throw Abort(.badRequest, reason: AbortReason.InconsistentData.Consultation.nonExistingAppointment)
        }
        
        // Creates a new consultation for the employee that is assigned to the appointment
        futures.append(try Self.tryGetConsultationByAppointmentId(appointmentId, subject: .employee, db: db).throwingFlatMap { consultationFromDb in
            // Creates the new token with current appointment-details
            let token = try JitsiJWTToken(employee: appointment.employee,
                                          appointment: appointment)
            let signedToken = try signers.sign(token)

            // If appointment had consultation then refreshes it.
            // If not, creates one.
            if let consultationFromDb = consultationFromDb {
                consultationFromDb.modify(signedToken: signedToken)
                return consultationFromDb.save(on: db)
            } else {
                let consultation = try JitsiConsultation(
                    appointment: appointment,
                    subject: .employee,
                    signedToken: signedToken)
                return consultation.save(on: db)
            }
        })
        
        // Creates a new consultation for the client that is assigned to the appointment
        futures.append(try Self.tryGetConsultationByAppointmentId(appointmentId, subject: .client, db: db).throwingFlatMap { consultationFromDb in
            
            // Private appointments may have no client assigned.
            // Checks if client is assigned.
            guard let client = appointment.client else {
                throw Abort(.badRequest, reason: AbortReason.InconsistentData.Consultation.noClient)
            }
            
            // Creates the new token with current appointment-details
            let token = try JitsiJWTToken(client: client,
                                          appointment: appointment)
            let signedToken = try signers.sign(token)
            
            // If appointment had consultation then refreshes it.
            // If not, creates one.
            if let consultationFromDb = consultationFromDb {
                consultationFromDb.modify(signedToken: signedToken)
                return consultationFromDb.save(on: db)
            } else {
                let consultation = try JitsiConsultation(
                    appointment: appointment,
                    subject: .client,
                    signedToken: signedToken)
                return consultation.save(on: db)
            }
        })
        return EventLoopFuture.whenAllSucceed(futures, on: db.eventLoop).map { _ in }
    }
    
    static func deleteConsultation(appointment: Appointment, db: Database) throws -> EventLoopFuture<Void> {
        var deleteFutures: [EventLoopFuture<Void>] = []
        
        guard let appointmentId = try? appointment.requireID() else {
            throw Abort(.badRequest, reason: AbortReason.InconsistentData.Consultation.nonExistingAppointment)
        }
        
        // Deletes consultation for all subjects (client and employee)
        try JitsiConsultationSubject.allCases.forEach { subject in
            deleteFutures.append(try Self.tryGetConsultationByAppointmentId(appointmentId, subject: subject, db: db).flatMap { consultation in
                if let consultation = consultation {
                    return consultation.delete(on: db)
                } else {
                    return db.eventLoop.makeSucceededFuture(())
                }
            })
        }
        return EventLoopFuture.whenAllSucceed(deleteFutures, on: db.eventLoop).map { _ in}
        
    }
}
