import Foundation
import Vapor
import Fluent
import JWT

struct WebJWTToken: JWTPayload {
    let subject: SubjectClaim
    let expiration: ExpirationClaim
    let subjectId: String
    let userName: String
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case subjectId = "id"
        case userName = "usr"
    }
    
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
    
    init(employee: Employee) throws {
        self.subject = .init(value: "web+token")
        self.expiration = Self.defaultExpiration
        self.subjectId = try employee.requireID().uuidString
        self.userName = employee.name
    }
    private static var defaultExpiration: ExpirationClaim {
        .init(value: .init(timeIntervalSinceNow: 60*60))
    }
    
}
