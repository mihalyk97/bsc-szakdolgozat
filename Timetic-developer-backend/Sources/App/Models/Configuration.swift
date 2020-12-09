import Foundation

struct Configuration: Codable {
    private let adminName: String
    private let adminEmail: String
    
    enum CodingKeys: String, CodingKey {
        case adminName, adminEmail
    }
    
    func getAdmin() throws -> User {
        return try User(name: self.adminName,
                        email: self.adminEmail,
                        isAdmin: true)
    }
}
