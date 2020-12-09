import Foundation
import Vapor
import Fluent

struct ConfigurationRepository {
    static func checkConfigIfLoaded(app: Application) -> EventLoopFuture<Void> {
        return UserRepository.getUsers(db: app.db).flatMap { users in
            if users.isEmpty {
                app.logger.info(.init(stringLiteral: Log.AppConfig.loadConfig))
                return Self.loadConfig(app: app)
            } else {
                return app.db.eventLoop.makeSucceededFuture(())
            }
        }
    }
    
    private static func loadConfig(app: Application) -> EventLoopFuture<Void> {
        let workDir = app.directory.workingDirectory
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: workDir)
                                .appendingPathComponent(ApplicationInfo.resourcesFolder, isDirectory: true)
                                .appendingPathComponent(ApplicationInfo.configFile, isDirectory: false)),
              let configuration = try? JSONDecoder().decode(Configuration.self, from: data) else {
            fatalError(FatalErrorReason.inconsistentConfiguration)
        }
        
        let admin = try! configuration.getAdmin()

        return admin.create(on: app.db)
    }
}
