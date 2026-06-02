import SwiftUI

// MARK: - KeyframeEasing (EasingFunction conformance)

/// Bridges `KeyframeSequence` to the `EasingFunction` protocol,
/// treating the keyframes as a composite easing function over normalized time.
public struct KeyframeEasing: EasingFunction {
    public let sequence: KeyframeSequence

    public init(sequence: KeyframeSequence) {
        self.sequence = sequence
    }

    /// Evaluates the overall progress at normalized time `t`.
    /// Uses the first property's value as the progress indicator.
    public func evaluate(at t: Double) -> Double {
        let properties = sequence.evaluate(at: t)
        return properties.first?.doubleValue ?? t
    }

    public var swiftUIAnimation: Animation {
        .easeInOut
    }

    public var estimatedDuration: Double {
        sequence.entries.last?.time ?? 0.3
    }
}
