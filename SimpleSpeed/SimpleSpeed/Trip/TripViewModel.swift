import Foundation
import Combine
import CoreLocation

class TripViewModel: ObservableObject {
    
    @Published var trips: [Trip] = []
    
    private let locationManager: LocationManager
    private let tripManager: TripManager
    private var cancellables: [AnyCancellable] = []
    
    init(locationManager: LocationManager = LocationManagerImpl.default, tripManager: TripManager = TripManagerImpl.default) {
        self.locationManager = locationManager
        self.tripManager = tripManager
        
        subscribeToTripUpdates()
    }
    
    private func subscribeToTripUpdates() {
        tripManager.trips
            .sink { trips in
                self.trips = trips
            }
            .store(in: &cancellables)
    }
}
