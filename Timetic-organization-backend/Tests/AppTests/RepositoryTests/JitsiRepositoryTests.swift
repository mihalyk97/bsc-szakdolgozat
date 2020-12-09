@testable import App
import XCTVapor
import Foundation

final class JitsiRepositoryTests: XCTestCase {
    func testGetConsultationsForOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let apponintments = try AppointmentRepository.getAppointmentsForAdmin(db: app.db).wait()
        let onlineApponintments = apponintments.filter { appointment in
            appointment.isOnline != nil && appointment.isOnline!
        }
        let onlineAppointment = onlineApponintments.first!
        let onlineAppointmentId = onlineAppointment.id!
        
        let clientConsultation = try JitsiRepository.getConsultationByAppointmentId(onlineAppointmentId, subject: .client, db: app.db).wait()
        let employeeConsultation = try JitsiRepository.getConsultationByAppointmentId(onlineAppointmentId, subject: .employee, db: app.db).wait()
        
        XCTAssertNotNil(clientConsultation.id)
        XCTAssertNotNil(employeeConsultation.id)
    }
    
    func testGetConsultationsForExpiredOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let apponintments = try AppointmentRepository.getAppointmentsForAdmin(db: app.db).wait()
        let expiredOnlineApponintments = apponintments.filter { appointment in
            appointment.isOnline != nil && appointment.isOnline! && appointment.startsAt < Date()
        }
        let expiredOnlineAppointment = expiredOnlineApponintments.first!
        let expiredOnlineAppointmentId = expiredOnlineAppointment.id!
        
        let clientConsultation = try JitsiRepository.getConsultationByAppointmentId(expiredOnlineAppointmentId, subject: .client, db: app.db).wait()
        let employeeConsultation = try JitsiRepository.getConsultationByAppointmentId(expiredOnlineAppointmentId, subject: .employee, db: app.db).wait()
        
        XCTAssertNotNil(clientConsultation.id)
        XCTAssertNotNil(employeeConsultation.id)
        XCTAssertThrowsError(try app.jwt.signers.verify(clientConsultation.token, as: JitsiJWTToken.self))
        XCTAssertThrowsError(try app.jwt.signers.verify(employeeConsultation.token, as: JitsiJWTToken.self))
    }
    
    func testGetConsultationsForFutureOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let apponintments = try AppointmentRepository.getAppointmentsForAdmin(db: app.db).wait()
        let onlineApponintments = apponintments.filter { appointment in
            appointment.isOnline != nil && appointment.isOnline! && appointment.startsAt > Date()
        }
        let onlineAppointment = onlineApponintments.first!
        onlineAppointment.startsAt = Date().modifyDateByDay(number: 2)
        onlineAppointment.endsAt = Date(timeIntervalSinceNow: 7200).modifyDateByDay(number: 2)
        let appointmentToSave = try CommonAppointment(model: onlineAppointment)
        let savedOnlineAppointment = try AppointmentRepository.createOrModifyAppointment(appointmentToSave, db: app.db).wait()
        let onlineAppointmentId = savedOnlineAppointment.id!
        
        let clientConsultation = try JitsiRepository.getConsultationByAppointmentId(onlineAppointmentId, subject: .client, db: app.db).wait()
        let employeeConsultation = try JitsiRepository.getConsultationByAppointmentId(onlineAppointmentId, subject: .employee, db: app.db).wait()
        
        XCTAssertNotNil(clientConsultation.id)
        XCTAssertNotNil(employeeConsultation.id)
        XCTAssertNoThrow(try app.jwt.signers.verify(clientConsultation.token, as: JitsiJWTToken.self))
        XCTAssertNoThrow(try app.jwt.signers.verify(employeeConsultation.token, as: JitsiJWTToken.self))
    }
    
    func testGetConsultationsForNonOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let apponintments = try AppointmentRepository.getAppointmentsForAdmin(db: app.db).wait()
        let onlineApponintments = apponintments.filter { appointment in
            appointment.isOnline != nil && !appointment.isOnline!
        }
        let onlineAppointment = onlineApponintments.first!
        let onlineAppointmentId = onlineAppointment.id!
        
        XCTAssertThrowsError(try JitsiRepository.getConsultationByAppointmentId(onlineAppointmentId, subject: .client, db: app.db).wait())
        XCTAssertThrowsError(try JitsiRepository.getConsultationByAppointmentId(onlineAppointmentId, subject: .employee, db: app.db).wait())
    }
}
