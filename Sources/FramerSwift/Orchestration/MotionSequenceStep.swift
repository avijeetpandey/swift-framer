import SwiftUI

// MARK: - MotionSequenceStep

/// A single step in a motion sequence: a set of target properties and transition.
///
/// ## Usage
/// ```swift
/// MotionSequenceStep(properties: [.scale(1.2)], transition: .tween(duration: 0.2))
/// ```
public struct MotionSequenceStep: Sendable {
    public let properties: [AnimatableProperty]
    public let transition: MotionTransition

    public init(properties: [AnimatableProperty], transition: MotionTransition = .default) {
        self.properties = properties
        self.transition = transition
    }
}
