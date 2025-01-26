import Foundation
import Combine
import CoreLocation

class TripViewModel: ObservableObject {
    
    @Published var trips: [Trip] = []
//    @Published var trips: [Trip] = [Trip(id: UUID(), current: 69, target: 70), Trip(id: UUID(), current: 342, target: 563)]
    
    private let locationManager: LocationManager
    private let tripStore: TripManager
    private var cancellables: [AnyCancellable] = []
    
    init(locationManager: LocationManager = LocationManagerImpl.default, tripStore: TripManager = TripManagerImpl.default) {
        self.locationManager = locationManager
        self.tripStore = tripStore
        
        let trips = tripStore.getTrips()
        if trips.isEmpty {
            do {
                try tripStore.createTrip(target: nil)
            } catch {
                print(error)
            }
        }
        
        subscribeToLocationUpdates()
    }
    
    private func subscribeToLocationUpdates() {
        locationManager.location
            .scan((previous: Optional<CLLocation>.none, value: Optional<CLLocation>.none)) { previous, new in
                (previous: previous.value, value: new)
            }
            .compactMap { locations in
                guard let previous = locations.previous, let current = locations.value else { return nil }
                return current.distance(from: previous)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                default:
                    return
                }
            }, receiveValue: { value in
                self.distanceUpdated(distance: value)
            })
            .store(in: &cancellables)
    }
    
    private func distanceUpdated(distance: Double) {
        do {
            try tripStore.updateTrips(distance: distance)
        } catch {
            print(error)
        }
        trips = tripStore.getTrips()
    }
}
