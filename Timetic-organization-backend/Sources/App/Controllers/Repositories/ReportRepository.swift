import Foundation
import Fluent
import Vapor

struct ReportRepository {
    static func createReportForEmployee(_ employee: Employee, from: Date, to: Date, db: Database) throws -> EventLoopFuture<ForEmployeeReport> {
        return try AppointmentRepository
            .getAppointmentsForEmployee(employee, from: from, to: to, db: db)
            .map { appointments in
                var activities: [String: (hours: Double, income: Double)] = [:]
                var sumOnlineHours = 0.0
                var sumOnlineIncome = 0.0
                var sumLocalHours = 0.0
                var sumLocalIncome = 0.0
                appointments.forEach { appointment in
                    // Only nonprivate appointments can be included in the report
                    // because only they have certainly all necessary fields:
                    // (isOnline, price, activity).
                    if !appointment.isPrivate {
                        let hours = appointment.startsAt.distanceInHours(to: appointment.endsAt)
                        if let isOnline = appointment.isOnline, isOnline {
                            sumOnlineHours += hours
                            sumOnlineIncome += appointment.price ?? 0
                        } else {
                            sumLocalHours += hours
                            sumLocalIncome += appointment.price ?? 0
                        }
                        if let activity = appointment.activity {
                            let timeDistanceInHours = appointment.startsAt.distanceInHours(to: appointment.endsAt)
                            if activities[activity.title] == nil {
                                activities[activity.title] = ( hours : 0.0, income : 0 )
                            }
                            if let activityDetails = activities[activity.title] {
                                let actualHours = activityDetails.hours
                                let actualIncome = activityDetails.income
                                activities[activity.title] = (hours: actualHours + timeDistanceInHours, income: actualIncome + (appointment.price ?? 0))
                            }
                            
                        }
                    }
                }
                
                let reportActivities = activities.map { activity in
                    ForEmployeeActivityForReport(
                        name: activity.key,
                        sumHours: activity.value.hours,
                        sumIncome: activity.value.income)
                }
                                
                return ForEmployeeReport(
                    sumOnlineHours: sumOnlineHours,
                    sumLocalHours: sumLocalHours,
                    sumOnlineIncome: sumOnlineIncome,
                    sumLocalIncome: sumLocalIncome,
                    activities: reportActivities)
            }
    }
    
    // Force unwrap for the fields of the appointment is safe beacuse of the private check
    static func createReportForAdmin(_ admin: Employee, from: Date, to: Date, db: Database) throws -> EventLoopFuture<ForAdminReport> {
                try AppointmentRepository
                    .getAppointmentsForAdmin(from: from, to: to, db: db)
                    .flatMap { appointments in
                        let appointmentsForReport: [ForAdminReportAppointment] = appointments.compactMap { appointment in
                            // Only nonprivate appointments can be included in the report
                            // because only they have certainly all necessary fields:
                            // (isOnline, price, activity).
                            if appointment.isValid(), !appointment.isPrivate {
                            return ForAdminReportAppointment(
                                employeeName: appointment.employee.name,
                                activityName: appointment.activity!.title,
                                appointmentDate: appointment.startsAt.milliseconds(),
                                isOnline: appointment.isOnline!,
                                duration: appointment.startsAt.distanceInHours(to: appointment.endsAt),
                                income: appointment.price!)
                            }
                            return nil
                        }
                        return admin.$organization.load(on: db).map {
                            ForAdminReport(
                                organizationName: admin.organization.name,
                                startDate: from.milliseconds(),
                                endDate: to.milliseconds(),
                                appointments: appointmentsForReport)
                        }
                       
                    }
    }
}
