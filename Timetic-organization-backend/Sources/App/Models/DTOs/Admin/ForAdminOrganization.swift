import Foundation
import Vapor

public final class ForAdminOrganization: Content {
    public var _id: String?
    public var name: String
    public var details: String
    public var canClientContactEmployees: Bool
    public var addresses: [String]
    public var clientPersonalInfoFields: [String]
    public var defaultContact: CommonEmployee
    public var jitsiUrl: String
    
    public init(_id: String?,
                name: String,
                details: String,
                canClientContactEmployees: Bool,
                addresses: [String],
                clientPersonalInfoFields: [String],
                defaultContact: CommonEmployee,
                jitsiUrl: String) {
        self._id = _id
        self.name = name
        self.details = details
        self.canClientContactEmployees = canClientContactEmployees
        self.addresses = addresses
        self.clientPersonalInfoFields = clientPersonalInfoFields
        self.defaultContact = defaultContact
        self.jitsiUrl = jitsiUrl
    }
    
    init(model: Organization, defaultContact: Employee) throws {
        self._id = try model.requireID().uuidString
        self.name = model.name
        self.details = model.details
        self.canClientContactEmployees = model.canClientContactEmployees
        self.addresses = model.addresses
        self.clientPersonalInfoFields = model.clientPersonalInfoFields
        self.defaultContact = try CommonEmployee(model: defaultContact)
        self.jitsiUrl = model.jitsiUrl
    }
    
    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case name
        case details
        case canClientContactEmployees
        case addresses
        case clientPersonalInfoFields
        case defaultContact
        case jitsiUrl
    }
    
    func toModel(from organization: Organization? = nil) -> Organization {
        let organization = organization ?? Organization()
        organization.name = self.name
        organization.details = self.details
        organization.canClientContactEmployees = self.canClientContactEmployees
        organization.addresses = self.addresses
        organization.clientPersonalInfoFields = self.clientPersonalInfoFields
        organization.jitsiUrl = self.jitsiUrl
        return organization
    }
    
}

extension ForAdminOrganization: NilValidatable { }
