import SwiftUI

// MARK: - SpringEasing (EasingFunction conformance)

/// Bridges `SpringSimulator` to the `EasingFunction` protocol so springs
/// can be used anywhere a timing curve is expected.
public struct SpringEasing: EasingFunction {
    public let config: SpringConfiguration
    private let simulator: SpringSimulator

    public init(config: SpringConfiguration = .default) {
        self.config = config
        self.simulator = SpringSimulator(config: config)
    }

    public func evaluate(at t: Double) -> Double {
        simulator.normalizedProgress(at: t)
    }

    public var swiftUIAnimation: Animation {
        config.swiftUIAnimation
    }

    public var estimatedDuration: Double {
        config.estimatedSettlingDuration
    }
}
