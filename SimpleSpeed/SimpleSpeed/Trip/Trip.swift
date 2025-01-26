import Foundation

struct Trip: Codable, Hashable {
    let id: UUID
    let current: Double
    let target: Double?
    let targetType: TripTargetType
    let showTarget: Bool
    
    enum TripTargetType: Int, Codable, CaseIterable, Identifiable {
        var id: Int {
            self.rawValue
        }
        
        case countUp = 2
        case countDown = 1
        case none = 0
        
        var displayTitle: String {
            switch self {
            case .countDown: "Count down"
            case .countUp: "Count up"
            case .none: "None"
            }
        }
    }
    
    var formatted: String? {
        try? DistanceConverter.format(current)
    }
    
    // MARK: Mutators
    // I chose not to use mutating functions here because this way is a bit more obvious that we need to also write the change to disk
    
    func adding(distance: Double) -> Trip {
        Trip(id: id, current: current + distance, target: target, targetType: targetType, showTarget: showTarget)
    }
    
    func settingTarget(to newTarget: Double) -> Trip {
        Trip(id: id, current: current, target: newTarget, targetType: targetType, showTarget: showTarget)
    }
    
    func settingTargetType(to newTargetType: Trip.TripTargetType) -> Trip {
        Trip(id: id, current: current, target: target, targetType: newTargetType, showTarget: showTarget)
    }
    
    func settingShowTarget(to newShowTarget: Bool) -> Trip {
        Trip(id: id, current: current, target: target, targetType: targetType, showTarget: newShowTarget)
    }
}
