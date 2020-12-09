import Foundation
import Vapor
import Fluent

enum EmployeeRole: String, Codable {
    case admin
    case defaultContact
    case general
}

final class Employee: Model, Content {
    static let schema = "employees"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "can_add_client")
    var canAddClient: Bool
    
    @Field(key: "role")
    var role: EmployeeRole
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "phone")
    var phone: String
    
    @Field(key: "hashed_password")
    var hashedPassword: String?
    
    @Field(key: "refresh_token")
    var refreshToken: String?
    
    @Parent(key: "organization_id")
    var organization: Organization

    @Siblings(through: EmployeeActivity.self, from: \.$employee, to: \.$activity)
    var activities: [Activity]
    
    @Children(for: \.$employee)
    var appointments: [Appointment]
    
    init() { }
    
    init(name: String, canAddClient: Bool, role: EmployeeRole, email: String, phone: String, password: String=UUID().uuidString) throws {
        self.id = nil
        self.createdAt = nil
        self.name = name
        self.canAddClient = canAddClient
        self.role = role
        self.email = email
        self.phone = phone
        self.hashedPassword = try Bcrypt.hash(password)
        self.refreshToken = nil
    }
    
    func setPassword(password: String = UUID().uuidString) throws {
        self.hashedPassword = try Bcrypt.hash(password)
    }
}

extension Employee: Authenticatable {}
