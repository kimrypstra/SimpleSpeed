import Combine
import Foundation

class SpeedoViewModel: ObservableObject {
    
    @Published var speed = "--"
    @Published var units: String? = nil
    
    private let locationManager: LocationManager
    private let settingsManager: SettingsManager
    private var cancellables: [AnyCancellable] = []
    
    init(locationManager: LocationManager = LocationManagerImpl.default, settingsManager: SettingsManager = SettingsManagerImpl.default) {
        self.settingsManager = settingsManager
        self.locationManager = locationManager
        
        loadInitialSettings()
        subscribeToObservables()
    }
    
    private func subscribeToObservables() {
        locationManager.speed
            .tryMap { value in
                try SpeedConverter.format(value)
            }
            .catch { error in
                // Catch here instead of inside sink to ensure the subscription lives on
                return Just("--")
            }
            .sink(receiveValue: { [weak self] speed in
                self?.speed = speed
            })
            .store(in: &cancellables)
        
        settingsManager.settingsChanged
            .sink(receiveValue: handleSettings)
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) {
        switch error {
        case ConversionError.conversionFailed:
            print("yikes")
        case LocationError.noPermission:
            print("No permission")
        default:
            // log it and
            return
        }
    }
    
    /// Requests current settings from ``SettingsManager``
    private func loadInitialSettings() {
        handleSettings(settings: settingsManager.loadSettings())
    }
    
    /// Sets flags based on the provided settings
    private func handleSettings(settings: [Setting]) {
        if settings[Setting.showUnits]?.value == true {
            units = Locale.autoupdatingCurrent.measurementSystem == .metric ? "km/h" : "mph"
        } else {
            units = nil 
        }
    }
}

extension Array where Element == Setting  {
    subscript (_ setting: Setting) -> Setting? {
        return first(where: { $0.key == setting.key })
    }
}
