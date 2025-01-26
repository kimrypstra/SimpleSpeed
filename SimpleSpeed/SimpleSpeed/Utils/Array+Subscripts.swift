import Foundation

extension Array where Element == BooleanSetting {
    subscript (_ setting: BooleanSetting) -> BooleanSetting? {
        return first(where: { $0.key == setting.key })
    }
}

extension Array where Element == Trip {
    subscript (_ trip: Trip) -> Trip? {
        return first(where: { $0.id == trip.id })
    }
}
