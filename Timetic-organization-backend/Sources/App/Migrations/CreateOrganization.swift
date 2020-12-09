import Fluent
import PostgresKit

struct CreateOrganization: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let defaultValue = SQLColumnConstraintAlgorithm.default("")
        return database.schema("organizations")
            .id()
            .field("created_at", .double, .required)
            .field("name", .string, .required)
            .field("addresses", .array(of: .string), .required)
            .field("details", .string, .required)
            .field("can_client_contact_employees", .bool, .required)
            .field("client_personal_info_fields", .array(of: .string), .required)
            .field("jitsi_url", .string, .required, .sql(defaultValue))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("organizations").delete()
    }
}
