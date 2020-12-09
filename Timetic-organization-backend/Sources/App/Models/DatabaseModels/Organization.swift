import Foundation
import Vapor
import Fluent

final class Organization: Model, Content {
    static let schema = "organizations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "addresses")
    var addresses: [String]
    
    @Field(key: "details")
    var details: String
    
    @Field(key: "can_client_contact_employees")
    var canClientContactEmployees: Bool
    
    @Field(key: "client_personal_info_fields")
    var clientPersonalInfoFields: [String]
    
    @Field(key: "jitsi_url")
    var jitsiUrl: String
    
    @Children(for: \.$organization)
    var clients: [Client]
    
    @Children(for: \.$organization)
    var employees: [Employee]
    
    @Children(for: \.$organization)
    var appointments: [Appointment]
    
    @Children(for: \.$organization)
    var activities: [Activity]
    
    init() { }
}
