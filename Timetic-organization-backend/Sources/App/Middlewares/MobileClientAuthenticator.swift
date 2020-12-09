import Foundation
import Vapor
import Fluent
import JWT

struct MobileClientTokenAuthenticator: BearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        
        if let token = try? request.jwt.verify(bearer.token, as: MobileJWTToken.self), token.purpose == .access {
            return Client
                .find(UUID(uuidString: token.subjectId), on: request.db)
                .map { client in
                    guard let client = client else {
                        return
                    }
                    request.auth.login(client)
                }
        }
        
        return request.eventLoop.makeSucceededFuture(())
    }
}

struct MobileClientRefreshTokenAuthenticator: BearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        
        if let token = try? request.jwt.verify(bearer.token, as: MobileJWTToken.self),
           token.purpose == .refresh {
            let clientEmail = token.subjectId
            return ClientRepository
                .getClientByEmail(clientEmail, db: request.db)
                .map { client in
                    guard client.refreshToken == bearer.token else {
                        return
                    }
                    request.auth.login(client)
                }
        }
        
        return request.eventLoop.makeSucceededFuture(())
    }
}

struct MobileClientBasicAuthenticator: BasicAuthenticator {
    
    func authenticate(basic: BasicAuthorization, for request: Request) -> EventLoopFuture<Void> {
        Client.query(on: request.db)
            .filter(\.$email == basic.username)
            .first()
            .map { client in
                if let client: Client = client,
                   let hashedPassword = client.hashedPassword,
                   let isPasswordValid = try? Bcrypt.verify(basic.password, created: hashedPassword),
                   isPasswordValid {
                    request.auth.login(client)
                }
            }
    }
}
