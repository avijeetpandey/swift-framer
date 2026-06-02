import SwiftUI

// MARK: - MotionTransition

/// Configures how a transition between two variant states is performed,
/// including timing, delay, and repeat behavior.
public struct MotionTransition: Sendable {
    /// The timing curve for this transition.
    public let timing: MotionTiming

    /// Delay before the transition begins, in seconds.
    public let delay: Double

    /// Number of times to repeat the transition. `.infinity` for looping.
    public let repeatCount: RepeatCount

    /// Whether alternating repeats reverse direction.
    public let repeatMirror: Bool

    /// Stagger delay applied per child when used in a container variant.
    public let staggerChildren: Double

    /// Delay applied before staggering children begins.
    public let delayChildren: Double

    public init(
        timing: MotionTiming = .spring(),
        delay: Double = 0,
        repeatCount: RepeatCount = .none,
        repeatMirror: Bool = false,
        staggerChildren: Double = 0,
        delayChildren: Double = 0
    ) {
        self.timing = timing
        self.delay = delay
        self.repeatCount = repeatCount
        self.repeatMirror = repeatMirror
        self.staggerChildren = staggerChildren
        self.delayChildren = delayChildren
    }

    /// A default transition with spring physics.
    public static let `default` = MotionTransition()

    /// A transition with no animation (instant).
    public static let instant = MotionTransition(timing: .tween(duration: 0))
}
