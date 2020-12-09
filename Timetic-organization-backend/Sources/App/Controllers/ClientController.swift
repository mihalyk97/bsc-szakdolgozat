import Foundation
import Fluent
import Vapor
import JWT

struct ClientController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let client = routes.grouped("client")
        let authenticatedClient = client.grouped(
            [MobileClientTokenAuthenticator(),
             Client.guardMiddleware()
            ])
        let refreshClient = client.grouped(
            [MobileClientRefreshTokenAuthenticator(),
             Client.guardMiddleware()
            ])
        client.get("organization", use: getOrganization)
        client.post("register", use: register)

        client.post("refresh", use: setRefreshToken)
        
        refreshClient.get("refresh", use: refreshToken)
        
        authenticatedClient.get("appointments", use: getAppointments)
        authenticatedClient.get("consultation", use: getConsultation)
        
        client.get("emailConsultation", ":consultationId", use: redirectToConsultation)

        let authenticatedClientById = authenticatedClient.grouped("appointments", ":appointmentId")
        authenticatedClientById.delete(use: deleteAppointment)
    }
    
    func setRefreshToken(req: Request) throws -> EventLoopFuture<CommonToken> {
        guard let tokenData = try? req.content.decode(ForClientRefreshToken.self),
              let token = try? req.jwt.verify(tokenData.refreshToken, as: MobileJWTToken.self),
              tokenData.email == token.subjectId else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return ClientRepository.getClientByEmail(tokenData.email, db: req.db).flatMap { client in
            client.refreshToken = tokenData.refreshToken
            
            return client.save(on: req.db).throwingFlatMap {
                return try self.createAccessToken(client: client, request: req)
            }
        }
    }
    
    func refreshToken(req: Request) throws -> EventLoopFuture<CommonToken> {
        let client = try req.auth.require(Client.self)
        
        return try self.createAccessToken(client: client, request: req)
    }
    
    private func createAccessToken(client: Client, request: Request) throws -> EventLoopFuture<CommonToken> {
        let token = try MobileJWTToken(client: client)
        
        let signedToken = try request.application.jwt.signers.sign(token)
        
        return request.eventLoop.makeSucceededFuture(CommonToken(token: signedToken))
    }
    
    func getOrganization(req: Request) throws -> EventLoopFuture<ForClientOrganization> {
        
        guard let clientEmail = try? req.query.get(String.self , at: "email") else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return OrganizationRepository.getOrganization(db: req.db).flatMapThrowing { organization in
            let employees: [CommonEmployee] = try organization.employees.compactMap { employee in
                if (organization.canClientContactEmployees && (employee.role == .general || employee.role == .defaultContact))
                || (!organization.canClientContactEmployees && employee.role == .defaultContact) {
                    return try CommonEmployee(model: employee)
                }
                return nil
            }
            return ForClientOrganization(
                _id: try organization.requireID().uuidString,
                name: organization.name,
                details: organization.details,
                isClientRegistered: organization.clients.contains(where: { client in
                    client.email == clientEmail
                }),
                employees: employees,
                clientPersonalInfoFields: organization.clientPersonalInfoFields)
        }
        
    }
    
    func getAppointments(req: Request) throws -> EventLoopFuture<[ForClientAppointment]> {
        let client = try req.auth.require(Client.self)

        return try AppointmentRepository.getAppointmentsForClient(client, db: req.db).flatMapThrowing { appointments in
            return try appointments.compactMap { appointment in
                return try ForClientAppointment(model: appointment)
            }
        }
    }
    
    func deleteAppointment(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let client = try req.auth.require(Client.self)

        guard let idParameter = req.parameters.get("appointmentId"),
              let appointmentId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        return AppointmentRepository.cancelAppointmentForClient(appointmentId, client: client, db: req.db).map {
            HTTPStatus(statusCode: 200)
        }
    }
    
    func register(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let clientData = try? req.content.decode(CommonClient.self),
              clientData.isValid(canBeNil: ["_id"]),
              clientData._id == nil else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return try ClientRepository.createOrModifyClient(clientData: clientData, db: req.db).map { _ in
            return HTTPStatus(statusCode: 200)
        }
    }
    
    func getConsultation(req: Request) throws -> EventLoopFuture<CommonConsultation> {
        let client = try req.auth.require(Client.self)
        guard let idParameter = try? req.query.get(String.self, at: "appointmentId"),
              let appointmentId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        return AppointmentRepository.getAppointmentForClientById(appointmentId, client: client, db: req.db).throwingFlatMap { appointment in
            return try JitsiRepository.getConsultationByAppointmentId(appointmentId, subject: .client, db: req.db).flatMapThrowing { consultation in
                return CommonConsultation(url: try consultation.getTokenizedUrl(jitsiServerUrl: appointment.organization.jitsiUrl))
            }
        }
    }
    
    func redirectToConsultation(req: Request) throws -> EventLoopFuture<Response> {
        guard let idParameter = req.parameters.get("consultationId"),
              let consultationId = UUID(uuidString: idParameter) else {
            throw Abort(.badRequest, reason: AbortReason.ParameterError.general)
        }
        
        return OrganizationRepository.getOrganization(db: req.db).throwingFlatMap { organization in
            return try JitsiRepository.getConsultationById(consultationId, db: req.db).flatMapThrowing { consultation in
                return req.redirect(to: try consultation.getTokenizedUrl(jitsiServerUrl: organization.jitsiUrl))
            }
        }
    }
}


