import Foundation
import Vapor
import Fluent

struct OrganizationRepository {
    static func getOrganization(db: Database) -> EventLoopFuture<Organization> {
        return Self.organizationQuery(db: db)
            .first()
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.organization))
    }
    
    static func getOrganizations(db: Database) -> EventLoopFuture<[Organization]> {
        return Self.organizationQuery(db: db).all()
    }
    
    static func modifyOrganization(_ organizationData: ForAdminOrganization, db: Database) -> EventLoopFuture<Organization> {
        return Self.getOrganization(db: db).throwingFlatMap { organization in
            let modifiedOrganization = organizationData.toModel(from: organization)
            // Modifies default contact details too.
            return try EmployeeRepository.createOrModifyEmployee(organizationData.defaultContact, db: db).flatMap { _ in
                return modifiedOrganization.save(on: db).flatMap {
                    return Self.getOrganization(db: db)
                }
            }
        }
    }
    
    // Creates query that contains all required connections loaded.
    private static func organizationQuery(db: Database) -> QueryBuilder<Organization> {
        return Organization.query(on: db)
            .with(\.$activities) { activity in
                activity.with(\.$employees)
            }
            .with(\.$clients) { client in
                client.with(\.$personalInfos)
            }
            .with(\.$employees) { employee in
                employee.with(\.$activities)
            }
            .with(\.$appointments) { appointment in
                appointment.with(\.$employee)
            }
    }

}
