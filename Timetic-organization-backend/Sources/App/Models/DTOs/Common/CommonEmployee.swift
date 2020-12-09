import Foundation
import Vapor

public final class CommonEmployee: Content {
    public var _id: String?
    public var name: String
    public var phone: String
    public var email: String
    public var activities: [CommonActivity] = []

    public init(_id: String?, name: String, phone: String, email: String, activities: [CommonActivity]) {
        self._id = _id
        self.name = name
        self.phone = phone
        self.email = email
        self.activities = activities
    }
    
    init(model: Employee) throws {
        self._id = try model.requireID().uuidString
        self.name = model.name
        self.phone = model.phone
        self.email = model.email
        self.activities = try model.activities.compactMap { activity in
            try CommonActivity(model: activity)
            
        }
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
        case phone
        case email
        case activities
    }

    func toModel(from employee: Employee? = nil) -> Employee {
        let employee = employee ?? Employee()
        employee.name = self.name
        employee.phone = self.phone
        employee.email = self.email
        return employee
    }
}

extension CommonEmployee: NilValidatable { }
