import Foundation
import Vapor

public struct ForAdminOverview: Content {
    public var appointmentsToday: Int
    public var onlineAppointmentsToday: Int
    public var registeredUsers: Int
    public var activeEmployeesToday: Int

    public init(appointmentsToday: Int, onlineAppointmentsToday: Int, registeredUsers: Int, activeEmployeesToday: Int) {
        self.appointmentsToday = appointmentsToday
        self.onlineAppointmentsToday = onlineAppointmentsToday
        self.registeredUsers = registeredUsers
        self.activeEmployeesToday = activeEmployeesToday
    }
}

