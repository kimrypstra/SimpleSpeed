import Foundation

/// Just a utility that converts from m/s to a ``String`` in the ``Locale``'s default units
class SpeedConverter {
    static func format(_ speedInMs: Double) throws -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        
        let speedInMs = Measurement(value: speedInMs, unit: UnitSpeed.metersPerSecond)
        // for now just convert to km/h
        let speedInKph = speedInMs.converted(to: UnitSpeed.kilometersPerHour)
        
        if let returnValue = numberFormatter.string(from: NSNumber(value: speedInKph.value)) {
            return returnValue
        } else {
            throw ConversionError.conversionFailed
        }
    }
}

enum ConversionError: Error {
    case conversionFailed
}
