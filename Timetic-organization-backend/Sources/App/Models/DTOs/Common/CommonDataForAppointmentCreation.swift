import Foundation
import Vapor

public struct CommonDataForAppointmentCreation: Content {

    public var activities: [CommonActivity]
    public var clients: [CommonClient]
    public var employees: [CommonEmployee]
    public var places: [String]

    public init(activities: [CommonActivity], clients: [CommonClient], employees: [CommonEmployee], places: [String]) {
        self.activities = activities
        self.clients = clients
        self.employees = employees
        self.places = places
    }
}

