import Foundation
import Vapor

struct ForMobileLoginData: Content {
    var user: CommonUser
    var refreshToken: CommonToken
    
    init(user: User, token: String) throws {
        self.user = try CommonUser(model: user)
        self.refreshToken = CommonToken(token: token)
    }
}
