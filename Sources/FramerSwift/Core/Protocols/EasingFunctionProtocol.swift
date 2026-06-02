import SwiftUI

// MARK: - EasingFunction Protocol

/// Defines a timing curve that maps normalized time `t ∈ [0, 1]` to a
/// progress value. Non-linear outputs outside [0, 1] are allowed to model
/// spring overshoot.
public protocol EasingFunction: Sendable {
    /// Evaluates the easing curve at normalized time `t`.
    /// - Parameter t: Normalized time, typically in `[0, 1]`.
    /// - Returns: The eased progress value (may overshoot for spring curves).
    func evaluate(at t: Double) -> Double

    /// The SwiftUI `Animation` that most closely matches this timing curve.
    /// Used when bridging to SwiftUI's native animation system.
    var swiftUIAnimation: Animation { get }

    /// Estimated total duration for this curve (in seconds).
    var estimatedDuration: Double { get }
}
