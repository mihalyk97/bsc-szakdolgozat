import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("created_at", .double, .required)
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("hashed_password", .string, .required)
            .field("is_admin", .bool, .required)
            .field("refresh_token", .string)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
