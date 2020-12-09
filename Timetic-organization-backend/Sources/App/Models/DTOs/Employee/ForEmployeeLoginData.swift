import Foundation
import Vapor

public struct ForEmployeeLoginData: Content {
    public var employee: CommonEmployee
    public var refreshToken: CommonToken
    
    init(employee: Employee, token: String) throws {
        self.employee = try CommonEmployee(model: employee)
        self.refreshToken = CommonToken(token: token)
    }
}
