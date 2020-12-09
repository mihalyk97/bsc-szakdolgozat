@testable import App
import XCTVapor
import Foundation

final class PasswordResetTests: XCTestCase {
    let email = "eszty.bajmoczy@gmail.com"

    func testResetPassword() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let passwordReset = try PasswordRepository.setResetPasswordForEmployee(email, db: app.db).wait()
        let newPassword = "2020ujJelszo"
        let passwordResetData = CommonPasswordReset(email: email, newPassword: newPassword, code: passwordReset.validationCode)
        
        try PasswordRepository.resetPassword(passwordResetData, db: app.db).wait()
        
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        XCTAssertNotNil(employee.hashedPassword)
        
        let passwordResetResult = try Bcrypt.verify(newPassword, created: employee.hashedPassword!)
        XCTAssertTrue(passwordResetResult)
    }
    
    func testResetPasswordWrongCode() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let passwordReset = try PasswordRepository.setResetPasswordForEmployee(email, db: app.db).wait()
        let newPassword = "2020ujJelszo"
        let passwordResetData = CommonPasswordReset(email: email, newPassword: newPassword, code: passwordReset.validationCode - 100)
        XCTAssertThrowsError(try PasswordRepository.resetPassword(passwordResetData, db: app.db).wait())
    }
    
    func testResetPasswordWrongEmail() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let passwordReset = try PasswordRepository.setResetPasswordForEmployee(email, db: app.db).wait()
        let newPassword = "2020ujJelszo"
        let otherEmail = "ezegymasikemail@szolgaltato.com"
        
        let passwordResetData = CommonPasswordReset(email: otherEmail, newPassword: newPassword, code: passwordReset.validationCode)
        XCTAssertThrowsError(try PasswordRepository.resetPassword(passwordResetData, db: app.db).wait())
    }
}
