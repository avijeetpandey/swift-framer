import SwiftUI

// MARK: - MotionConfiguration

/// Central configuration object passed through the view hierarchy via
/// `EnvironmentValues`. Allows global defaults to be overridden.
public struct MotionConfiguration: Sendable {
    /// When `true`, all animations are skipped (useful for accessibility / testing).
    public var reducedMotion: Bool

    /// Global animation speed multiplier. 1.0 is normal, 2.0 is double speed.
    public var speedMultiplier: Double

    /// Default timing used when no explicit transition is specified.
    public var defaultTiming: MotionTiming

    public init(
        reducedMotion: Bool = false,
        speedMultiplier: Double = 1.0,
        defaultTiming: MotionTiming = .spring()
    ) {
        self.reducedMotion = reducedMotion
        self.speedMultiplier = speedMultiplier
        self.defaultTiming = defaultTiming
    }

    public static let `default` = MotionConfiguration()
}

// MARK: - EnvironmentKey

private struct MotionConfigurationKey: EnvironmentKey {
    static let defaultValue = MotionConfiguration.default
}

public extension EnvironmentValues {
    var motionConfiguration: MotionConfiguration {
        get { self[MotionConfigurationKey.self] }
        set { self[MotionConfigurationKey.self] = newValue }
    }
}

public extension View {
    /// Overrides the global FramerSwift animation configuration for this subtree.
    func motionConfiguration(_ config: MotionConfiguration) -> some View {
        environment(\.motionConfiguration, config)
    }

    /// Disables all FramerSwift animations in this subtree.
    func motionDisabled(_ disabled: Bool = true) -> some View {
        environment(
            \.motionConfiguration,
            MotionConfiguration(reducedMotion: disabled)
        )
    }
}
