import Foundation
import Fluent
import Vapor

struct PasswordRepository {
    static func setResetPassword(_ email: String, db: Database) -> EventLoopFuture<PasswordReset> {
        return UserRepository.getUserByEmail(email, db: db).throwingFlatMap { employee in
            return Self.setResetPasswordFor(employee.email, db: db)
        }
    }
    
    private static func setResetPasswordFor(_ email: String, db: Database)
-> EventLoopFuture<PasswordReset> {
        return PasswordReset.query(on: db)
            .filter(\.$subjectEmail == email)
            .first()
            .flatMap { oldPasswordReset in
                let newPasswordReset = PasswordReset(
                    subjectEmail: email)
                if let oldPasswordReset = oldPasswordReset {
                    return oldPasswordReset.delete(on: db).and(newPasswordReset.save(on: db)).map {_ in
                        newPasswordReset
                    }
                } else {
                    return newPasswordReset.save(on: db).map {
                        newPasswordReset
                    }
                }
               
            }
    }
    
    static func resetPassword(_ passwordResetData: CommonPasswordReset, db: Database) -> EventLoopFuture<Void> {
        return PasswordReset.query(on: db)
            .filter(\.$subjectEmail == passwordResetData.email)
            .first()
            .throwingFlatMap { passwordReset in
                guard let passwordReset = passwordReset else {
                    throw Abort(.notFound, reason: AbortReason.NotFound.passwordReset)
                }
                
                guard passwordReset.validationCode == passwordResetData.code else {
                    throw Abort(.badRequest, reason: AbortReason.InconsistentData.PasswordReset.wrongCode)
                }
                
                guard passwordResetData.newPassword.count >= 6,
                      passwordResetData.newPassword.count <= 12 else {
                    throw Abort(.badRequest, reason: AbortReason.InconsistentData.PasswordReset.passwordLength)
                }
                
                var futures: [EventLoopFuture<Void>] = []
                futures.append(UserRepository.setPassword(passwordResetData.newPassword, email: passwordResetData.email, db: db))
                futures.append(passwordReset.delete(on: db))
                return EventLoopFuture.whenAllSucceed(futures, on: db.eventLoop).map { _ in }
            }
    }
}
