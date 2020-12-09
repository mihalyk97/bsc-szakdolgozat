import Foundation

//https://stackoverflow.com/questions/44687197/check-if-any-property-in-an-object-is-nil-swift-3

protocol NilValidatable: class {
    func isValid(canBeNil: [String]) -> Bool
}

extension NilValidatable {
    func isValid(canBeNil: [String] = []) -> Bool {
        return !Mirror(reflecting: self).children.contains(where: {
            if case Optional<Any>.some(_) = $0.value {
                return false
            } else if canBeNil.contains($0.label ?? "") {
                return false
            }
            else {
                return true
            }
        })
    }
}
