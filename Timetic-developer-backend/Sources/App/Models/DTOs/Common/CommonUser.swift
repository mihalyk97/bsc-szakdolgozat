import Foundation
import Vapor

struct CommonUser: Content {
    var _id: String?
    var name: String
    var email: String
    var registrationDate: Int64?
        
    init(model: User) throws {
        self._id = try model.requireID().uuidString
        self.name = model.name
        self.email = model.email
        self.registrationDate = model.createdAt?.milliseconds()
    }
    
    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case name
        case email
        case registrationDate
    }
}
