import Foundation
import Fluent
import Vapor
import Smtp

struct EmailRepository {
    static func sendResetPasswordEmailForEmployee(passwordReset: PasswordReset, request: Request) -> EventLoopFuture<Result<Bool,Error>> {
        return EmployeeRepository.getEmployeeByEmail(
            passwordReset.subjectEmail,
            db: request.db).flatMap { employee in
                return Self.sendResetPasswordEmail(
                    passwordReset: passwordReset, name: employee.name, request: request)
            }
    }
    
    private static func sendResetPasswordEmail(passwordReset: PasswordReset, name: String, request: Request) -> EventLoopFuture<Result<Bool,Error>> {
        let template = EmailTemplate(toName: name,
                                     toEmail: passwordReset.subjectEmail,
                                     subject: EmailConstant.Subject.passwordReset)
        
        return OrganizationRepository.getOrganization(db: request.db).throwingFlatMap { organization in
            // Creates the context object for the email
            let email = ResetPasswordEmail(
                code: passwordReset.validationCode,
                organizationName: organization.name)
            // Creates the template using the context object and sends the email
            return try template.createEmail(
                templateName: ResetPasswordEmail.templateName,
                context: email,
                app: request.application,
                organizationName: organization.name).flatMap { email in
                    return request.smtp.send(email)
                }
            }
        }
    
    static func sendAppointmentEmailForClient(_ cause: AppointmentEmailCause, client: Client, appointment: Appointment, app: Application) throws -> EventLoopFuture<Result<Bool,Error>> {
        return OrganizationRepository.getOrganization(db: app.db).throwingFlatMap { organization in
            // Emails can be sent only to existing (saved to database) appointments
            guard let appointmentId = try? appointment.requireID() else {
                throw Abort(.badRequest, reason: AbortReason.InconsistentData.Email.nonExistingAppointment)
            }
            
            var subject = ""
            
            switch cause {
                case .created:
                    subject = EmailConstant.Subject.appointmentCreated
                case .modified:
                    subject = EmailConstant.Subject.appointmentModified
                case .cancelled:
                    subject = EmailConstant.Subject.appointmentCancelled
            }
            
            return try JitsiRepository.tryGetConsultationByAppointmentId(appointmentId, subject: .client, db: app.db).throwingFlatMap { consultation in
                // Creates the context object for the email
                let template = EmailTemplate(toName: client.name,
                                             toEmail: client.email,
                                             subject: subject)
                
                var email = AppointmentEmail(appointment: appointment, cause: cause, organizationName: organization.name)
                
                // If an appointment has online consultation and it is not cancelled,
                // then a redirection url for the consultation has to be included in the email
                if cause != .cancelled,
                   let isOnline = appointment.isOnline,
                   isOnline,
                   let consultation = consultation {
                    email.consultationUrl = consultation.getUrlForRedirection()
                }
                
                // Creates the template using the context object and sends the email
                return try template.createEmail(
                    templateName: AppointmentEmail.templateName,
                    context: email,
                    app: app,
                    organizationName: organization.name).flatMap { email in
                        return app.smtp.send(email)
                    }
            }
        }
    }
}
