import Fluent
import Vapor
import Foundation

struct AdministrationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let admin = routes.grouped("admin")
        let tokenAuthenticatedAdmin = admin.grouped(
            [
                WebTokenAuthenticator(),
                User.guardMiddleware()
            ])
        let credentialsAuthenticatedAdmin = admin.grouped(
            [
                WebCredentialsAuthenticator(),
                User.guardMiddleware()
            ])
        admin.post("forgottenPassword", use: setForgottenPassword)
        admin.post("newPassword", use: setNewPassword)
        credentialsAuthenticatedAdmin.post("login", use: login)
        let authenticatedAdminOrganizations = tokenAuthenticatedAdmin.grouped("organizations")
        authenticatedAdminOrganizations.get(use: getOrganizations)
        authenticatedAdminOrganizations.post(use: createOrganization)
        authenticatedAdminOrganizations.put(use: modifyOrganization)
        authenticatedAdminOrganizations.delete(":organizationId", use: deleteOrganization)

        let authenticatedAdminUsers = tokenAuthenticatedAdmin.grouped("users")
        authenticatedAdminUsers.get(use: getUsers)
        authenticatedAdminUsers.delete(":userId", use: deleteUser)

    }
    
    func login(req: Request) throws -> EventLoopFuture<Response> {
        let admin = try req.auth.require(User.self)
        
        let token = try WebJWTToken(user: admin)
        
        let signedToken = try req.application.jwt.signers.sign(token)
        
        return CommonToken(token: signedToken).encodeResponse(for: req)
    }
    
    func setForgottenPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let emailData = try? req.content.decode(ForAdminRequestPassword.self) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return PasswordRepository.setResetPassword(emailData.email, db: req.db).flatMap { passwordReset in
            EmailRepository.sendResetPasswordEmail(
                passwordReset: passwordReset,
                request: req).map { result in
                    switch result {
                        case .success:
                            return HTTPStatus(statusCode: 200)
                        case .failure:
                            return HTTPStatus(statusCode: 400)
                    }
                }
        }
    }
    
    func setNewPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let passwordResetData = try? req.content.decode(CommonPasswordReset.self) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return PasswordRepository.resetPassword(passwordResetData, db: req.db).map {
            return HTTPStatus(statusCode: 200)
        }
    }

    func getOrganizations(req: Request) throws -> EventLoopFuture<[CommonOrganization]> {
        return OrganizationRepository.getOrganizations(db: req.db).flatMapThrowing { organizations in
            return try organizations.compactMap { organization in
                try CommonOrganization(model: organization)
            }
        }
    }
    
    func createOrganization(req: Request) throws -> EventLoopFuture<CommonOrganization> {
        let organizationData = try req.content.decode(CommonOrganization.self)
        
        guard organizationData.isValid(canBeNil: ["_id"]), organizationData._id == nil else {
            throw Abort(.badRequest)
        }
        return try OrganizationRepository.createOrModifyOrganization(organizationData: organizationData, db: req.db).flatMapThrowing { organization in
            try CommonOrganization(model: organization)
        }
    }
    
    func deleteOrganization(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let idParameter = req.parameters.get("organizationId"),
              let organizationId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest)
        }
        
        return OrganizationRepository.deleteOrganization(organizationId, db: req.db).map {
            HTTPStatus(statusCode: 200)
        }
    }
    
    func modifyOrganization(req: Request) throws -> EventLoopFuture<CommonOrganization> {
        let organizationData = try req.content.decode(CommonOrganization.self)
        
        guard organizationData.isValid() else {
            throw Abort(.badRequest)
        }
        
        return try OrganizationRepository.createOrModifyOrganization(organizationData: organizationData, db: req.db).flatMapThrowing { organization in
            try CommonOrganization(model: organization)
        }
    }
    
    func getUsers(req: Request) throws -> EventLoopFuture<[CommonUser]> {
        return UserRepository.getUsers(db: req.db).flatMapThrowing { users in
            return try users.compactMap { user in
                if !user.isAdmin {
                   return try CommonUser(model: user)
                }
                return nil
            }
        }
    }
    
    func deleteUser(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let idParameter = req.parameters.get("userId"),
              let userId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest)
        }
        
        return UserRepository.deleteUser(userId, db: req.db).map {
            HTTPStatus(statusCode: 200)
        }
    }
}
