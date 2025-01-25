import Foundation

struct Setting: Codable {
    let title: String
    let description: String?
    let key: String
    let value: Bool? // Currently only support boolean settings
    
    static let showUnits = Setting(title: "Show units", description: "Show units under the speed", key: "unitsEnabled", value: nil)
    static let other = Setting(title: "Another", description: nil, key: "another", value: nil)
    
    func copy(newValue: Bool) -> Setting {
        Setting(title: title, description: description, key: key, value: newValue)
    }
}
