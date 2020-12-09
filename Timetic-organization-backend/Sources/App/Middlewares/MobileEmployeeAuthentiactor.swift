import Foundation
import Vapor
import Fluent
import JWT

struct MobileEmployeeTokenAuthenticator: BearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        
        if let token = try? request.jwt.verify(bearer.token, as: MobileJWTToken.self), token.purpose == .access {
            return Employee
                .find(UUID(uuidString: token.subjectId), on: request.db)
                .map { employee in
                    guard let employee = employee,
                          employee.role == .general else {
                        return
                    }
                    request.auth.login(employee)
                }
        }
        return request.eventLoop.makeSucceededFuture(())
    }
}

struct MobileEmployeeRefreshTokenAuthenticator: BearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        
        if let token = try? request.jwt.verify(bearer.token, as: MobileJWTToken.self), token.purpose == .refresh {
            return Employee
                .find(UUID(uuidString: token.subjectId), on: request.db)
                .map { employee in
                    guard let employee = employee,
                          employee.role == .general,
                          employee.refreshToken == bearer.token else {
                        return
                    }
                    request.auth.login(employee)
                }
        }
        return request.eventLoop.makeSucceededFuture(())
    }
}

struct MobileEmployeeBasicAuthenticator: BasicAuthenticator {
    
    func authenticate(basic: BasicAuthorization, for request: Request) -> EventLoopFuture<Void> {
        Employee.query(on: request.db)
            .filter(\.$email == basic.username)
            .first()
            .flatMapThrowing { employee in
                if let employee: Employee = employee,
                   let hashedPassword = employee.hashedPassword,
                   let isPasswordValid = try? Bcrypt.verify(basic.password, created: hashedPassword),
                   isPasswordValid,
                   employee.role == .general {
                    request.auth.login(employee)
                }
            }
    }
}
