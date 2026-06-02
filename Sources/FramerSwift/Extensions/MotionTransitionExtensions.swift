import SwiftUI

// MARK: - MotionTransition Convenience Builders

public extension MotionTransition {
    /// Creates a transition with spring timing.
    static func spring(_ config: SpringConfiguration = .default) -> MotionTransition {
        MotionTransition(timing: .spring(config))
    }

    /// Creates a transition with tween timing.
    static func tween(
        duration: Double = 0.3,
        easing: any EasingFunction = CubicBezierEasing.easeInOut
    ) -> MotionTransition {
        MotionTransition(timing: .tween(duration: duration, easing: AnyEasing(easing)))
    }

    /// Creates a looping transition.
    static func loop(
        timing: MotionTiming = .spring(),
        mirror: Bool = true
    ) -> MotionTransition {
        MotionTransition(
            timing: timing,
            repeatCount: .infinity,
            repeatMirror: mirror
        )
    }

    /// Creates a delayed transition.
    func delayed(by seconds: Double) -> MotionTransition {
        MotionTransition(
            timing: self.timing,
            delay: self.delay + seconds,
            repeatCount: self.repeatCount,
            repeatMirror: self.repeatMirror,
            staggerChildren: self.staggerChildren,
            delayChildren: self.delayChildren
        )
    }

    /// Adds stagger configuration to an existing transition.
    func stagger(children: Double, delay: Double = 0) -> MotionTransition {
        MotionTransition(
            timing: self.timing,
            delay: self.delay,
            repeatCount: self.repeatCount,
            repeatMirror: self.repeatMirror,
            staggerChildren: children,
            delayChildren: delay
        )
    }
}
