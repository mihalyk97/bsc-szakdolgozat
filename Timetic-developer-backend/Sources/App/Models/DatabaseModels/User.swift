import Fluent
import Vapor
import Foundation

final class User: Model {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "hashed_password")
    var hashedPassword: String
    
    @Field(key: "is_admin")
    var isAdmin: Bool
    
    @Field(key: "refresh_token")
    var refreshToken: String?
   
    @Siblings(through: UserOrganization.self, from: \.$user, to: \.$organization)
    public var organizations: [Organization]
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String, password: String=UUID().uuidString, isAdmin: Bool = false) throws {
        self.id = id
        self.createdAt = nil
        self.name = name
        self.email = email
        self.hashedPassword = try Bcrypt.hash(password)
        self.isAdmin = isAdmin
        self.refreshToken = nil
    }
}

extension User: Authenticatable { }
