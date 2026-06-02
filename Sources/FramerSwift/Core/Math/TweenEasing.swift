import SwiftUI

// MARK: - TweenEasing (EasingFunction conformance)

/// Bridges `TweenInterpolator` to the `EasingFunction` protocol.
public struct TweenEasing: EasingFunction {
    public let config: TweenConfiguration

    public init(config: TweenConfiguration = .standard) {
        self.config = config
    }

    public func evaluate(at t: Double) -> Double {
        TweenInterpolator(config: config).value(at: t, from: 0, to: 1)
    }

    public var swiftUIAnimation: Animation {
        TweenInterpolator(config: config).swiftUIAnimation
    }

    public var estimatedDuration: Double {
        config.duration
    }
}
