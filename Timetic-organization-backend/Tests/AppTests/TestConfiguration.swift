@testable import App
import Fluent
import FluentSQLiteDriver
import Vapor
import JWT
import Smtp
import Leaf


struct TestConfiguration {
    private static let jwtKey = "TESTKEY"

    private static func configure(_ app: Application) throws {
        
        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.starting))

        app.views.use(.leaf)
        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.leaf))

        app.jwt.signers.use(.hs256(key: Self.jwtKey))
        JitsiRepository.signers = app.jwt.signers
        
        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.jwt))

        app.databases.use(.sqlite(.memory), as: .sqlite)
        
        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.database))

        app.migrations.add(CreateOrganization())
        app.migrations.add(CreateActivity())
        app.migrations.add(CreateClient())
        app.migrations.add(CreateEmployee())
        app.migrations.add(CreateAppointment())
        app.migrations.add(CreateEmployeeActivity())
        app.migrations.add(CreatePersonalInfo())
        app.migrations.add(CreatePasswordReset())
        app.migrations.add(CreateJitsiConsultation())
        
        try app.autoMigrate().wait()
        
        try addNewData(app: app, db: app.db)
        
        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.migration))

        try ConfigurationRepository.checkConfigIfLoaded(app: app).wait()
        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.config))

        try routes(app)
        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.routes))

        app.logger.info(.init(stringLiteral: Log.AppConfig.test + Log.AppConfig.started))
    }
    
    private static func addNewData(app: Application, db: Database) throws {
        let o = Organization()
        o.name = "Kozmetika"
        o.addresses=["1117 Budapest, Béke út 24.", "Ügyfélnél"]
        o.details = "Részletek a cégről"
        o.canClientContactEmployees = true
        o.clientPersonalInfoFields = ["Taj szám", "Gyógyszerallergia"]
        o.jitsiUrl = "https://optipus.ddns.net:8071"
        try o.create(on: db).wait()
        
        let ac = Activity(title: "Arckezelés")
        ac.$organization.id = o.id!
        
        let ac2 = Activity(title: "Gyantázás")
        ac2.$organization.id = o.id!
        
        let ac3 = Activity(title: "Sminkelés")
        ac3.$organization.id = o.id!
        
        try ac.create(on: db).wait()
        try ac2.create(on: db).wait()
        try ac3.create(on: db).wait()
        
        let cl = Client(name: "Simon Adél",
                        email: "simonadél@gmail.com",
                        phone: "+36701212345")
        cl.$organization.id = o.id!
        try cl.create(on: db).wait()
        
        let pi = PersonalInfo(key: "Taj szám", value: "123456789")
        let pi2 = PersonalInfo(key: "Gyógyszerallergia", value: "Nincs")
        
        try cl.$personalInfos.create([pi, pi2], on: db).wait()
        
        let em = try! Employee(name: "Bajmóczy Eszter",
                               canAddClient: true,
                               role: .general,
                               email: "eszty.bajmoczy@gmail.com",
                               phone: "+36209876543",
                               password: "Ab123456")
        em.$organization.id = o.id!
        
        let em2 = try! Employee(name: "Mihály Kristóf",
                                canAddClient: true,
                                role: .admin,
                                email: "mihaly.kristof97@gmail.com",
                                phone: "+36309876543",
                                password: "Ab123456")
        em2.$organization.id = o.id!
        
        let em3 = try! Employee(name: "Simon Anna",
                                canAddClient: false,
                                role: .defaultContact,
                                email: "peldaanna@peldaemail.com",
                                phone: "+36709876543",
                                password: "")
        em3.$organization.id = o.id!
        
        let em4 = try! Employee(name: "Kis Ilona",
                               canAddClient: true,
                               role: .general,
                               email: "peldailona@peldaemail.com",
                               phone: "+36209876543",
                               password: "Ab123456")
        em4.$organization.id = o.id!
        
        try em.create(on: db).wait()
        try em2.create(on: db).wait()
        try em3.create(on: db).wait()
        try em4.create(on: db).wait()
        
        try em.$activities.attach(ac3, on: db).wait()
        try em.$activities.attach(ac2, on: db).wait()
        try em4.$activities.attach(ac3, on: db).wait()
        try em4.$activities.attach(ac2, on: db).wait()
        
        let ap = Appointment()
        ap.details = "Részletek"
        ap.startsAt = Date()
        ap.endsAt = Date(timeIntervalSinceNow: 7200)
        ap.isPrivate = false
        ap.place = "1117 Budapest, Béke út 24."
        ap.price = 6000
        ap.isOnline = false
        ap.$client.id = cl.id!
        ap.$activity.id = ac3.id!
        ap.$employee.id = em.id!
        ap.$organization.id = o.id!
        
        let ap2 = Appointment()
        ap2.details = "Részletek"
        ap2.startsAt = Date().modifyDateByDay(number: -2)
        ap2.endsAt = Date(timeIntervalSinceNow: 7200).modifyDateByDay(number: -2)
        ap2.isPrivate = false
        ap2.place = "1117 Budapest, Béke út 24."
        ap2.price = 6000
        ap2.isOnline = true
        ap2.$client.id = cl.id!
        ap2.$activity.id = ac2.id!
        ap2.$employee.id = em.id!
        ap2.$organization.id = o.id!
        
        let ap3 = Appointment()
        ap3.details = "Részletek"
        ap3.startsAt = Date().modifyDateByDay(number: -2)
        ap3.endsAt = Date(timeIntervalSinceNow: 7200).modifyDateByDay(number: -2)
        ap3.isPrivate = true
        ap3.$employee.id = em.id!
        ap3.$organization.id = o.id!
        
        let ap4 = Appointment()
        ap4.details = "Részletek"
        ap4.startsAt = Date().modifyDateByDay(number: -2)
        ap4.endsAt = Date(timeIntervalSinceNow: 7200).modifyDateByDay(number: -2)
        ap4.isPrivate = true
        ap4.$employee.id = em4.id!
        ap4.$organization.id = o.id!
        
        let ap5 = Appointment()
        ap5.details = "Részletek"
        ap5.startsAt = Date().modifyDateByDay(number: 2)
        ap5.endsAt = Date(timeIntervalSinceNow: 7200).modifyDateByDay(number: 2)
        ap5.isPrivate = false
        ap5.place = "1117 Budapest, Béke út 24."
        ap5.price = 6000
        ap5.isOnline = true
        ap5.$client.id = cl.id!
        ap5.$activity.id = ac2.id!
        ap5.$employee.id = em.id!
        ap5.$organization.id = o.id!
        
        try ap.create(on: db).wait()
        try ap2.create(on: db).wait()
        try ap3.create(on: db).wait()
        try ap4.create(on: db).wait()
        try ap5.create(on: db).wait()
        
        let aps = [ap, ap2, ap5]
        try aps.forEach { appointment in
            let eConTok = try JitsiJWTToken(employee: em, appointment: appointment)
            let eCon = try JitsiConsultation(
                appointment: appointment,
                subject: .employee,
                signedToken: try app.jwt.signers.sign(eConTok))
            
            let cConTok = try JitsiJWTToken(client: cl, appointment: appointment)
            let cCon = try JitsiConsultation(
                appointment: appointment,
                subject: .client,
                signedToken: try app.jwt.signers.sign(cConTok))
            
            try eCon.create(on: db).wait()
            try cCon.create(on: db).wait()
        }
    }
    
    static func getApplication() throws -> Application {
        let a = Application(.testing)
        try TestConfiguration.configure(a)
        return a
    }
}
