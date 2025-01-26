import Foundation

class UserDefaultsService: IOService {
    
    static let shared = UserDefaultsService()
    
    private let tripPrefix = "trip/"
    private let userDefaults = UserDefaults.standard
    
    func write(_ trip: Trip) throws {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(trip)
        userDefaults.set(encodedData, forKey: "\(tripPrefix)\(trip.id)")
    }
    
    func readTrip(id: UUID) throws -> Trip {
        let decoder = JSONDecoder()
        guard let data = userDefaults.data(forKey: "\(tripPrefix)\(id.uuidString)") else { throw IOError.keyNotFound }
        let trip = try decoder.decode(Trip.self, from: data)
        return trip
    }
    
    func readAllTrips() -> [Trip] {
        let ids = userDefaults.dictionaryRepresentation().keys.filter { $0.contains("trip/") }
        return ids.compactMap {
            // Seems dumb, removing the prefix just to add it again inside readTrip.
            // Revisit this later!
            let id = $0.replacing(tripPrefix, with: "")
            return try? readTrip(id: UUID(uuidString: id)!)
        }
    }
}

enum IOError: Error {
    case keyNotFound
}
