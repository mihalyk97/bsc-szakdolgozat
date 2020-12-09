import Foundation

struct Configuration: Codable {
    private let jitsiURL: String
    private let details: String
    private let defaultContact: Person
    private let addresses: [String]
    private let canClientContactEmployees: Bool
    private let name: String
    private let clientPersonalInfoFields: [String]
    private let admin: Person
    
    enum CodingKeys: String, CodingKey {
        case jitsiURL = "jitsiUrl"
        case details, defaultContact, addresses, canClientContactEmployees, name, clientPersonalInfoFields, admin
    }
    
    struct Person: Codable {
        let email, phone, name: String
    }
    
    func getOrganization() -> Organization {
        let organization = Organization()
        organization.jitsiUrl = self.jitsiURL
        organization.details = self.details
        organization.addresses = self.addresses
        organization.canClientContactEmployees = self.canClientContactEmployees
        organization.name = self.name
        organization.clientPersonalInfoFields = self.clientPersonalInfoFields
        return organization
    }
    
    func getAdmin() throws -> Employee {
        return try Employee(name: self.admin.name,
                        canAddClient: true,
                        role: EmployeeRole.admin,
                        email: self.admin.email,
                        phone: self.admin.phone)
    }
    
    func getDefaultContact() throws -> Employee {
        return try Employee(name: self.defaultContact.name,
                        canAddClient: false,
                        role: EmployeeRole.defaultContact,
                        email: self.defaultContact.email,
                        phone: self.defaultContact.phone)
    }
}
