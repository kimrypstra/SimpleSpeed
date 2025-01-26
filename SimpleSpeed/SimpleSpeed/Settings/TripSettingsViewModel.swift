import Combine
import SwiftUI

class TripSettingsViewModel: ObservableObject {
    
    @Published var trips: [Trip] = []
    private let tripManager: TripManager
    
    init(tripManager: TripManager = TripManagerImpl.default) {
        self.tripManager = tripManager
        subscribeToTripUpdates()
    }
    
    private func subscribeToTripUpdates() {
        tripManager.trips
            .removeDuplicates {
                $0.elementsEqual($1) {
                    // Drop elements where the only thing that has changed is the value of `current`
                    $0.current != $1.current
                    && $0.showTarget == $1.showTarget
                    && $0.target == $1.target
                    && $0.targetType == $1.targetType
                }
            }
            .assign(to: &$trips)
    }
    
    func setTarget(_ target: String, for trip: Trip) {
        if let double = Double(target) {
            let trip = trip.settingTarget(to: double)
            tripManager.updateTrip(trip)
        }
    }

    func setTargetType(_ targetType: Trip.TripTargetType, for trip: Trip) {
        let trip = trip.settingTargetType(to: targetType)
        tripManager.updateTrip(trip)
    }

    func setShowTarget(_ showTarget: Bool, for trip: Trip) {
        let trip = trip.settingShowTarget(to: showTarget)
        tripManager.updateTrip(trip)
    }
}
