import Combine
import Foundation

protocol TripManager {
    // Create
    func createTrip(target: Double?, targetType: Trip.TripTargetType, showTarget: Bool) throws -> Trip
    // Read
    func getTrip(id: UUID) throws -> Trip
    func getTrips() -> [Trip]
    // Update
    func updateTrip(_ trip: Trip)
    /// Sets the trip's ``current`` property to 0 but retains all other settings
    func resetTrip()
    // Delete
    func deleteTrip()
    
    var trips: PassthroughSubject<[Trip], Never> { get }
}

/// Responsible for creating, updating, and holding ``Trip`` instances in memory.
/// See ``IOService`` for actual reads/writes
class TripManagerImpl: TripManager {
    
    static let `default` = TripManagerImpl()
    
    private let ioService: IOService
    private let locationManager: LocationManager = LocationManagerImpl.default
    private var cancellables: [AnyCancellable] = []
    
    let trips: PassthroughSubject<[Trip], Never> = .init()
    let _trips: CurrentValueSubject<[Trip], Never> = .init([])
    
    init(ioService: IOService = UserDefaultsService.shared) {
        self.ioService = ioService
        
        configureSubscriptions()
        configureTrips()
    }
    
    private func configureSubscriptions() {
        _trips
            .sink(receiveValue: trips.send)
            .store(in: &cancellables)
        
        locationManager.distanceUpdated
            .sink(receiveValue: updateTrips)
            .store(in: &cancellables)
    }
    
    private func configureTrips() {
        _trips.send(getTrips())
        if _trips.value.isEmpty {
            createInitialTrip()
        }
    }
    
    /// For simplicity, we always want there to be an initial trip.
    private func createInitialTrip() {
        do {
            let initialTrip = try createTrip()
            _trips.send([initialTrip])
        } catch {
            print(error)
        }
    }
    
    func createTrip(target: Double? = nil, targetType: Trip.TripTargetType = .none, showTarget: Bool = false) throws -> Trip {
        let trip = Trip(id: UUID(), current: 0.0, target: target, targetType: targetType, showTarget: showTarget)
        try ioService.write(trip)
        return trip
    }
    
    // This might not be required
    func getTrip(id: UUID) throws -> Trip {
        return try ioService.readTrip(id: id)
    }
    
    func getTrips() -> [Trip] {
        return ioService.readAllTrips()
    }
    
    func resetTrip() {
        
    }
    
    private func updateTrips(distance: Double) {
        let newTrips = _trips.value.map { trip in
            trip.adding(distance: distance)
        }
        
        _trips.send(newTrips)
    }
    
    func updateTrip(_ trip: Trip) {
        do {
            try ioService.write(trip)
            let updatedInMemoryTrips = _trips.value.map { $0.id == trip.id ? trip : $0 }
            _trips.send(updatedInMemoryTrips)
        } catch {
            print(error)
        }
    }
    
    func deleteTrip() {}
}

enum TripError: Error {
    case unknownTrip
    case invalidTrip
}
