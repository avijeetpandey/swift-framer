import SwiftUI

// MARK: - VariantSet

/// A complete set of named variant states keyed by `AnimationPhase`.
/// Provides O(1) lookup of properties for any given phase.
public struct VariantSet: Sendable {
    private let variants: [AnimationPhase: MotionVariantState]

    public init(variants: [MotionVariantState]) {
        self.variants = Dictionary(uniqueKeysWithValues: variants.map { ($0.phase, $0) })
    }

    public subscript(phase: AnimationPhase) -> MotionVariantState? {
        variants[phase]
    }

    public func properties(for phase: AnimationPhase) -> [AnimatableProperty] {
        variants[phase]?.properties ?? []
    }

    public func transition(for phase: AnimationPhase) -> MotionTransition {
        variants[phase]?.transition ?? .default
    }
}
