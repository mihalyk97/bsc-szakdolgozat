import Foundation
import Vapor

//https://github.com/vapor/vapor/issues/2298

extension EventLoopFuture {
    public func throwingFlatMap<NewValue>(_ transform: @escaping (Value) throws -> EventLoopFuture<NewValue>) -> EventLoopFuture<NewValue> {
        flatMap { value in
            do {
                return try transform(value)
            } catch {
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }
}
