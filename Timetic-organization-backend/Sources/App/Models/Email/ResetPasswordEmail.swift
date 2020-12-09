import Foundation

struct ResetPasswordEmail: Codable {
    let code: Int
    let organizationName: String
    static let templateName = "ResetPasswordEmail"
    init(code: Int, organizationName: String) {
        self.code = code
        self.organizationName = organizationName
    }
}

