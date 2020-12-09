import Foundation
import Vapor

public struct ForClientOrganization: Content {
    public var _id: String?
    public var name: String
    public var details: String
    public var isClientRegistered: Bool
    public var employees: [CommonEmployee]
    public var clientPersonalInfoFields: [String]

    public init(_id: String?, name: String, details: String, isClientRegistered: Bool, employees: [CommonEmployee], clientPersonalInfoFields: [String]) {
        self._id = _id
        self.name = name
        self.details = details
        self.isClientRegistered = isClientRegistered
        self.employees = employees
        self.clientPersonalInfoFields = clientPersonalInfoFields
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
        case details
        case isClientRegistered
        case employees
        case clientPersonalInfoFields
    }
}

