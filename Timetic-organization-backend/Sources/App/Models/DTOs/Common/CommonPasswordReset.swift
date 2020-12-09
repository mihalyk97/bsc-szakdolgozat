import Foundation
import Vapor

public struct CommonPasswordReset: Content {
    public var email: String
    public var newPassword: String
    public var code: Int
}
