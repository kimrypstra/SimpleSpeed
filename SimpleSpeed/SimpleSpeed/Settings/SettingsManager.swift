import Combine
import Foundation

protocol SettingsManager {
    static var availableSettings: [BooleanSetting] { get }
    var settingsChanged: PassthroughSubject<[BooleanSetting], Never> { get }
    
    func loadBooleanSettings() -> [BooleanSetting]
    func setSetting(setting: BooleanSetting)
}

class SettingsManagerImpl: SettingsManager {
    
    static let `default` = SettingsManagerImpl()
    static let availableSettings: [BooleanSetting] = [
        .showUnits,
        .showTrips
    ]
    
    // The set of settings that was last saved
    let settingsChanged: PassthroughSubject<[BooleanSetting], Never> = .init()
    
    private let userDefaults = UserDefaults.standard
    
    func loadBooleanSettings() -> [BooleanSetting] {
        return Self.availableSettings.compactMap {
            $0.copy(newValue: userDefaults.bool(forKey: $0.key))
        }
    }
    
    func setSetting(setting: BooleanSetting) {
        userDefaults.setValue(setting.value, forKey: setting.key)
        settingsChanged.send(loadBooleanSettings())
    }
}
