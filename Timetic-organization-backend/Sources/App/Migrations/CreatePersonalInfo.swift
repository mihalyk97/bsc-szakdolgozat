import Fluent

struct CreatePersonalInfo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("personal_infos")
            .id()
            .field("key", .string, .required)
            .field("value", .string, .required)
            .field("client_id", .uuid, .required, .references("clients", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("personal_infos").delete()
    }
}

