import Foundation

struct Trip: Codable {
    let id: UUID
    let current: Double
    let target: Double?
    
    func adding(distance: Double) -> Trip {
        Trip(id: id, current: current + distance, target: target)
    }
}
