import Foundation
import Vapor

public struct ForClientRefreshToken: Content {
    public var email: String
    public var refreshToken: String
}
