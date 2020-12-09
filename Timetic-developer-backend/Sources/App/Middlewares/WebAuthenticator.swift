import Foundation
import Vapor
import Fluent
import JWT


struct WebTokenAuthenticator: BearerAuthenticator {
    
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {

        if let token = try? request.jwt.verify(bearer.token, as: WebJWTToken.self) {
            return User
                .find(UUID(uuidString: token.subjectId), on: request.db)
                .map { user in
                    if let user = user,
                       user.isAdmin {
                        request.auth.login(user)
                    }
                }
        }
        
        return request.eventLoop.makeSucceededFuture(())
    }
}

struct WebCredentialsAuthenticator: CredentialsAuthenticator {
    struct Credentials: Content {
        let email: String
        let password: String
    }
    
    func authenticate(credentials: Credentials, for req: Request) -> EventLoopFuture<Void> {
        User.query(on: req.db)
            .filter(\.$email == credentials.email)
            .first()
            .map { user in
                if let admin: User = user,
                   admin.isAdmin,
                   let isPasswordValid = try? Bcrypt.verify(credentials.password, created: admin.hashedPassword),
                   isPasswordValid {
                req.auth.login(admin)
            }
        }
    }
}
