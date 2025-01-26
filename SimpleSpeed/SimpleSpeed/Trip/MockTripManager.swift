import Combine
import Foundation

class MockTripManager: TripManager {
    
    private let mockTrip = Trip(id: UUID(), current: 123, target: 124, targetType: .countUp, showTarget: true)
    
    var trips: PassthroughSubject<[Trip], Never> = .init()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.trips.send([self.mockTrip])
        }
    }
    
    func createTrip(target: Double?, targetType: Trip.TripTargetType, showTarget: Bool) throws -> Trip {
        return mockTrip
    }
    func getTrip(id: UUID) throws -> Trip {
        return mockTrip
    }
    func getTrips() -> [Trip] {
        return [mockTrip]
    }
    func updateTrip(_ trip: Trip) {}
    func resetTrip() {}
    func deleteTrip() {}
}
