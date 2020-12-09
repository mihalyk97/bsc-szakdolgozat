import Foundation
import Vapor
import Fluent

final class UserOrganization: Model {
    static let schema = "user+organization"
    
    @ID(custom: "id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "organization_id")
    var organization: Organization
    
    init() { }
    
    init(id: UUID? = nil, user: User, organization: Organization) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.$organization.id = try organization.requireID()
    }
}
