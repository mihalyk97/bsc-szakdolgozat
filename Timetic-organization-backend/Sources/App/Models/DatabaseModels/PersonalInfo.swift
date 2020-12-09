import Foundation
import Vapor
import Fluent

final class PersonalInfo: Model, Content {
    static let schema = "personal_infos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "key")
    var key: String
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "client_id")
    var client: Client
    
    init() { }
    
    init(key: String, value: String, client: Client) throws {
        self.id = nil
        self.key = key
        self.value = value
        self.$client.id = try client.requireID()
    }
    
    init(key: String, value: String) {
        self.id = nil
        self.key = key
        self.value = value
    }
}
