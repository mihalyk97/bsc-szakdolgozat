import Foundation
import Vapor

public struct ForAdminReportAppointment: Content {
    public var employeeName: String
    public var activityName: String
    public var appointmentDate: Int64
    public var isOnline: Bool
    public var duration: Double
    public var income: Double

    public init(employeeName: String,
                activityName: String,
                appointmentDate: Int64,
                isOnline: Bool,
                duration: Double,
                income: Double) {
        self.employeeName = employeeName
        self.activityName = activityName
        self.appointmentDate = appointmentDate
        self.isOnline = isOnline
        self.duration = duration
        self.income = income
    }
}

