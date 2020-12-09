import Foundation
import Vapor
import Fluent

final class EmployeeActivity: Model {
    static let schema = "employee+activity"
    
    @ID(custom: "id")
    var id: UUID?
    
    @Parent(key: "employee_id")
    var employee: Employee
    
    @Parent(key: "activity_id")
    var activity: Activity
    
    init() { }
    
    init(id: UUID? = nil, employee: Employee, activity: Activity) throws {
        self.id = id
        self.$employee.id = try employee.requireID()
        self.$activity.id = try activity.requireID()
    }
}
