import Fluent

struct CreatePasswordReset: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(PasswordReset.schema)
                    .id()
                    .field("subject_email", .string, .required)
                    .field("validation_code", .int, .required)
                    .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(PasswordReset.schema).delete()
    }
}
