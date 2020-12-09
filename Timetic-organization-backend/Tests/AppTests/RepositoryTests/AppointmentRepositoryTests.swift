@testable import App
import XCTVapor
import Foundation

final class AppointmentRepositoryTests: XCTestCase {
    let email = "simonadél@gmail.com"
    
    func testCreateAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let clients = try ClientRepository.getClients(db: app.db).wait()
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let chosenEmployee = try CommonEmployee(model: employees.first!)
        let chosenActivity = chosenEmployee.activities.first!
        let chosenClient = try CommonClient(model: clients.first!)
        let chosenPlace = organization.addresses.first!
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()
        
        let appointment = CommonAppointment(_id: nil,
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
        
        let createdAppointment = try AppointmentRepository.createOrModifyAppointment(appointment, db: app.db).wait()
        XCTAssertNotNil(createdAppointment.id)
    }
    
    func testCreateOnlineAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let clients = try ClientRepository.getClients(db: app.db).wait()
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let chosenEmployee = try CommonEmployee(model: employees.first!)
        let chosenActivity = chosenEmployee.activities.first!
        let chosenClient = try CommonClient(model: clients.first!)
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()
        
        let appointment = CommonAppointment(_id: nil,
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
        
        let createdAppointment = try AppointmentRepository.createOrModifyAppointment(appointment, db: app.db).wait()
        XCTAssertNotNil(createdAppointment.id)
        XCTAssertEqual(createdAppointment.place, "Online")
    }
    
    func testCreateAppointmentWithUnassignedActivity() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let activities = try ActivityRepository.getActivities(db: app.db).wait()
        let clients = try ClientRepository.getClients(db: app.db).wait()
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let employee = employees.first!
        let chosenEmployee = try CommonEmployee(model: employee)
        let unassignedActivities = activities.filter { activity in
            !activity.employees.contains(where: { assignedEmployee in
                assignedEmployee.id! == employee.id!
            })
        }
        let chosenActivity = try CommonActivity(model: unassignedActivities.first!)
        let chosenClient = try CommonClient(model: clients.first!)
        let chosenPlace = organization.addresses.first!
        let startTime = Date().modifyDateByDay(number: 4).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 4).milliseconds()
        
        let appointment = CommonAppointment(_id: nil,
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
        
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointment(appointment, db: app.db).wait())
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointmentForEmployee(appointment, employee: employee, db:  app.db).wait())
    }
    
    func testCreateAppointmentWithPastTime() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let organization = try OrganizationRepository.getOrganization(db: app.db).wait()
        let clients = try ClientRepository.getClients(db: app.db).wait()
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let employee = employees.first!
        let chosenEmployee = try CommonEmployee(model: employee)
        let chosenActivity = chosenEmployee.activities.first!
        let chosenClient = try CommonClient(model: clients.first!)
        let chosenPlace = organization.addresses.first!
        let startTime = Date().modifyDateByDay(number: -1).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: -1).milliseconds()
        
        let appointment = CommonAppointment(_id: nil,
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
        
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointment(appointment, db: app.db).wait())
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointmentForEmployee(appointment, employee: employee, db:  app.db).wait())
    }
    
    func testModifyAppointmentWithPastTime() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let employee = employees.first!
        let startTime = Date().modifyDateByDay(number: -1)
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: -1)
        
        let appointments = try AppointmentRepository.getAppointmentsForAdmin(db: app.db).wait()
        let appointment = appointments.first!
        appointment.startsAt = startTime
        appointment.endsAt = endTime
        
        let appointmentToSave = try CommonAppointment(model: appointment)
        
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointment(appointmentToSave, db: app.db).wait())
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointmentForEmployee(appointmentToSave, employee: employee, db:  app.db).wait())
    }
    
    func testCreatePrivateAppointment() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let employee = employees.first!
        let chosenEmployee = try CommonEmployee(model: employee)
        let startTime = Date().modifyDateByDay(number: 1).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 1).milliseconds()
        
        let appointment = CommonAppointment(_id: nil,
                                            isPrivate: true,
                                            startTime: startTime,
                                            endTime: endTime,
                                            employee: chosenEmployee,
                                            client: nil,
                                            activity: nil,
                                            place: nil,
                                            price: nil,
                                            online: false,
                                            note: "Note")
                
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointment(appointment, db: app.db).wait())
        XCTAssertNoThrow(try AppointmentRepository.createOrModifyAppointmentForEmployee(appointment, employee: employee, db:  app.db).wait())
    }
    
    func testCreateNonPrivateAppointmentWithMissingParameters() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let employees = try EmployeeRepository.getEmployees(roles: [.general], db: app.db).wait()
        let employee = employees.first!
        let chosenEmployee = try CommonEmployee(model: employee)
        let startTime = Date().modifyDateByDay(number: 1).milliseconds()
        let endTime = Date(timeIntervalSinceNow: 3600).modifyDateByDay(number: 1).milliseconds()
        
        let appointment = CommonAppointment(_id: nil,
                                            isPrivate: false,
                                            startTime: startTime,
                                            endTime: endTime,
                                            employee: chosenEmployee,
                                            client: nil,
                                            activity: nil,
                                            place: nil,
                                            price: nil,
                                            online: false,
                                            note: "Note")
        
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointment(appointment, db: app.db).wait())
        XCTAssertThrowsError(try AppointmentRepository.createOrModifyAppointmentForEmployee(appointment, employee: employee, db:  app.db).wait())
    }
}
