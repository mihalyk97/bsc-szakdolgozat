@testable import App
import XCTVapor
import Foundation

final class EmployeeControllerTests: XCTestCase {
    let email = "eszty.bajmoczy@gmail.com"
    var accessToken = ""
    private func doLogin(app: Application) throws {
        let password = "Ab123456"
        
        var refreshToken = ""
        try app.test(.GET, "employee/login", beforeRequest: { req in
            req.headers.basicAuthorization = .init(username: email, password: password)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let token = try res.content.decode(ForEmployeeLoginData.self)
            refreshToken = token.refreshToken.token
        })
        
        try app.test(.GET, "employee/refresh", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: refreshToken)
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
        
        try app.test(.GET, "employee/organization",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/report",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/clients",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.POST, "employee/clients",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/appointments",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.POST, "employee/appointments",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.PUT, "employee/appointments",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/appointments/id",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.DELETE, "employee/appointments/id",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/appointmentCreationData",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/consultation",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/login",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/logout",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        try app.test(.GET, "employee/refresh",afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
        
        try app.test(.GET, "employee/forgottenPassword",afterResponse: { res in
            XCTAssertNotEqual(res.status, .unauthorized)
        })
        try app.test(.POST, "employee/forgottenPassword",afterResponse: { res in
            XCTAssertNotEqual(res.status, .unauthorized)
        })

    }

    func testCreateNonPrivateAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let chosenClient = try CommonClient(model: organization.clients.first!)
        let chosenPlace = organization.addresses.first!
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()
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
        
        try app.test(.POST, "employee/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(appointmentToCreate)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let appointment = try res.content.decode(CommonAppointment.self)
            XCTAssertNotNil(appointment._id)
        })
    }
    
    func testCreateNonPrivateOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let chosenClient = try CommonClient(model: organization.clients.first!)
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()
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
        
        try app.test(.POST, "employee/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(appointmentToCreate)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let appointment = try res.content.decode(CommonAppointment.self)
            XCTAssertNotNil(appointment._id)
            XCTAssertEqual(appointment.place, "Online")
        })
    }
    
    func testCreateExistingOwnAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let appointments = try AppointmentRepository.getAppointmentsForEmployee(employee, db: app.db).wait()
        let nonPrivateAppointments = appointments.filter { appointment in
            !appointment.isPrivate
        }
        let exsistingAppointment = try CommonAppointment(model: nonPrivateAppointments.first!)
        
        try app.test(.POST, "employee/appointments", beforeRequest: { req in
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
        
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let chosenEmployee = try CommonEmployee(model: employee)
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
        
        try app.test(.POST, "employee/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(privateAppointmentToCreate)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let appointment = try res.content.decode(CommonAppointment.self)
            XCTAssertNotNil(appointment._id)
        })
    }
    
    func testModifyExistingNonPrivateAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let appointments = try AppointmentRepository.getAppointmentsForEmployee(employee, db: app.db).wait()
        let nonPrivateAppointments = appointments.filter { appointment in
            !appointment.isPrivate && appointment.startsAt > Date()
        }
        let exsistingAppointment = try CommonAppointment(model: nonPrivateAppointments.first!)
        exsistingAppointment.price = exsistingAppointment.price! * 10
        
        try app.test(.PUT, "employee/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(exsistingAppointment)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let appointment = try res.content.decode(CommonAppointment.self)
            XCTAssertEqual(exsistingAppointment.price!, appointment.price!)
        })
    }
    
    func testModifyExistingAppointmentWithUnassociatedActivity() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let activities = try ActivityRepository.getActivities(db: app.db).wait()
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let appointments = try AppointmentRepository.getAppointmentsForEmployee(employee, db: app.db).wait()
        let nonPrivateAppointments = appointments.filter { appointment in
            !appointment.isPrivate && appointment.startsAt > Date()
        }
        let unassociatedActivities = activities.filter { activity in
            !employee.activities.contains(where: { associatedActivity in
                associatedActivity.id! == activity.id!
            })
        }
        let unassociatedActivity = try CommonActivity(model: unassociatedActivities.first!)
        let exsistingAppointment = try CommonAppointment(model: nonPrivateAppointments.first!)
        exsistingAppointment.activity = unassociatedActivity
        
        try app.test(.PUT, "employee/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(exsistingAppointment)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    func testModifyExistingAppointmentWithOtherEmployee() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
       
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let filteredEmployees = employees.filter { employee in
            employee.email != email
        }
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let appointments = try AppointmentRepository.getAppointmentsForEmployee(employee, db: app.db).wait()
        let nonPrivateAppointments = appointments.filter { appointment in
            !appointment.isPrivate && appointment.startsAt > Date()
        }
        let otherEmployee = try CommonEmployee(model: filteredEmployees.first!)
        let exsistingAppointment = try CommonAppointment(model: nonPrivateAppointments.first!)
        exsistingAppointment.employee = otherEmployee
        
        try app.test(.PUT, "employee/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(exsistingAppointment)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    func testModifyOtherEmployeesExistingAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let filteredEmployees = employees.filter { employee in
            employee.email != email
        }
        let otherEmployee = filteredEmployees.first!
        let otherEmployeesAppointments = try AppointmentRepository.getAppointmentsForEmployee(otherEmployee, db: app.db).wait()
        let otherEmployeesAppointment = try CommonAppointment(model: otherEmployeesAppointments.first!)
        otherEmployeesAppointment.note = "Something new"
        
        try app.test(.PUT, "employee/appointments", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
            try req.content.encode(otherEmployeesAppointment)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    func testGetConstultatuionUrlForOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let appointments = try AppointmentRepository.getAppointmentsForEmployee(employee, db: app.db).wait()
        let nonPrivateOnlineAppointments = appointments.filter { appointment in
            !appointment.isPrivate && appointment.isOnline!
        }
        let nonPrivateOnlineAppointment = nonPrivateOnlineAppointments.first!
        let appointmentId = nonPrivateOnlineAppointment.id!
        let appointmentIdString = appointmentId.uuidString
        
        let consultation = try JitsiRepository.getConsultationByAppointmentId(appointmentId, subject: .employee, db: app.db).wait()
        
        try app.test(.GET, "employee/consultation?appointmentId=\(appointmentIdString)", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let requestedConsultation = try res.content.decode(CommonConsultation.self)
            XCTAssertEqual(requestedConsultation.url, try consultation.getTokenizedUrl(jitsiServerUrl: organization.jitsiUrl))
        })
    }
    
    func testGetConstultatuionUrlForNonOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        try doLogin(app: app)
        
        let employee = try EmployeeRepository.getEmployeeByEmail(email, db: app.db).wait()
        let appointments = try AppointmentRepository.getAppointmentsForEmployee(employee, db: app.db).wait()
        let nonPrivateNonOnlineAppointments = appointments.filter { appointment in
            !appointment.isPrivate && !appointment.isOnline!
        }
        let nonPrivateNonOnlineAppointment = nonPrivateNonOnlineAppointments.first!
        let appointmentId = nonPrivateNonOnlineAppointment.id!
        let appointmentIdString = appointmentId.uuidString

        try app.test(.GET, "employee/consultation?appointmentId=\(appointmentIdString)", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: accessToken)
        } ,afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
}
