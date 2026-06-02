import SwiftUI

// MARK: - MotionVariantState

/// A concrete, value-type implementation of `MotionVariant`.
public struct MotionVariantState: MotionVariant {
    public let phase: AnimationPhase
    public let properties: [AnimatableProperty]
    public let transition: MotionTransition

    public init(
        phase: AnimationPhase,
        properties: [AnimatableProperty],
        transition: MotionTransition = .default
    ) {
        self.phase = phase
        self.properties = properties
        self.transition = transition
    }
}
