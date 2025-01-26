import Foundation

struct BooleanSetting: Codable {
    let title: String
    let description: String?
    let key: String
    let value: Bool? // Currently only support boolean settings
    
    static let showUnits = BooleanSetting(title: "Show units", description: "Show units under the speed", key: "unitsEnabled", value: nil)
    static let showTrips = BooleanSetting(title: "Show trips", description: "Show trip meters on the main display", key: "tripEnabled", value: nil)
    
    func copy(newValue: Bool) -> BooleanSetting {
        BooleanSetting(title: title, description: description, key: key, value: newValue)
    }
}
