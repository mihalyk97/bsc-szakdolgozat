import Foundation
import Vapor
import Fluent

final class Client: Model, Content {
    static let schema = "clients"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @Children(for: \.$client)
    var personalInfos: [PersonalInfo]
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "phone")
    var phone: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "hashed_password")
    var hashedPassword: String?
    
    @Field(key: "refresh_token")
    var refreshToken: String?
    
    @Parent(key: "organization_id")
    var organization: Organization
    
    @Children(for: \.$client)
    var appointments: [Appointment]
    
    init() { }
    
    init(name: String, email: String, phone: String) {
        self.id = nil
        self.createdAt = nil
        self.name = name
        self.email = email
        self.phone = phone
        self.hashedPassword = nil
        self.refreshToken = nil
    }
}

extension Client: Authenticatable { }
