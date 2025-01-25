import Combine
import Foundation

protocol SettingsManager {
    static var availableSettings: [Setting] { get }
    var settingsChanged: PassthroughSubject<[Setting], Never> { get }
    
    func loadSettings() -> [Setting]
    func setSetting(setting: Setting)
}

class SettingsManagerImpl: SettingsManager {
    
    static let `default` = SettingsManagerImpl()
    static let availableSettings: [Setting] = [
        .showUnits,
        .other
    ]
    
    // The set of settings that was last saved
    let settingsChanged: PassthroughSubject<[Setting], Never> = .init()
    
    
    private let userDefaults = UserDefaults.standard
    
    func loadSettings() -> [Setting] {
        return Self.availableSettings.compactMap {
            $0.copy(newValue: userDefaults.bool(forKey: $0.key))
        }
    }
    
    func setSetting(setting: Setting) {
        userDefaults.setValue(setting.value, forKey: setting.key)
        settingsChanged.send(loadSettings())
    }
}
