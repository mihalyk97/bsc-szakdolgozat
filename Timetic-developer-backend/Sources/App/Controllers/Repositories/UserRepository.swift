import Foundation
import Vapor
import Fluent

struct UserRepository {
    static func getUsers(db: Database) -> EventLoopFuture<[User]> {
        return User.query(on: db).all()
    }
    
    static func getUserById(_ id: UUID, db: Database) -> EventLoopFuture<User> {
        return User.find(id, on: db).unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.user))
    }
    
    static func getUserByEmail(_ email: String, db: Database) -> EventLoopFuture<User> {
        return Self.tryGetUserByEmail(email, db: db)
            .unwrap(or: Abort(.notFound, reason: AbortReason.NotFound.user))
    }
    
    static func tryGetUserByEmail(_ email: String, db: Database) -> EventLoopFuture<User?> {
        return User.query(on: db)
            .filter(\.$email == email)
            .first()
    }
    
    static func createUser(userData: ForMobileUserRegistration, db: Database) throws -> EventLoopFuture<User> {
        
        let user = try User(
            name: userData.name,
            email: userData.email,
            password: userData.password)
        
        return user.create(on: db).map {
            user
        }
    }
    
    static func addOrganizationById(id: UUID, user: User, db: Database) throws -> EventLoopFuture<Void> {
        return OrganizationRepository.getOrganizationById(id, db: db).flatMap { organization in
            return user.$organizations.attach(organization, on: db)
        }
    }
    
    static func removeOrganizationById(id: UUID, user: User, db: Database) throws -> EventLoopFuture<Void> {
        return OrganizationRepository.getOrganizationById(id, db: db).flatMap { organization in
            return user.$organizations.detach(organization, on: db)
        }
    }
    
    static func getOrganizationsWhereRegistered(user: User, db: Database) throws -> EventLoopFuture<[Organization]> {
        return user.$organizations.load(on: db).map {
            return user.organizations
        }
    }
    
    static func deleteUser(_ id: UUID, db: Database) -> EventLoopFuture<Void> {
        return Self.getUserById(id, db: db).flatMap { user in
            return user.$organizations.load(on: db).flatMap {
                return user.$organizations.detach(user.organizations, on: db).flatMap {
                    return user.delete(on: db)
                }
            }
        }
    }
    
    static func setPassword(_ password: String, email: String, db: Database) -> EventLoopFuture<Void> {
        return Self.getUserByEmail(email, db: db).throwingFlatMap { user in
            user.hashedPassword = try Bcrypt.hash(password)
            return user.save(on: db)
        }
    }
}
