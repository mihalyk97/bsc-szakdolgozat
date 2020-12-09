import Foundation
import Vapor
import Fluent

final class Appointment: Model, Content {
    static let schema = "appointments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @Field(key: "details")
    var details: String
    
    @Field(key: "starts_at")
    var startsAt: Date
    
    @Field(key: "ends_at")
    var endsAt: Date
    
    @Field(key: "private")
    var isPrivate: Bool
    
    @OptionalField(key: "place")
    var place: String?
    
    @Field(key: "price")
    var price: Double?
    
    @Field(key: "is_online")
    var isOnline: Bool?
    
    @OptionalParent(key: "client_id")
    var client: Client?
    
    @Parent(key: "employee_id")
    var employee: Employee
    
    @OptionalParent(key: "activity_id")
    var activity: Activity?
    
    @Parent(key: "organization_id")
    var organization: Organization
    
    init() { }
}

extension Appointment: NilValidatable { }
