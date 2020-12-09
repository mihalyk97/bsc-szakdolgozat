import Foundation
import Vapor

public final class CommonAppointment: Content {
    public var _id: String?
    public var isPrivate: Bool
    public var startTime: Int64
    public var endTime: Int64
    public var employee: CommonEmployee
    public var client: CommonClient?
    public var activity: CommonActivity?
    public var place: String?
    public var price: Double?
    public var online: Bool?
    public var note: String

    public init(_id: String?, isPrivate: Bool, startTime: Int64, endTime: Int64, employee: CommonEmployee, client: CommonClient?, activity: CommonActivity?, place: String?, price: Double?, online: Bool?, note: String) {
        self._id = _id
        self.isPrivate = isPrivate
        self.startTime = startTime
        self.endTime = endTime
        self.employee = employee
        self.client = client
        self.activity = activity
        self.place = place
        self.price = price
        self.online = online
        self.note = note
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case isPrivate
        case startTime
        case endTime
        case employee
        case client
        case activity
        case place
        case price
        case online
        case note
    }
    
    init(model: Appointment) throws {
        self._id = try model.requireID().uuidString
        self.isPrivate = model.isPrivate
        self.startTime = model.startsAt.milliseconds()
        self.endTime = model.endsAt.milliseconds()
        if let client = model.client {
            self.client = try CommonClient(model: client)
        }
        else {
            self.client = nil
        }
        if let activity = model.activity {
            self.activity = try CommonActivity(model: activity)
        }
        else {
            self.activity = nil
        }
        self.employee = try CommonEmployee(model: model.employee)
        self.place = model.place
        self.price = model.price
        self.online = model.isOnline
        self.note = model.details
    }
    
    func toModel(from appointment: Appointment? = nil) -> Appointment {
        let appointment = appointment ?? Appointment()
        appointment.details = self.note
        appointment.startsAt = self.startTime.millisecondsToDate()
        appointment.endsAt = self.endTime.millisecondsToDate()
        appointment.isPrivate = self.isPrivate
        appointment.place = self.place
        appointment.price = self.price
        appointment.isOnline = self.online
        return appointment
    }
}

extension CommonAppointment: NilValidatable { }
