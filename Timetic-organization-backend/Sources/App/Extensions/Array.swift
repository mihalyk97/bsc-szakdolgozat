import Foundation

//https://stackoverflow.com/questions/39791084/swift-3-array-to-dictionary
extension Array where Element : PersonalInfo {
    func toDictionary() -> [String:String] {
        var dict = [String:String]()
        for personalInfo in self {
            dict[personalInfo.key] = personalInfo.value
        }
        return dict
    }
}
