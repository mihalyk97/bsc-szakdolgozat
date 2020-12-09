import Foundation
import Vapor
import Fluent
import JWT


struct WebTokenAuthenticator: BearerAuthenticator {
    
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {

        if let token = try? request.jwt.verify(bearer.token, as: WebJWTToken.self) {
            return Employee
                .find(UUID(uuidString: token.subjectId), on: request.db)
                .map { employee in
                    if let employee = employee,
                       employee.role == .admin {
                        request.auth.login(employee)
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
        Employee.query(on: req.db)
            .filter(\.$email == credentials.email)
            .first()
            .map { employee in
                if let admin: Employee = employee,
                   admin.role == .admin,
                   let hashedPassword = admin.hashedPassword,
                   let isPasswordValid = try? Bcrypt.verify(credentials.password, created: hashedPassword),
                   isPasswordValid {
                req.auth.login(admin)
            }
        }
    }
}
