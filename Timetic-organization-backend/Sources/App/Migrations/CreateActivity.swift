import Fluent
import PostgresKit

struct CreateActivity: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let defaultValue = SQLColumnConstraintAlgorithm.default(false)
        return database.schema("activities")
            .id()
            .field("created_at", .double, .required)
            .field("title", .string, .required)
            .field("organization_id", .uuid, .required, .references("organizations", "id"))
            .field("is_disabled", .bool, .required, .sql(defaultValue))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("activities").delete()
    }
}
