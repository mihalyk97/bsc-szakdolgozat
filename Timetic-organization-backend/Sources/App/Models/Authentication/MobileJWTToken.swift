import Foundation
import Vapor
import Fluent
import JWT

enum MobileTokenPurpose: String, Codable {
    case refresh
    case access
}

struct MobileJWTToken: JWTPayload {
    let subject: SubjectClaim
    let expiration: ExpirationClaim
    let subjectId: String
    let purpose: MobileTokenPurpose
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case subjectId = "id"
        case purpose = "pur"
    }
    
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
    
    init(employee: Employee, purpose: MobileTokenPurpose) throws {
        self.subject = .init(value: "admin+token")
        switch purpose {
            case .access:
                self.expiration = Self.defaultExpiration
            case .refresh:
                self.expiration = Self.defaultRefreshExpiration
        }
        self.subjectId = try employee.requireID().uuidString
        self.purpose = purpose
    }
    
    init(client: Client) throws {
        self.subject = .init(value: "user+token") //beacuse of the developer backend
        self.expiration = Self.defaultExpiration
        self.subjectId = try client.requireID().uuidString
        self.purpose = .access
    }
    
    private static var defaultExpiration: ExpirationClaim {
        .init(value: .init(timeIntervalSinceNow: 60*60))
    }
    
    private static var defaultRefreshExpiration: ExpirationClaim {
        .init(value: .init(timeIntervalSinceNow: 60*60*24*30))
    }
}
