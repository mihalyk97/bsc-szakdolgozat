import Foundation
import Vapor

struct CommonPasswordReset: Content {
    var email: String
    var newPassword: String
    var code: Int
}
