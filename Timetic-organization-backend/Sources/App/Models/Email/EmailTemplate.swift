import Foundation
import Vapor
import Leaf
import Smtp

struct EmailTemplate {
    private let toName: String
    private let toEmail: String
    private let subject: String
    private let htmlExtension = ".leaf"

    init(toName: String, toEmail: String, subject: String) {
        self.toName = toName
        self.toEmail = toEmail
        self.subject = subject
    }
    
    private func render<E>(templateName: String, context: E, app: Application) throws -> EventLoopFuture<String> where E: Encodable {
        return try app.render(fileName: templateName, extension: htmlExtension, context: context)
    }
    
    func createEmail<E>(templateName: String, context: E, app: Application, organizationName: String) throws -> EventLoopFuture<Email> where E: Encodable {
        return try self.render(
            templateName: templateName,
            context: context,
            app: app).map { body in
                let email = Environment.get("SMTP_EMAIL") ?? ""
                return Email(from: EmailAddress(address: email, name: "\(organizationName) - \(ApplicationInfo.appname)"),
                             to: [EmailAddress(address: self.toEmail, name: self.toName)],
                subject: self.subject,
                body: body,
                isBodyHtml: true)
            }
    }
}


