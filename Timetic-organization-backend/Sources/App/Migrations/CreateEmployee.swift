import Fluent

struct CreateEmployee: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("employees")
            .id()
            .field("created_at", .double, .required)
            .field("name", .string, .required)
            .field("can_add_client", .bool, .required)
            .field("role", .string, .required)
            .field("email", .string, .required)
            .field("phone", .string, .required)
            .field("hashed_password", .string)
            .field("refresh_token", .string)
            .field("organization_id", .uuid, .required, .references("organizations", "id"))
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("employees").delete()
    }
}
