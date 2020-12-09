import Foundation
import Fluent
import Vapor

struct EmployeeRepository {
    static func getEmployeeById(_ id: UUID, db: Database) -> EventLoopFuture<Employee> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$employees.query(on: db)
                .filter(\.$id == id)
                .with(\.$activities)
                .first()
                .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.employee))
        }
    }
    
    private static func tryGetEmployeeById(_ id: UUID, db: Database) -> EventLoopFuture<Employee?> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$employees.query(on: db)
                .filter(\.$id == id)
                .with(\.$activities)
                .first()
        }
    }
    
    static func getEmployees(roles: [EmployeeRole], db: Database) -> EventLoopFuture<[Employee]> {
        // Employees can be filtered by their roles
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$employees.query(on: db)
                .with(\.$activities)
                .all()
                .map { employees in
                    return employees.filter { employee in
                        return roles.contains(employee.role)
                    }
                }
        }
    }
    
    static func getDefaultContact(db: Database) -> EventLoopFuture<Employee> {
        return Self.tryGetDefaultContact(db: db)
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.defaultContact))
    }
    
    private static func tryGetDefaultContact(db: Database) -> EventLoopFuture<Employee?> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            return organization.$employees.query(on: db)
                .with(\.$activities)
                .filter(\.$role == .defaultContact)
                .first()
        }
    }
    
    static func getEmployeeByEmail(_ email: String, db: Database) -> EventLoopFuture<Employee> {
        return OrganizationRepository.getOrganization(db: db).flatMapThrowing { organization in
            if let employee = organization.employees.first(where: { registeredEmployee in
                return registeredEmployee.email == email
            }) {
                return employee
            }
            else {
                throw Abort(.notFound, reason: AbortReason.NotFound.employee)
            }
        }
    }
    
    static func deleteEmployeeById(_ id: UUID, db: Database) -> EventLoopFuture<Void> {
        return Self.getEmployeeById(id, db: db).flatMap { employee in
            // Appointments assigned to the employee also need to be removed
            return employee.$appointments.load(on: db).flatMap { _ in
                var deleteFutures: [EventLoopFuture<Void>] = []
                deleteFutures.append(contentsOf: employee.appointments.compactMap { appointment in
                    return appointment.delete(on: db)
                })
                // Deleted employee has to be detached from the activities
                return EventLoopFuture<Void>.whenAllSucceed(deleteFutures, on: db.eventLoop).and(employee.$activities.detach(employee.activities, on: db)).flatMap { _ in
                        return employee.delete(on: db)
                    }
            }
        }
    }
    
    static func setPasswordForEmployee(_ password: String, email: String, db: Database) -> EventLoopFuture<Void> {
        return Self.getEmployeeByEmail(email, db: db).throwingFlatMap { employee in
            employee.hashedPassword = try Bcrypt.hash(password)
            return employee.save(on: db)
        }
    }
    
    static func createOrModifyEmployee(_ employeeData: CommonEmployee, db: Database) throws -> EventLoopFuture<Employee> {
        return OrganizationRepository.getOrganization(db: db).flatMap { organization in
            // If it is a new employee addition, checks if anyone has already been registered with the given email address
            if employeeData._id == nil, organization.employees.contains(where: { registeredEmployee in
                return registeredEmployee.email == employeeData.email
            }) {
                return db.eventLoop.makeFailedFuture(Abort(.conflict, reason: AbortReason.InconsistentData.Email.exists))
            }
            else {
                return Self.tryGetEmployeeById(UUID(uuidString: employeeData._id ?? "") ?? UUID(), db: db).throwingFlatMap { employeeFromDb in
                    if let employeeDataId = employeeData._id,
                          let employeeFromDb = employeeFromDb,
                          employeeDataId != employeeFromDb.id!.uuidString {
                        throw Abort(.badRequest)
                    }
                    
                    let employee = employeeData.toModel(from: employeeFromDb)
                    // For newly created employees, default values have to be set
                    if employeeData._id == nil {
                        employee.canAddClient = true
                        employee.role = .general
                        try employee.setPassword()
                        employee.$organization.id = organization.id!
                    }
                    return employee.save(on: db).throwingFlatMap {
                        // After saving the employee, connects all activities that have
                        // to be assigned, and remove the others.
                        var attachFutures: [EventLoopFuture<Void>] = []
                        organization.activities.forEach { activity in
                            if let activityId = try? activity.requireID().uuidString,
                               employeeData.activities.contains(where: { activityToAttach in
                                activityToAttach._id == activityId
                            })
                            {
                                attachFutures.append(activity.$employees.attach(employee, method: .ifNotExists, on: db))
                            } else {
                                attachFutures.append(activity.$employees.isAttached(to: employee, on: db).flatMap { attached in
                                    if attached {
                                        return employee.$appointments.load(on: db).flatMap {
                                            var appointmentDeleteFutures: [EventLoopFuture<Void>] = []
                                            let today = Date()
                                            // If an activity is detached from the employee,
                                            // then removes all future appointments assigned to the employee
                                            // and the activity.
                                            appointmentDeleteFutures.append(contentsOf: employee.appointments.compactMap { appointment in
                                                return appointment.$activity.load(on: db).flatMap {
                                                    if !appointment.isPrivate,
                                                       appointment.activity!.id! == activity.id!,
                                                       appointment.startsAt >= today {
                                                        return appointment.delete(on: db)
                                                    }
                                                    return db.eventLoop.makeSucceededFuture(())
                                                }
                                            })
                                            return EventLoopFuture<Void>.whenAllSucceed(appointmentDeleteFutures, on: db.eventLoop).and(activity.$employees.detach(employee, on: db)).map { _ in}
                                        }
                                    }
                                    return db.eventLoop.makeSucceededFuture(())
                                })
                            }
                        }
                        return EventLoopFuture<Void>.whenAllSucceed(attachFutures, on: db.eventLoop).flatMap { _ in
                            return employee.$activities.load(on: db).map {
                                employee
                            }
                        }
                    }
                }
                
            }
        }
    }
}
