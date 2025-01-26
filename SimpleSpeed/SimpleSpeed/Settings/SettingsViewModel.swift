import Combine

class SettingsViewModel: ObservableObject {

    @Published var settings: [Setting] = []
    
    private var cancellables: [AnyCancellable] = []
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager = SettingsManagerImpl.default) {
        self.settingsManager = settingsManager
        
        loadSettings()
    }
    
    private func loadSettings() {
        settings = settingsManager.loadSettings()
    }
    
    func settingChanged(setting: Setting) {
        settingsManager.setSetting(setting: setting)
        loadSettings()
    }
}
