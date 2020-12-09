import Foundation
import Vapor

public struct ForEmployeeReport: Content {

    public var sumOnlineHours: Double
    public var sumLocalHours: Double
    public var sumOnlineIncome: Double
    public var sumLocalIncome: Double
    public var activities: [ForEmployeeActivityForReport]

    public init(sumOnlineHours: Double, sumLocalHours: Double, sumOnlineIncome: Double, sumLocalIncome: Double, activities: [ForEmployeeActivityForReport]) {
        self.sumOnlineHours = sumOnlineHours
        self.sumLocalHours = sumLocalHours
        self.sumOnlineIncome = sumOnlineIncome
        self.sumLocalIncome = sumLocalIncome
        self.activities = activities
    }
}

