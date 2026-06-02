import SwiftUI

// MARK: - TweenConfiguration

/// Configuration for a tween animation: a fixed-duration animation driven
/// by a configurable easing curve.
public struct TweenConfiguration: Sendable {
    /// Total animation duration in seconds.
    public let duration: Double

    /// The easing curve applied over the duration.
    public let easing: AnyEasing

    /// Optional yoyo / ping-pong behavior: reverses on each repeat.
    public let yoyo: Bool

    public init(
        duration: Double = 0.3,
        easing: any EasingFunction = CubicBezierEasing.easeInOut,
        yoyo: Bool = false
    ) {
        self.duration = duration
        self.easing = AnyEasing(easing)
        self.yoyo = yoyo
    }

    // MARK: Named Presets

    /// Fast 200ms ease-out, ideal for micro-interactions.
    public static let micro = TweenConfiguration(
        duration: 0.2, easing: CubicBezierEasing.easeOut
    )

    /// Standard 300ms ease-in-out.
    public static let standard = TweenConfiguration(
        duration: 0.3, easing: CubicBezierEasing.easeInOut
    )

    /// Smooth 500ms ease-in-out for large layout transitions.
    public static let smooth = TweenConfiguration(
        duration: 0.5, easing: CubicBezierEasing.easeInOut
    )

    /// Slow 800ms ease with anticipation effect.
    public static let cinematic = TweenConfiguration(
        duration: 0.8, easing: CubicBezierEasing.anticipate
    )
}
