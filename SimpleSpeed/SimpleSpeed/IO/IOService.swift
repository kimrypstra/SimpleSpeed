import Foundation

protocol IOService {
    func write(_ trip: Trip) throws
    func readTrip(id: UUID) throws -> Trip
    func readAllTrips() -> [Trip]
}
