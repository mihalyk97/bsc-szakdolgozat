import Fluent

struct CreateOrganization: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("organizations")
            .id()
            .field("created_at", .double, .required)
            .field("name", .string, .required)
            .field("server_url", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("organizations").delete()
    }
}
