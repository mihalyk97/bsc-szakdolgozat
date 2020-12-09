import Foundation

extension Date {
    //precision: 3
    func distanceInHours(to: Date) -> TimeInterval {
        let distance = to.timeIntervalSince1970 - self.timeIntervalSince1970
        return ((abs(distance) / 60 / 60) * 1000.0).rounded() / 1000
        
    }

    //https://stackoverflow.com/questions/40633139/swift-compare-date-by-days
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func distanceWithComponent(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distanceWithComponent(from: date, only: component) == 0
    }
    
    func setTimeToBeginningOfTheDay() -> Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func setTimeToEndOfTheDay() -> Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    func add24HoursToDate() -> Date {
        return self.addingTimeInterval(24*60*60)
    }
    
    func milliseconds() -> Int64 {
        return Int64(self.timeIntervalSince1970*1000.0)
    }
    
    //https://stackoverflow.com/questions/5067785/how-do-i-add-1-day-to-an-nsdate
    func modifyDateByDay(number: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = number
        let calendar = Calendar.current
        return calendar.date(byAdding: dateComponent, to: self)!
    }
}
