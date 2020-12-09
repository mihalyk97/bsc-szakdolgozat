import Fluent
import Vapor

struct MobileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let mobile = routes.grouped("mobile")
        let authenticatedMobile = mobile.grouped(
            [MobileTokenAuthenticator(),
             User.guardMiddleware()
            ])
        let loginMobile = mobile.grouped(
            [MobileBasicAuthenticator(),
             User.guardMiddleware()
            ])
        let refreshMobile = mobile.grouped(
            [MobileRefreshTokenAuthenticator(),
             User.guardMiddleware()
            ])
        
        mobile.get("organizations", use: getOrganizations)
        mobile.get("forgottenPassword", use: getForgottenPassword)
        mobile.post("forgottenPassword", use: setForgottenPassword)
        mobile.post("register", use: register)
        
        loginMobile.get("login", use: login)
        
        refreshMobile.get("refresh", use: refreshToken)
        refreshMobile.get("logout", use: logout)
        
        authenticatedMobile.get("registeredOrganizations", use: getOrganizationsWhereRegistered)
        authenticatedMobile.patch("registeredOrganizations", ":organizationId", use: addOrganizationWhereRegistered)
        authenticatedMobile.delete("registeredOrganizations", ":organizationId", use: removeOrganizationWhereRegistered)
    }
    
    func login(req: Request) throws -> EventLoopFuture<ForMobileLoginData> {
        let user = try req.auth.require(User.self)
        
        let token = MobileJWTToken(user: user, purpose: .refresh)
        
        let signedToken = try req.application.jwt.signers.sign(token)
        
        user.refreshToken = signedToken
        
        return user.save(on: req.db).flatMapThrowing {
            return try ForMobileLoginData(user: user,
                                   token: signedToken)
        }
    }
    
    func logout(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.auth.require(User.self)
        req.auth.logout(User.self)
        
        user.refreshToken = nil
        
        return user.save(on: req.db).map {
            return HTTPStatus(statusCode: 200)
        }
    }
    
    func refreshToken(req: Request) throws -> EventLoopFuture<CommonToken> {
        let user = try req.auth.require(User.self)
        
        let token = MobileJWTToken(user: user, purpose: .access)
        
        let signedToken = try req.application.jwt.signers.sign(token)
        
        return req.eventLoop.makeSucceededFuture(CommonToken(token: signedToken))
    }
    
    func getForgottenPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let email = try? req.query.get(String.self , at: "email") else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return PasswordRepository.setResetPassword(email, db: req.db).flatMap { passwordReset in
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
    
    func setForgottenPassword(req: Request) throws -> EventLoopFuture<HTTPStatus> {
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
    
    func register(req: Request) throws -> EventLoopFuture<Response> {
        let userData = try req.content.decode(ForMobileUserRegistration.self)
        
        guard userData.isValid() else {
            throw Abort(.badRequest)
        }
        
        return try UserRepository.createUser(userData: userData, db: req.db).map { _ in
            Response(status: .created, version: req.version, headers: req.headers, body: "")
        }
    }
    
    func addOrganizationWhereRegistered(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.auth.require(User.self)
        guard let organizationIdParameter = req.parameters.get("organizationId"),
              let organizationId = UUID(uuidString: organizationIdParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return try UserRepository.addOrganizationById(id: organizationId, user: user, db: req.db).map {
            return HTTPStatus(statusCode: 200)
        }
    }
    
    func removeOrganizationWhereRegistered(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.auth.require(User.self)
        guard let organizationIdParameter = req.parameters.get("organizationId"),
              let organizationId = UUID(uuidString: organizationIdParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return try UserRepository.removeOrganizationById(id: organizationId, user: user, db: req.db).map {
            return HTTPStatus(statusCode: 200)
        }
    }
    
    func getOrganizationsWhereRegistered(req: Request) throws -> EventLoopFuture<[CommonOrganization]> {
        let user = try req.auth.require(User.self)
        
        return try UserRepository.getOrganizationsWhereRegistered(user: user, db: req.db).flatMapThrowing { organizations in
            return try organizations.compactMap { organization in
                try CommonOrganization(model: organization)
            }
        }
    }
}
