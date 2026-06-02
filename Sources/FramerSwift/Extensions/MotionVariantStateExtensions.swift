import SwiftUI

// MARK: - MotionVariantState DSL Builders

public extension MotionVariantState {
    /// The initial (hidden) variant.
    static func initial(
        _ properties: [AnimatableProperty],
        transition: MotionTransition = .default
    ) -> MotionVariantState {
        MotionVariantState(phase: .initial, properties: properties, transition: transition)
    }

    /// The animate (visible) variant.
    static func animate(
        _ properties: [AnimatableProperty],
        transition: MotionTransition = .default
    ) -> MotionVariantState {
        MotionVariantState(phase: .animate, properties: properties, transition: transition)
    }

    /// The exit variant.
    static func exit(
        _ properties: [AnimatableProperty],
        transition: MotionTransition = .default
    ) -> MotionVariantState {
        MotionVariantState(phase: .exit, properties: properties, transition: transition)
    }

    /// A custom named variant.
    static func custom(
        _ name: String,
        properties: [AnimatableProperty],
        transition: MotionTransition = .default
    ) -> MotionVariantState {
        MotionVariantState(phase: .custom(name), properties: properties, transition: transition)
    }
}
