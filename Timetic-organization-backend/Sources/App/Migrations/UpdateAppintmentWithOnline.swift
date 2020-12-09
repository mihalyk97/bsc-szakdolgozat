import Foundation
import Vapor
import Fluent
import PostgresKit

struct UpdateAppintmentWithOnline: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("appointments")
            .deleteField("consultation_url")
            .field("is_online", .bool)
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("appointments")
            .deleteField("is_online")
            .field("consultation_url", .string)
            .update()
    }
}
