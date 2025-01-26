import Foundation

struct Setting: Codable {
    let title: String
    let description: String?
    let key: String
    let value: Bool? // Currently only support boolean settings
    
    static let showUnits = Setting(title: "Show units", description: "Show units under the speed", key: "unitsEnabled", value: nil)
    static let showTrip = Setting(title: "Show trip", description: "Show a resettable trip meter", key: "tripEnabled", value: nil)
    
    func copy(newValue: Bool) -> Setting {
        Setting(title: title, description: description, key: key, value: newValue)
    }
}
