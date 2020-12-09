import Foundation
import Vapor

public struct ForClientAppointment: Content {
    public var _id: String?
    public var startTime: Int64
    public var endTime: Int64
    public var employee: CommonEmployee
    public var activity: CommonActivity
    public var place: String
    public var price: Double
    public var online: Bool
    public var note: String

    public init(_id: String?, startTime: Int64, endTime: Int64, employee: CommonEmployee, activity: CommonActivity, place: String, price: Double, online: Bool, note: String) {
        self._id = _id
        self.startTime = startTime
        self.endTime = endTime
        self.employee = employee
        self.activity = activity
        self.place = place
        self.price = price
        self.online = online
        self.note = note
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case startTime
        case endTime
        case employee
        case activity
        case place
        case price
        case online
        case note
    }
    // Force unwrap is ok, because private appointments won't be sent to clients.
    init(model: Appointment) throws {
        self._id = try model.requireID().uuidString
        self.startTime = model.startsAt.milliseconds()
        self.endTime = model.endsAt.milliseconds()
        self.employee = try CommonEmployee(model: model.employee)
        self.activity = try CommonActivity(model: model.activity!)
        self.place = model.place!
        self.price = model.price!
        self.online = model.isOnline!
        self.note = model.details
    }
}

