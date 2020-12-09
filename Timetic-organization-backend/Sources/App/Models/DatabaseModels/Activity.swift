import Vapor
import Fluent

final class Activity: Model, Content {
    static let schema = "activities"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "is_disabled")
    var isDisabled: Bool
    
    @Parent(key: "organization_id")
    var organization: Organization
    
    @Children(for: \.$activity)
    var appointments: [Appointment]
    
    @Siblings(through: EmployeeActivity.self, from: \.$activity, to: \.$employee)
    public var employees: [Employee]
    
    init() { }
    
    init(title: String) {
        self.title = title
    }
}
