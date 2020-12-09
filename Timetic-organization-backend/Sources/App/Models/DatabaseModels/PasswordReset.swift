import Foundation
import Vapor
import Fluent

final class PasswordReset: Model, Content {
    static let schema = "password_resets"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "subject_email")
    var subjectEmail: String
    
    @Field(key: "validation_code")
    var validationCode: Int
    
    init() { }
    
    init(subjectEmail: String) {
        self.id = nil
        self.subjectEmail = subjectEmail
        self.validationCode = Int.random(in: 100000 ..< 1000000)
    }
    
    func resetCode() {
        self.validationCode = Int.random(in: 100000 ..< 1000000)
    }
}
