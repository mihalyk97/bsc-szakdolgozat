import Foundation
import Vapor
import Fluent

struct CreateTestData: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
       self.addNewData(db: database)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.makeSucceededFuture(())
    }
    
    private func addNewData(db: Database) -> EventLoopFuture<Void>{
        let o = Organization()
        o.name = "Kozmetika"
        o.addresses=["1117 Budapest, Béke út 24.", "Ügyfélnél"]
        o.details = "Részletek a cégről"
        o.canClientContactEmployees = true
        o.clientPersonalInfoFields = ["Taj szám", "Gyógyszerallergia"]
        o.jitsiUrl = "https://optipus.ddns.net:8071"
        
        let ac = Activity()
        ac.title = "Arckezelés"
        
        let ac2 = Activity()
        ac2.title = "Gyantázás"
        
        let ac3 = Activity()
        ac3.title = "Sminkelés"
        
        let cl = Client()
        cl.name="Simon Adél"
        cl.phone = "+36701212345"
        cl.email = "simonadél@gmail.com"
        
        let pi = PersonalInfo()
        pi.key = "Taj szám"
        pi.value = "123456789"
        
        let pi2 = PersonalInfo()
        pi2.key = "Gyógyszerallergia"
        pi2.value = "Nincs"
        
        let ap = Appointment()
        ap.details = "Részletek"
        ap.startsAt = Date()
        ap.endsAt = Date(timeIntervalSinceNow: 7200)
        ap.isPrivate = false
        ap.place = "1117 Budapest, Béke út 24."
        ap.price = 6000
        ap.isOnline = false
        
        let ap2 = Appointment()
        ap2.details = "Részletek"
        ap2.startsAt = Date().modifyDateByDay(number: -2)
        ap2.endsAt = Date(timeIntervalSinceNow: 7200).modifyDateByDay(number: -2)
        ap2.isPrivate = false
        ap2.place = "1117 Budapest, Béke út 24."
        ap2.price = 6000
        ap2.isOnline = true
        
        return o.create(on: db).flatMap {
            ac.$organization.id = o.id!
            ac2.$organization.id = o.id!
            ac3.$organization.id = o.id!
            cl.$organization.id = o.id!
            let em = try! Employee(name: "Bajmóczy Eszter", canAddClient: true, role: .general, email: "eszty.bajmoczy@gmail.com", phone: "+36209876543", password: "Ab123456")
            em.$organization.id = o.id!
            let em2 = try! Employee(name: "Mihály Kristóf", canAddClient: true, role: .admin, email: "mihaly.kristof97@gmail.com", phone: "+36309876543", password: "Ab123456")
            em2.$organization.id = o.id!
            let em3 = try! Employee(name: "Simon Anna", canAddClient: false, role: .defaultContact, email: "hiuebibdububd@adfd.sdsf", phone: "+36709876543", password: "")
            em3.$organization.id = o.id!

            return (ac.create(on: db)
                        .and(ac2.create(on: db)
                                .and(ac3.create(on: db))
                                .and(cl.create(on: db)
                                        .map {
                return cl.$personalInfos.create([pi, pi2], on: db)
            }))).flatMap { _ in
                return em.create(on: db).flatMap {
                    ap.$client.id = cl.id!
                    ap.$activity.id = ac3.id!
                    ap.$employee.id = em.id!
                    ap.$organization.id = o.id!
                    ap2.$client.id = cl.id!
                    ap2.$activity.id = ac2.id!
                    ap2.$employee.id = em.id!
                    ap2.$organization.id = o.id!
                    return em2.create(on: db).and(em3.create(on: db)).flatMap { _ in
                        return em.$activities.attach(ac3, on: db).and(em.$activities.attach(ac2, on: db)).flatMap { _ in
                            return ap.create(on: db).and(ap2.create(on: db)).map { _ in }
                        }
                    }
                }
            }
        }

    }

}
