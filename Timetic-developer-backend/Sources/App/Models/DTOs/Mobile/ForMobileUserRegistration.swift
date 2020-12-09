import Foundation
import Vapor

final class ForMobileUserRegistration: Content {
    var name: String
    var email: String
    var password: String
}

extension ForMobileUserRegistration: NilValidatable { }
