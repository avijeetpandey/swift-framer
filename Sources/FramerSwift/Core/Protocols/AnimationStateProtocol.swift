import SwiftUI
import Combine

// MARK: - AnimationState Protocol

/// Defines the observable state machine that drives all FramerSwift animations.
/// Conforming types are responsible for tracking the current phase and notifying
/// SwiftUI of changes via `ObservableObject`.
public protocol AnimationState: ObservableObject {
    /// The current lifecycle phase of this animation.
    var phase: AnimationPhase { get set }

    /// Whether the animation is currently actively running.
    var isAnimating: Bool { get }

    /// Transitions the state to the given phase.
    func transition(to phase: AnimationPhase)

    /// Resets the state back to `.initial`.
    func reset()
}

// MARK: - Default AnimationState Implementations

public extension AnimationState {
    var isAnimating: Bool {
        phase == .animate
    }
}

// MARK: - MotionAnimationState

/// Concrete, general-purpose implementation of `AnimationState`.
/// Thread-safe and designed for use as a `@StateObject` or `@ObservedObject`.
public final class MotionAnimationState: AnimationState {
    @Published public var phase: AnimationPhase

    public init(initialPhase: AnimationPhase = .initial) {
        self.phase = initialPhase
    }

    public func transition(to newPhase: AnimationPhase) {
        guard phase != newPhase else { return }
        phase = newPhase
    }

    public func reset() {
        phase = .initial
    }
}
