import Foundation
import Vapor

public struct ForEmployeeActivityForReport: Content {
    public var name: String
    public var sumHours: Double
    public var sumIncome: Double

    public init(name: String, sumHours: Double, sumIncome: Double) {
        self.name = name
        self.sumHours = sumHours
        self.sumIncome = sumIncome
    }


}

