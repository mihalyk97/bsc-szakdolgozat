import Foundation
import Vapor

public final class CommonActivity: Content {
    public var _id: String?
    public var name: String

    public init(_id: String?, name: String) {
        self._id = _id
        self.name = name
    }
    
    init(model: Activity) throws {
        self._id = try model.requireID().uuidString
        self.name = model.title
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
    }
    
    func toModel(from activity: Activity? = nil) -> Activity {
        let activity = activity ?? Activity()
        activity.title = self.name
        return activity
    }
}

extension CommonActivity: NilValidatable { }

