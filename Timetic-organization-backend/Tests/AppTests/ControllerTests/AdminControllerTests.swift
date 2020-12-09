@testable import App
import XCTVapor
import Foundation

final class AdminControllerTests: XCTestCase {
    var accessToken = ""
    private func doLogin(app: Application) throws {
        let email = "mihaly.kristof97@gmail.com"
        let password = "Ab123456"
        
        //var refreshToken = ""
        try app.test(.POST, "admin/login", beforeRequest: { req in
            try req.content.encode(ForAdminLogin(email: email, password: password))
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let token = try res.content.decode(CommonToken.self)
            accessToken = token.token
        })
    }
    
    // At endpoints, where "id" is given in the path, it's not have to be a real id,
    // beacuse when this id is checked, the authorization will be checked before that.
    func testEndpointsAreProtected() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try app.test(.GET, "admin/overview",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/organization",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.PUT, "admin/organization",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/report",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/activities",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.POST, "admin/activities",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.DELETE, "admin/activities/id",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/clients",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.POST, "admin/clients",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.PUT, "admin/clients",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/appointments",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.POST, "admin/appointments",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.PUT, "admin/appointments",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.DELETE, "admin/appointments/id",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/employees",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.POST, "admin/employees",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.PUT, "admin/employees",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.DELETE, "admin/employees/id",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/appointmentCreationData",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        
        try app.test(.GET, "admin/forgottenPassword",afterResponse: { res in
            XCTAssertNotEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/newPassword",afterResponse: { res in
            XCTAssertNotEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "admin/login",afterResponse: { res in
            XCTAssertNotEqual(res.status, .unauthorized)
        })
    }
    
    func testOverview() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        try app.test(.GET, "admin/overview", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let overview = try res.content.decode(ForAdminOverview.self)
            XCTAssertEqual(overview.appointmentsToday, 1)
            XCTAssertEqual(overview.onlineAppointmentsToday, 0)
            XCTAssertEqual(overview.registeredUsers, 1)
            XCTAssertEqual(overview.activeEmployeesToday, 1)

        })
    }
    
    func testCreateNonPrivateAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let chosenClient = try CommonClient(model: organization.clients.first!)
        let chosenPlace = organization.addresses.first!
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()

        try employees.forEach { employee in
            let chosenEmployee = try CommonEmployee(model: employee)
            let chosenActivity = try CommonActivity(model: employee.activities.first!)
            
            let appointmentToCreate = CommonAppointment(_id: nil,
                                                        isPrivate: false,
                                                        startTime: startTime,
                                                        endTime: endTime,
                                                        employee: chosenEmployee,
                                                        client: chosenClient,
                                                        activity: chosenActivity,
                                                        place: chosenPlace,
                                                        price: 1000,
                                                        online: false,
                                                        note: "Note")
            
            try app.test(.POST, "admin/appointments", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: accessToken)
                try req.content.encode(appointmentToCreate)
            } ,afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                let appointment = try res.content.decode(CommonAppointment.self)
                XCTAssertNotNil(appointment._id)
            })
        }
    }
    
    func testCreateNonPrivateOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let chosenClient = try CommonClient(model: organization.clients.first!)
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()
        
        try employees.forEach { employee in
            let chosenEmployee = try CommonEmployee(model: employee)
            let chosenActivity = try CommonActivity(model: employee.activities.first!)
            
            let appointmentToCreate = CommonAppointment(_id: nil,
                                                        isPrivate: false,
                                                        startTime: startTime,
                                                        endTime: endTime,
                                                        employee: chosenEmployee,
                                                        client: chosenClient,
                                                        activity: chosenActivity,
                                                        place: nil,
                                                        price: 1000,
                                                        online: true,
                                                        note: "Note")
            
            try app.test(.POST, "admin/appointments", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: accessToken)
                try req.content.encode(appointmentToCreate)
            } ,afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                let appointment = try res.content.decode(CommonAppointment.self)
                XCTAssertNotNil(appointment._id)
                XCTAssertEqual(appointment.place, "Online")
            })
        }
    }
    
    func testCreateExsistingNonPrivateAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let appointments = try AppointmentRepository.getAppointmentsForAdmin(from: nil, to: nil, db: app.db).wait()
        let nonPrivateAppointments = appointments.filter { appointment in
            !appointment.isPrivate
        }
        let exsistingAppointment = try CommonAppointment(model: nonPrivateAppointments.first!)
        
        try app.test(.POST, "admin/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(exsistingAppointment)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    func testCreatePrivateAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let chosenEmployee = try CommonEmployee(model: organization.employees.first!)
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()
        
        let privateAppointmentToCreate = CommonAppointment(_id: nil,
                                                    isPrivate: true,
                                                    startTime: startTime,
                                                    endTime: endTime,
                                                    employee: chosenEmployee,
                                                    client: nil,
                                                    activity: nil,
                                                    place: nil,
                                                    price: nil,
                                                    online: nil,
                                                    note: "Note")
        
        try app.test(.POST, "admin/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(privateAppointmentToCreate)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    func testModifyExistingAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let appointments = try AppointmentRepository.getAppointmentsForAdmin(from: nil, to: nil, db: app.db).wait()
        let nonPrivateAppointments = appointments.filter { appointment in
            !appointment.isPrivate && appointment.startsAt > Date()
        }
        let exsistingAppointment = try CommonAppointment(model: nonPrivateAppointments.first!)
        exsistingAppointment.price = exsistingAppointment.price! * 10
        
        try app.test(.PUT, "admin/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(exsistingAppointment)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let appointment = try res.content.decode(CommonAppointment.self)
            XCTAssertEqual(exsistingAppointment.price!, appointment.price!)
        })
    }
}
