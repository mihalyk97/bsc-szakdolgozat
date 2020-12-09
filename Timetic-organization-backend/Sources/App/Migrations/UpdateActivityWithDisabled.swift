import Foundation
import Vapor
import Fluent
import PostgresKit

struct UpdateActivityWithDisabled: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let defaultValue = SQLColumnConstraintAlgorithm.default(false)
        return database.schema("activities")
            .field("is_disabled", .bool, .required, .sql(defaultValue))
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("activities")
            .deleteField("is_disabled")
            .update()
    }
}
