import Foundation

protocol TripManager {
    func getTrip(id: UUID) throws -> Trip
    func getTrips() -> [Trip]
    func updateTrips(distance: Double) throws
    func createTrip(target: Double?) throws -> Trip
}

class TripManagerImpl: TripManager {
    
    static let `default` = TripManagerImpl()
    private let userDefaults = UserDefaults.standard
    
    func createTrip(target: Double? = nil) throws -> Trip {
        let trip = Trip(id: UUID(), current: 0.0, target: target)
        try writeData(trip)
        return trip
    }
    
    // This might not be required
    func getTrip(id: UUID) throws -> Trip {
        guard let value = userDefaults.object(forKey: "trip/\(id)") else {
            throw TripError.unknownTrip
        }
        
        guard let trip = value as? Trip else {
            throw TripError.invalidTrip
        }
        
        return trip
    }
    
    func getTrips() -> [Trip] {
        let ids = userDefaults.dictionaryRepresentation().keys.filter { $0.contains("trip/") }
        
        return ids.compactMap {
            readData(key: $0)
        }
    }
    
    func updateTrips(distance: Double) throws {
        // update active trips
        // at the moment they're all active
        
        try getTrips().map { trip in
            trip.adding(distance: distance)
        }
        .forEach { trip in
            try writeData(trip)
        }
    }
    
    private func writeData(_ trip: Trip) throws {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(trip)
        userDefaults.set(encodedData, forKey: "trip/\(trip.id)")
    }
    
    private func readData(key: String) -> Trip? {
        let decoder = JSONDecoder()
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? decoder.decode(Trip.self, from: data)
    }
}

enum TripError: Error {
    case unknownTrip
    case invalidTrip
}
