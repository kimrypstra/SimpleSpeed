import Combine
import CoreLocation

protocol LocationManager: CLLocationManagerDelegate {
    var speed: PassthroughSubject<Double, LocationError> { get }
}

/// Just an async wrapper around CLLocationManager
class LocationManagerImpl: NSObject, LocationManager {
    
    static let `default` = LocationManagerImpl()
    
    private let locationManager = CLLocationManager()
    
    /// The device's speed in `m/s`
    let speed: PassthroughSubject<Double, LocationError> = .init()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        beginUpdates()
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
        guard let location = locations.last,
              location.speedAccuracy >= 0.0 else {
            speed.send(completion: .failure(LocationError.lowSpeedAccuracy))
            return
        }
        
        speed.send(location.speed)
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
