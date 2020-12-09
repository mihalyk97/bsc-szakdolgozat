import Foundation
import Vapor
import Fluent
import JWT

struct JitsiJWTToken: JWTPayload, Content {
    
    let context: JitsiContext
    let aud: String = "timetic-client"
    let iss: String = "timetic-consultation"
    let sub: String = "*"
    let room: String
    let exp: ExpirationClaim
    let nbf: NotBeforeClaim
    
    enum CodingKeys: String, CodingKey {
        case context = "context"
        case aud = "aud"
        case iss = "iss"
        case sub = "sub"
        case room = "room"
        case exp = "exp"
        case nbf = "nbf"
    }
    
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    init(client: Client, appointment: Appointment) throws {
        self.room = try appointment.requireID().uuidString
        self.exp = .init(value: appointment.endsAt)
        self.context = JitsiContext(
            user: JitsiUser(
                name: client.name,
                email: client.email,
                id: try client.requireID().uuidString),
            group: "client")
        self.nbf = .init(value: appointment.startsAt.addingTimeInterval(-10*60))
    }
    
    init(employee: Employee, appointment: Appointment) throws {
        self.room = try appointment.requireID().uuidString
        self.exp = .init(value: appointment.endsAt)
        self.context = JitsiContext(
            user: JitsiUser(
                name: employee.name,
                email: employee.email,
                id: try employee.requireID().uuidString),
            group: "employee")
        self.nbf = .init(value: appointment.startsAt.addingTimeInterval(-10*60))
    }
}

struct JitsiContext: Codable {
    let user: JitsiUser
    let group: String
    
    enum CodingKeys: String, CodingKey {
        case user
        case group
    }
}

struct JitsiUser: Codable {
    let avatar: String = ""
    let name: String
    let email: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case name
        case email
        case id
    }
}
