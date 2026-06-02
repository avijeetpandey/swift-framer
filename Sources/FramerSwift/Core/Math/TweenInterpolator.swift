import SwiftUI

// MARK: - TweenInterpolator

/// Computes the interpolated value for a tween animation at a given
/// normalized time `t ∈ [0, 1]`, applying the configured easing curve.
public struct TweenInterpolator: Sendable {
    public let config: TweenConfiguration

    public init(config: TweenConfiguration = .standard) {
        self.config = config
    }

    /// Returns the interpolated value between `from` and `to` at normalized time `t`.
    public func value(at t: Double, from: Double, to: Double) -> Double {
        let clampedT = max(0, min(1, t))
        let easedT: Double
        if config.yoyo && clampedT > 0.5 {
            easedT = 1.0 - config.easing.base.evaluate(at: (1.0 - clampedT) * 2)
        } else {
            easedT = config.easing.base.evaluate(at: config.yoyo ? clampedT * 2 : clampedT)
        }
        return from + (to - from) * easedT
    }

    /// Returns the SwiftUI `Animation` for this tween configuration.
    public var swiftUIAnimation: Animation {
        let base = config.easing.base.swiftUIAnimation
        let speed = config.duration > 0 ? 1.0 / config.duration : 1.0
        return base.speed(speed)
    }
}
