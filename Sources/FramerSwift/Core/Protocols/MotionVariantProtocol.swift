import SwiftUI

// MARK: - MotionVariant Protocol

/// A `MotionVariant` encapsulates a named set of `AnimatableProperty` values
/// bound to an `AnimationPhase`. This mirrors Framer Motion's `variants` API,
/// allowing you to define named states and orchestrate transitions between them.
public protocol MotionVariant: Sendable {
    /// The phase this variant represents.
    var phase: AnimationPhase { get }

    /// The set of animatable properties for this variant state.
    var properties: [AnimatableProperty] { get }

    /// The transition configuration applied when entering this variant.
    var transition: MotionTransition { get }
}
