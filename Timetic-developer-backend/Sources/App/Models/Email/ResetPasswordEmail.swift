import Foundation

struct ResetPasswordEmail: Codable {
    let code: Int
    static let templateName = "ResetPasswordEmail"
    init(code: Int) {
        self.code = code
    }
}

