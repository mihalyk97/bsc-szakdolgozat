import Foundation
import Vapor
import Fluent

struct ActivityRepository {
    static func getActivities(db: Database) -> EventLoopFuture<[Activity]> {
        return OrganizationRepository.getOrganization(db: db).map { organization in
            // Disabled activities should not be listed
            // beacuse they are meant to be the deleted activities.
            return organization.activities.filter { activity in
                return !activity.isDisabled
            }
        }
    }
    
    static func getActivityById(_ id: UUID, db: Database) -> EventLoopFuture<Activity> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$activities.query(on: db)
                .filter(\.$id == id)
                .first()
                .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.activity))
        }
    }
    
    static func deleteActivityById(_ id: UUID, db: Database) -> EventLoopFuture<Void> {
        return Self.getActivityById(id, db: db).flatMap { activity in
            return activity.$employees.load(on: db).flatMap {
                var deleteFutures: [EventLoopFuture<Void>] = []
                let today = Date()
                return activity.$appointments.load(on: db).flatMap {
                    // When an activity is deleted, all future appointments that
                    // are assigned to the activity have to be removed
                    deleteFutures.append(contentsOf: activity.appointments.compactMap { appointment in
                        if appointment.startsAt >= today {
                            return appointment.delete(on: db)
                        }
                        return db.eventLoop.makeSucceededFuture(())
                    })
                    // Deleted activity has to be detached from the employees
                    return EventLoopFuture<Void>.whenAllSucceed(deleteFutures, on: db.eventLoop).flatMap {_ in 
                        return activity.$employees.detach(activity.employees, on: db).flatMap {
                            // Mark the activity as disabled beacuse past appointments
                            // may have been assigned to the activity, so activity can't actually be removed 
                            activity.isDisabled = true
                            return activity.save(on: db)
                        }
                    }
                }
            }
        }
    }
    
    static func createActivity(
        _ activityData: CommonActivity,
        db: Database) -> EventLoopFuture<Activity> {
        
        let activity = activityData.toModel(from: Activity())
        
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            // Safe without requireID, because organization has to exist.
            activity.$organization.id = organization.id!
            activity.isDisabled = false
            return activity.create(on: db).flatMap {
                let id = try! activity.requireID()
                return Self.getActivityById(id, db: db).map { createdActivity in
                    createdActivity
                }
            }
        }
    }
}
