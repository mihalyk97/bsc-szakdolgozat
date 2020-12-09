import Foundation
import Vapor
import Fluent

struct OrganizationRepository {
    static func getOrganizations(db: Database) -> EventLoopFuture<[Organization]> {
        return Organization.query(on: db).all()
    }
    
    static func getOrganizationById(_ id: UUID, db: Database) -> EventLoopFuture<Organization> {
        return Organization.find(id, on: db).unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.organization))
    }
    
    static func getOrganizationByURL(_ url: String, db: Database) -> EventLoopFuture<Organization> {
        return Self.tryGetOrganizationByURL(url, db: db)
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.organization))
    }
    
    private static func tryGetOrganizationByURL(_ url: String, db: Database) -> EventLoopFuture<Organization?> {
        return Organization.query(on: db)
            .filter(\.$serverUrl == url)
            .first()
    }

    static func createOrModifyOrganization(organizationData: CommonOrganization, db: Database) throws -> EventLoopFuture<Organization> {
        
        return Self.getOrganizations(db: db).throwingFlatMap { organizations in
            
            var organization = Organization()
            
            if let organizationIdString = organizationData._id, let organizationId = UUID(uuidString: organizationIdString) {
                let organizationFromDb = organizations.first { org in
                    org.id! == organizationId
                }
                
                if organizationFromDb != nil {
                    organization = organizationFromDb!
                } else {
                    guard organizations.first(where: { org in
                        org.serverUrl == organizationData.serverUrl
                    }) == nil else {
                        throw Abort(.conflict, reason: AbortReason.InconsistentData.Organization.exists)
                    }
                }
            }
            
            organization.name = organizationData.name
            organization.serverUrl = organizationData.serverUrl
            
            return organization.save(on: db).map {
                organization
            }
        }
    }
    
    static func deleteOrganization(_ id: UUID, db: Database) -> EventLoopFuture<Void> {
        return Self.getOrganizationById(id, db: db).flatMap { organization in
            return organization.$users.load(on: db).flatMap {
                return organization.$users.detach(organization.users, on: db).flatMap {
                    return organization.delete(on: db)
                }
            }
        }
    }
}
