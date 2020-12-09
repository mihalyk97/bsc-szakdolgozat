import Foundation

struct AppointmentEmail: Codable {
    let cause: AppointmentEmailCause
    let clientName: String
    let startTime: String
    let endTime: String
    let activityName: String
    let employeeName: String
    let employeePhone: String
    let employeeEmail: String
    let price: Int
    let place: String
    let isOnline: Bool
    var consultationUrl: String
    let organizationName: String
    static let templateName = "AppointmentEmail"
    
    init(appointment: Appointment, cause: AppointmentEmailCause, organizationName: String, consultationUrl: String = "") {
        self.cause = cause
        self.clientName = appointment.client!.name
        self.startTime = appointment.startsAt.rfc1123
        self.endTime = appointment.endsAt.rfc1123
        self.activityName = appointment.activity!.title
        self.employeeName = appointment.employee.name
        self.employeePhone = appointment.employee.phone
        self.employeeEmail = appointment.employee.email
        self.price = Int(appointment.price!)
        self.place = appointment.place!
        self.isOnline = (cause == .cancelled) ? false : appointment.isOnline!
        self.consultationUrl = consultationUrl
        self.organizationName = organizationName
    }
}
