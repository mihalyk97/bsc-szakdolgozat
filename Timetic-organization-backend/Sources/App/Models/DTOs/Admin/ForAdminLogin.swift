import Foundation
import Vapor

public struct ForAdminLogin: Content {
    public var email: String
    public var password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

