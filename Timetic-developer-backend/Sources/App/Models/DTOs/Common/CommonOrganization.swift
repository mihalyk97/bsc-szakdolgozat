import Foundation
import Vapor

final class CommonOrganization: Content {
    var _id: String?
    var name: String
    var serverUrl: String
        
    init(model: Organization) throws {
        self._id = try model.requireID().uuidString
        self.name = model.name
        self.serverUrl = model.serverUrl
    }
    
    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case name
        case serverUrl
    }
}

extension CommonOrganization: NilValidatable { }
