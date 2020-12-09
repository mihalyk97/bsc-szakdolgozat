import Fluent
import FluentPostgresDriver
import Vapor
import Leaf
import Smtp

public func configure(_ app: Application) throws {
    
    app.logger.info(.init(stringLiteral: Log.AppConfig.starting))
    app.views.use(.leaf)
    app.logger.info(.init(stringLiteral: Log.AppConfig.leaf))
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    guard let jwtKey = Environment.get("JWT_APP_SECRET") else {
        fatalError(FatalErrorReason.jwtKeyMissing)
    }
    
    app.jwt.signers.use(.hs256(key: jwtKey))
    app.logger.info(.init(stringLiteral: Log.AppConfig.jwt))

    guard
        let hostname = Environment.get("DATABASE_HOST"),
        let portString = Environment.get("DATABASE_PORT"),
        let port = Int(portString),
        let username = Environment.get("DATABASE_USERNAME"),
        let password = Environment.get("DATABASE_PASSWORD"),
        let database = Environment.get("DATABASE_NAME")
    else {
        fatalError(FatalErrorReason.databaseConfigMissing)
    }
    
    app.databases.use(.postgres(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database
    ), as: .psql)
    
    app.logger.info(.init(stringLiteral: Log.AppConfig.database))

    if
        let dirPath = Environment.get("SSL_DIR"),
        let certPath = Environment.get("SSL_CERT"),
        let keyPath = Environment.get("SSL_KEY"),
        let certs = try? NIOSSLCertificate.fromPEMFile(dirPath+certPath)
            .map({ NIOSSLCertificateSource.certificate($0) }),
        let hostname = Environment.get("SSL_HOSTNAME"){
        
        let tls = TLSConfiguration.forServer(certificateChain: certs, privateKey: .file(dirPath+keyPath))
        
        app.http.server.configuration = .init(
            hostname: hostname,
            port: 8080,
            backlog: 256,
            reuseAddress: true,
            tcpNoDelay: true,
            responseCompression: .disabled,
            requestDecompression: .disabled,
            supportPipelining: false,
            supportVersions: Set<HTTPVersionMajor>([.two]),
            tlsConfiguration: tls,
            serverName: nil,
            logger: nil)
        app.logger.info(.init(stringLiteral: Log.AppConfig.tls))
    }
    
    guard
        let smtpServer = Environment.get("SMTP_URL"),
        let smtpEmail = Environment.get("SMTP_EMAIL"),
        let smtpPassword = Environment.get("SMTP_PASSWORD")
    else {
        fatalError(FatalErrorReason.smtpConfigMissing)
    }
    
    app.smtp.configuration.hostname = smtpServer
    app.smtp.configuration.username = smtpEmail
    app.smtp.configuration.password = smtpPassword
    app.smtp.configuration.secure = .ssl
    app.logger.info(.init(stringLiteral: Log.AppConfig.smtp))

    app.migrations.add(CreateUser())
    app.migrations.add(CreateOrganization())
    app.migrations.add(CreateTestData())
    app.migrations.add(CreatePasswordReset())
    app.migrations.add(CreateUserOrganization())
    
    try app.autoMigrate().wait()
    app.logger.info(.init(stringLiteral: Log.AppConfig.migration))

    try ConfigurationRepository.checkConfigIfLoaded(app: app).wait()
    app.logger.info(.init(stringLiteral: Log.AppConfig.config))

    try routes(app)
    app.logger.info(.init(stringLiteral: Log.AppConfig.routes))
    
    app.logger.info(.init(stringLiteral: Log.AppConfig.started))
}
