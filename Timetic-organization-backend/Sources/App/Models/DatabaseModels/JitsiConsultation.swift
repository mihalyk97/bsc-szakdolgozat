import Foundation
import Vapor
import Fluent

enum JitsiConsultationSubject: String, Codable, CaseIterable {
    case employee
    case client
}

final class JitsiConsultation: Model, Content {
    static let schema = "jitsi_consultations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "subject")
    var subject: JitsiConsultationSubject
    
    @Field(key: "token")
    var token: String
    
    @Parent(key: "appointment_id")
    var appointment: Appointment
    
    init() { }
    
    init(appointment: Appointment, subject: JitsiConsultationSubject, signedToken: String) throws {
        self.id = nil
        self.subject = subject
        self.$appointment.id = try appointment.requireID()
        self.token = signedToken
    }
    
    func modify(signedToken: String) {
        self.token = signedToken
    }

    func getUrlForRedirection() -> String {
        let serverUrl = Environment.get("SERVER_URL") ?? "http://localhost:8080"
        return "\(serverUrl)/client/emailConsultation/\(id!.uuidString)"
    }
    
    func getTokenizedUrl(jitsiServerUrl: String) throws -> String {
        return "\(jitsiServerUrl)/\(try appointment.requireID().uuidString)?jwt=\(token)"
    }
}
