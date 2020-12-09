import Foundation
import Vapor
import Fluent
import PostgresKit

struct UpdateOrganizationWithJitsiUrl: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let defaultValue = SQLColumnConstraintAlgorithm.default("")
        return database.schema("organizations")
            .field("jitsi_url", .string, .required, .sql(defaultValue))
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("organizations")
            .deleteField("jitsi_url")
            .update()
    }
}
