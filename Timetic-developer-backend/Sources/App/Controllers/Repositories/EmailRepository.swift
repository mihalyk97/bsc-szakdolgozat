import Foundation
import Fluent
import Vapor
import Smtp

struct EmailRepository {
    static func sendResetPasswordEmail(passwordReset: PasswordReset, request: Request) -> EventLoopFuture<Result<Bool,Error>> {
        return UserRepository.getUserByEmail(
            passwordReset.subjectEmail,
            db: request.db).throwingFlatMap { user in
                return try Self.sendResetPasswordEmail(
                    passwordReset: passwordReset, name: user.name, request: request)
            }
    }
    
    private static func sendResetPasswordEmail(passwordReset: PasswordReset, name: String, request: Request) throws -> EventLoopFuture<Result<Bool,Error>> {
        let template = EmailTemplate(toName: name,
                                     toEmail: passwordReset.subjectEmail,
                                     subject: EmailConstant.Subject.passwordReset)
        
        let email = ResetPasswordEmail(
            code: passwordReset.validationCode)
            
        return try template.createEmail(
            templateName: ResetPasswordEmail.templateName,
            context: email,
            app: request.application).flatMap { email in
                return request.smtp.send(email)
            }
    }
}
