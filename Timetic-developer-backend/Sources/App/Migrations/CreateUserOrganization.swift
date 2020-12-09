import Fluent

struct CreateUserOrganization: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user+organization")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("organization_id", .uuid, .required, .references("organizations", "id"))
            .unique(on: "user_id", "organization_id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user+organization").delete()
    }
}
