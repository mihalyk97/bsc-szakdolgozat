import Foundation
import Vapor
import Fluent

struct ConfigurationRepository {
    static func checkConfigIfLoaded(app: Application) -> EventLoopFuture<Void> {
        // Only one organization is allowed to be in the database.
        return OrganizationRepository.getOrganizations(db: app.db).flatMap { organizations in
            switch(organizations.count) {
                case 0:
                    app.logger.info(.init(stringLiteral: Log.AppConfig.loadConfig))
                    return Self.loadConfig(app: app)
                case 1:
                    return app.db.eventLoop.makeSucceededFuture(())
                default:
                    fatalError(FatalErrorReason.moreThanOneOrganization)
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
        
        let organization = configuration.getOrganization()
        if !organization.addresses.contains("Online") {
            organization.addresses.append("Online")
        }
        let admin = try! configuration.getAdmin()
        let defaultContact = try! configuration.getDefaultContact()

        return organization.create(on: app.db).flatMap {
            return organization.$employees.create([admin, defaultContact], on: app.db)
        }
    }
}
