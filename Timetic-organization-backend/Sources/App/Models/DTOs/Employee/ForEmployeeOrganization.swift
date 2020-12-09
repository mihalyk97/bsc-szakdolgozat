import Foundation
import Vapor

public struct ForEmployeeOrganization: Content {

    public var _id: String
    public var clientPersonalInfoFields: [String]

    public init(_id: String, clientPersonalInfoFields: [String]) {
        self._id = _id
        self.clientPersonalInfoFields = clientPersonalInfoFields
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case clientPersonalInfoFields
    }
    
    init(model: Organization) throws {
        self._id = try model.requireID().uuidString
        self.clientPersonalInfoFields = model.clientPersonalInfoFields
    }
}

