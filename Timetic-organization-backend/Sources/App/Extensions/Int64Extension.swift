import Foundation

extension Int64 {
    func millisecondsToDate() -> Date{
        let doubleValue: Double = (Double(self) / 1000.0)
        return Date(timeIntervalSince1970: doubleValue)
    }
}
