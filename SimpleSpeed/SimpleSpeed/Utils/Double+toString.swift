import Foundation

extension Optional<Double> {
    var toStringZeroIsNone: String {
        switch self {
        case .none:
            "None"
        case .some(let wrapped):
            wrapped == 0.0 ? "None" : "\(wrapped)"
        }
    }
}
