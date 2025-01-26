import Combine

class SettingsViewModel: ObservableObject {

    /// Simple on/off settings
    @Published var booleanSettings: [BooleanSetting] = []
    
    private var cancellables: [AnyCancellable] = []
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager = SettingsManagerImpl.default) {
        self.settingsManager = settingsManager
        
        loadSettings()
    }
    
    private func loadSettings() {
        booleanSettings = settingsManager.loadBooleanSettings()
    }
    
    func settingChanged(setting: BooleanSetting) {
        settingsManager.setSetting(setting: setting)
        loadSettings()
    }
}
