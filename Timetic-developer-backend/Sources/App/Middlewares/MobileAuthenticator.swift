import Foundation
import Vapor
import Fluent
import JWT

struct MobileTokenAuthenticator: BearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        
        if let token = try? request.jwt.verify(bearer.token, as: MobileJWTToken.self),
           token.purpose == .access {
            let userEmail = token.subjectId
            return UserRepository
                .tryGetUserByEmail(userEmail, db: request.db)
                .map { user in
                    guard let user = user,
                    !user.isAdmin else {
                        return
                    }
                    request.auth.login(user)
                }
        }
        
        return request.eventLoop.makeSucceededFuture(())
    }
}

struct MobileRefreshTokenAuthenticator: BearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        
        if let token = try? request.jwt.verify(bearer.token, as: MobileJWTToken.self),
           token.purpose == .refresh {
            let userEmail = token.subjectId
            return UserRepository
                .tryGetUserByEmail(userEmail, db: request.db)
                .map { user in
                    guard let user = user,
                          !user.isAdmin,
                          user.refreshToken == bearer.token else {
                        return
                    }
                    request.auth.login(user)
                }
        }
        
        return request.eventLoop.makeSucceededFuture(())
    }
}

struct MobileBasicAuthenticator: BasicAuthenticator {
    
    func authenticate(basic: BasicAuthorization, for request: Request) -> EventLoopFuture<Void> {
        return UserRepository
            .tryGetUserByEmail(basic.username, db: request.db)
            .map { user in
                if let user: User = user,
                   !user.isAdmin,
                   let isPasswordValid = try? Bcrypt.verify(basic.password, created: user.hashedPassword),
                   isPasswordValid {
                    request.auth.login(user)
                }
            }
    }
}
