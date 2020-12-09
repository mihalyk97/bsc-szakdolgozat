import Fluent

struct CreateEmployeeActivity: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("employee+activity")
            .id()
            .field("activity_id", .uuid, .required, .references("activities", "id"))
            .field("employee_id", .uuid, .required, .references("employees", "id"))
            .unique(on: "activity_id", "employee_id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("employee+activity").delete()
    }
}
