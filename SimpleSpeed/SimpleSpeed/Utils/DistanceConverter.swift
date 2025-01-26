import Foundation

/// Just a utility that converts from metres to a ``String`` in the ``Locale``'s default units
class DistanceConverter {
    static func format(_ distanceInMetres: Double) throws -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        
        let distanceInMetres = Measurement(value: distanceInMetres, unit: UnitLength.meters)
        // for now just convert to metres
        let distanceInKm = distanceInMetres.converted(to: UnitLength.kilometers)
        
        if let returnValue = numberFormatter.string(from: NSNumber(value: distanceInKm.value)) {
            return returnValue
        } else {
            throw ConversionError.conversionFailed
        }
    }
}
