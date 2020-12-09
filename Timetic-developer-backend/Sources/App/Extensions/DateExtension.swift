import Foundation

extension Date {
    
    func milliseconds() -> Int64 {
        return Int64(self.timeIntervalSince1970*1000.0)
    }
}
