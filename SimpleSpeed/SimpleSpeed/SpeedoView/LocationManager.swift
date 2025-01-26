import Combine
import CoreLocation

protocol LocationManager: CLLocationManagerDelegate {
    var speedUpdated: PassthroughSubject<Double, Never> { get }
    var distanceUpdated: PassthroughSubject<Double, Never> { get }
}

/// Async wrapper around ``CLLocationManager``. Responsible for observing location updates and exposing data for the rest of the app to consume.
class LocationManagerImpl: NSObject, LocationManager {
    
    static let `default` = LocationManagerImpl()
    
    private let locationManager = CLLocationManager()
    private var cancellables: [AnyCancellable] = []
    private let location: CurrentValueSubject<CLLocation?, LocationError> = .init(nil)
    
    /// The speed the device attained during last location update
    var speedUpdated: PassthroughSubject<Double, Never> = .init()
    /// The distance travelled since the last location update
    var distanceUpdated: PassthroughSubject<Double, Never> = .init()
    
    override init() {
        super.init()
        
        configureSubscriptions()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        beginUpdates()
    }
    
    private func configureSubscriptions() {
        location
            .catch { _ in
                // At the moment just swallow errors
                Just(nil)
            }
            .compactMap { value in
                value?.speed
            }
            .sink(receiveValue: { [weak self] value in
                self?.speedUpdated.send(value)
            })
            .store(in: &cancellables)
        
        location
            .scan((previous: Optional<CLLocation>.none, value: Optional<CLLocation>.none)) { previous, new in
                (previous: previous.value, value: new)
            }
            .compactMap { locations in
                guard let previous = locations.previous, let current = locations.value else { return nil }
                return current.distance(from: previous)
            }
            .catch { _ in
                // At the moment just swallow errors
                Just(0.0)
            }
            .sink(receiveValue: { [weak self] value in
                self?.distanceUpdated.send(value)
            })
            .store(in: &cancellables)
    }
    
    private func beginUpdates() {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            checkAndRequestPermissions()
        }
    }
    
    private func checkAndRequestPermissions() {
        // This is concise but risks breaking if Apple changes the order of the enum
        if locationManager.authorizationStatus.rawValue < CLAuthorizationStatus.authorizedAlways.rawValue {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location.send(locations.last)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Might be better to first show an alert to remind the user that we actually need
        // access to their location in order to show their speed
        checkAndRequestPermissions()
    }
}

enum LocationError: Error {
    case noPermission
    case lowSpeedAccuracy
}
