import Foundation
import Vapor
import Fluent

struct CreateTestData: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        try! User(name: "Kristóf", email: "mihaly.kristof97@gmail.com", password: "Ab123456", isAdmin: true).create(on: database)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.makeSucceededFuture(())
    }
    
}

