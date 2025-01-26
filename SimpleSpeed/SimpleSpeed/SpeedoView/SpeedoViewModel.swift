import Combine
import Foundation

class SpeedoViewModel: ObservableObject {
    
    @Published var speed = "--"
    @Published var units: String? = nil
    @Published var showTrip = true
    
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
        locationManager.speedUpdated
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
        handleSettings(settings: settingsManager.loadBooleanSettings())
    }
    
    /// Sets flags based on the provided settings
    private func handleSettings(settings: [BooleanSetting]) {
        if settings[BooleanSetting.showUnits]?.value == true {
            units = Locale.autoupdatingCurrent.measurementSystem == .metric ? "km/h" : "mph"
        } else {
            units = nil 
        }
        
        showTrip = settings[BooleanSetting.showTrips]?.value ?? false
    }
}
