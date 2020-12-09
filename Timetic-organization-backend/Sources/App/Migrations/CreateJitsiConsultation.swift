import Fluent

struct CreateJitsiConsultation: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("jitsi_consultations")
            .id()
            .field("subject", .string, .required)
            .field("token", .string, .required)
            .field("appointment_id", .uuid, .required, .references("appointments", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("jitsi_consultations").delete()
    }
}
