import Fluent

struct CreateAppointment: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("appointments")
            .id()
            .field("created_at", .double, .required)
            .field("details", .string, .required)
            .field("starts_at", .datetime, .required)
            .field("ends_at", .datetime, .required)
            .field("private", .bool, .required)
            .field("place", .string)
            .field("price", .double)
            .field("is_online", .bool)
            .field("client_id", .uuid, .references("clients", "id"))
            .field("employee_id", .uuid, .required, .references("employees", "id"))
            .field("activity_id", .uuid, .references("activities", "id"))
            .field("organization_id", .uuid, .required, .references("organizations", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("appointments").delete()
    }
}
