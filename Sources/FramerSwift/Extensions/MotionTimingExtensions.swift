import SwiftUI

// MARK: - MotionTiming Convenience Builders

public extension MotionTiming {
    /// Creates a tween timing from a named `TweenConfiguration` preset.
    static func tween(_ preset: TweenConfiguration) -> MotionTiming {
        .tween(duration: preset.duration, easing: preset.easing)
    }
}
