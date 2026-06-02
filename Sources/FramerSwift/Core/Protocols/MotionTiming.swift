import SwiftUI

// MARK: - MotionTiming

/// Wraps supported timing strategies: spring physics, tween curves, and keyframe sequences.
public enum MotionTiming: Sendable {
    case spring(SpringConfiguration = .default)
    case tween(duration: Double, easing: AnyEasing = AnyEasing(.easeInOut))
    case keyframes([KeyframeEntry])

    /// Creates the corresponding SwiftUI `Animation`.
    public var swiftUIAnimation: Animation {
        switch self {
        case .spring(let config):
            return config.swiftUIAnimation
        case .tween(let duration, let easing):
            return easing.base.swiftUIAnimation.speed(1.0 / max(duration, 0.001))
        case .keyframes:
            return .easeInOut
        }
    }

    /// Estimated total duration for scheduling stagger and delay.
    public var estimatedDuration: Double {
        switch self {
        case .spring(let config):
            return config.estimatedSettlingDuration
        case .tween(let duration, _):
            return duration
        case .keyframes(let entries):
            return entries.last?.time ?? 0
        }
    }
}
