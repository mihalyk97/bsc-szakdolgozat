import Foundation
import Vapor

public final class CommonClient: Content {
    public var _id: String?
    public var name: String
    public var phone: String
    public var email: String
    public var personalInfos: [String:String] = [:]

    public init(_id: String?, name: String, phone: String, email: String, personalInfos: [String:String]) {
        self._id = _id
        self.name = name
        self.phone = phone
        self.email = email
        self.personalInfos = personalInfos
    }
    
    init(model: Client) throws {
        self._id = try model.requireID().uuidString
        self.name = model.name
        self.phone = model.phone
        self.email = model.email
        self.personalInfos = model.personalInfos.toDictionary()
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
        case phone
        case email
        case personalInfos
    }
    
    func toModel(from client: Client? = nil) -> Client {
        let client = client ?? Client()
        client.name = self.name
        client.phone = self.phone
        client.email = self.email
        return client
    }
}

extension CommonClient: NilValidatable { }
