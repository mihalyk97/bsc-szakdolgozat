import Fluent
import Vapor

final class Organization: Model, Content {
    static let schema = "organizations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "server_url")
    var serverUrl: String
    
    @Siblings(through: UserOrganization.self, from: \.$organization, to: \.$user)
    public var users: [User]
    
    init() { }
    
    init(id: UUID? = nil, name: String, serverUrl: String) {
        self.id = id
        self.name = name
        self.serverUrl = serverUrl
    }
}
