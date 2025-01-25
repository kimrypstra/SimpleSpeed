import Combine
import Foundation

class MainViewModel: ObservableObject {
    
    @Published var speed = "--"
    @Published var shouldDimControls = false
    @Published var shouldShowSettings = false
    
    private let locationManager: LocationManager
    private var cancellables: [AnyCancellable] = []
    
    init(locationManager: LocationManager = LocationManagerImpl.default) {
        self.locationManager = locationManager
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
    
    private func dimControls() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.shouldDimControls = true
        }
    }
    
    func viewAppeared() {
        dimControls()
    }
    
    func settingsTapped() {
        shouldDimControls = false
        shouldShowSettings = true
    }
    
    func closeSettingsTapped() {
        shouldShowSettings = false
    }
}
