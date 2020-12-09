import Foundation
import Vapor

public struct ForAdminReport: Content {
    public var organizationName: String
    public var startDate: Int64
    public var endDate: Int64
    public var appointments: [ForAdminReportAppointment]

    public init(organizationName: String, startDate: Int64, endDate: Int64, appointments: [ForAdminReportAppointment]) {
        self.organizationName = organizationName
        self.startDate = startDate
        self.endDate = endDate
        self.appointments = appointments
    }
}

