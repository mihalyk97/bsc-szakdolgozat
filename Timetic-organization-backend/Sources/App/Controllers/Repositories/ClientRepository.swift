import Foundation
import Fluent
import Vapor

struct ClientRepository {
    static func getClients(db: Database) -> EventLoopFuture<[Client]> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$clients.query(on: db)
                .with(\.$personalInfos)
                .all()
        }
    }
    
    static func getClientById(_ id: UUID, db: Database) -> EventLoopFuture<Client> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$clients.query(on: db)
                .filter(\.$id == id)
                .with(\.$personalInfos)
                .first()
                .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.client))
        }
    }
    
    private static func tryGetClientById(_ id: UUID, db: Database) -> EventLoopFuture<Client?> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$clients.query(on: db)
                .filter(\.$id == id)
                .with(\.$personalInfos)
                .first()
        }
    }
    
    static func createOrModifyClient(_ employee: Employee?=nil, clientData: CommonClient, db: Database) throws -> EventLoopFuture<Client> {
        // Checks if the employee has the right to create/modify a client.
        if let employee = employee {
            guard employee.canAddClient else {
                throw Abort(.badRequest, reason: AbortReason.InconsistentData.Employee.clientCreationRight)
            }
        }
 
        return OrganizationRepository.getOrganization(db: db).throwingFlatMap { organization in
            // If it is a new client addition, checks if anyone has already been registered with the given email address
            if clientData._id == nil, organization.clients.contains(where: { registeredClient in
                return registeredClient.email == clientData.email
            }) {
                throw Abort(.conflict, reason: AbortReason.InconsistentData.Email.exists)
            }
            else {
                // Number of personalinfos has to be the same as the organization needs
                guard clientData.personalInfos.count == organization.clientPersonalInfoFields.count else {
                    throw Abort(.badRequest, reason: AbortReason.ParameterError.missingClientPersonalInfos)
                }
                return Self.tryGetClientById(UUID(uuidString: clientData._id ?? "") ?? UUID(), db: db).throwingFlatMap { clientFromDb in
                    if let clientDataId = clientData._id,
                          let clientFromDb = clientFromDb,
                          clientDataId != clientFromDb.id!.uuidString  {
                        throw Abort(.badRequest)
                    }
                    let client = clientData.toModel(from: clientFromDb)
                    client.$organization.id = organization.id!

                    return client.save(on: db).throwingFlatMap {
                        let id = try! client.requireID()
                        
                        // When client is created, personalinfos have to be created and assigned to the client
                        let personalInfos = clientData.personalInfos.enumerated()
                        let personalInfosToSave = try personalInfos.compactMap { info in
                            try PersonalInfo(
                                key: info.element.key,
                                value: info.element.value,
                                client: client)
                            
                        }
                        
                        return client.$personalInfos.create(personalInfosToSave, on: db).flatMap {
                            // It is neccessary becuse relations need to be loaded in client.
                            return Self.getClientById(id, db: db).map { client in
                                return client
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getClientByEmail(_ email: String, db: Database) -> EventLoopFuture<Client> {
        return OrganizationRepository.getOrganization(db: db).flatMapThrowing { organization in
            if let client = organization.clients.first(where: { registeredClient in
                return registeredClient.email == email
            }) {
                return client
            }
            else {
                throw Abort(.notFound, reason: AbortReason.NotFound.client)
            }
        }
    }
    
    static func deleteClientById(_ id: UUID, db: Database) -> EventLoopFuture<Void> {
        Self.getClientById(id, db: db).flatMap { client in
            return client.$appointments.load(on: db).flatMap {
                // When client is removed, all assigned appointments have to be removed.
                var deleteFutures: [EventLoopFuture<Void>] = []
                deleteFutures.append(contentsOf: client.appointments.compactMap { appointment in
                    return appointment.delete(on: db)
                })
                // When client is removed, all personalinfos have to be removed.
                deleteFutures.append(contentsOf: client.personalInfos.compactMap { info in
                    return info.delete(on: db)
                })
                return EventLoopFuture<Void>.whenAllSucceed(deleteFutures, on: db.eventLoop).flatMap { _ in
                    return client.delete(on: db)
                }
            }
        }
    }
}
