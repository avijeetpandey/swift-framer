import SwiftUI

// MARK: - SpringConfiguration

/// Physics parameters for a spring animation, matching Framer Motion's
/// spring API surface with mass, stiffness, damping, and velocity.
public struct SpringConfiguration: Sendable, Equatable {

    /// Mass of the simulated object (kg). Higher mass = slower response.
    public let mass: Double

    /// Spring stiffness constant (N/m). Higher = snappier.
    public let stiffness: Double

    /// Damping coefficient (N·s/m). Higher = less oscillation.
    public let damping: Double

    /// Initial velocity (units/s). Positive = moving toward target.
    public let initialVelocity: Double

    /// If `true`, the spring will use `restDelta` and `restSpeed` to settle early.
    public let allowsOverdamping: Bool

    /// Displacement threshold below which the spring is considered at rest.
    public let restDelta: Double

    /// Velocity threshold below which the spring is considered at rest.
    public let restSpeed: Double

    public init(
        mass: Double = 1.0,
        stiffness: Double = 100.0,
        damping: Double = 10.0,
        initialVelocity: Double = 0.0,
        allowsOverdamping: Bool = false,
        restDelta: Double = 0.001,
        restSpeed: Double = 0.01
    ) {
        self.mass = mass
        self.stiffness = stiffness
        self.damping = damping
        self.initialVelocity = initialVelocity
        self.allowsOverdamping = allowsOverdamping
        self.restDelta = restDelta
        self.restSpeed = restSpeed
    }

    // MARK: Preset Configurations

    /// Framer Motion default: balanced spring.
    public static let `default` = SpringConfiguration()

    /// Gentle, slow spring suitable for large elements.
    public static let gentle = SpringConfiguration(
        mass: 1.0, stiffness: 120, damping: 14
    )

    /// Stiff, direct spring for fast UI elements.
    public static let stiff = SpringConfiguration(
        mass: 1.0, stiffness: 210, damping: 20
    )

    /// Wobbly spring with visible oscillation.
    public static let wobbly = SpringConfiguration(
        mass: 1.0, stiffness: 180, damping: 12
    )

    /// Slow, overdamped spring — no oscillation.
    public static let slow = SpringConfiguration(
        mass: 3.0, stiffness: 30, damping: 20
    )

    /// Bouncy spring with high initial energy.
    public static let bouncy = SpringConfiguration(
        mass: 1.0, stiffness: 300, damping: 15, initialVelocity: 10
    )

    // MARK: Derived Properties

    /// The damping ratio ζ = damping / (2 * √(stiffness * mass)).
    public var dampingRatio: Double {
        damping / (2 * sqrt(stiffness * mass))
    }

    /// The angular frequency ω₀ = √(stiffness / mass).
    public var angularFrequency: Double {
        sqrt(stiffness / max(mass, 1e-10))
    }

    /// Whether the spring is overdamped (ζ ≥ 1) — no oscillation.
    public var isOverdamped: Bool { dampingRatio >= 1 }

    /// Whether the spring is critically damped (ζ == 1) — fastest non-oscillating.
    public var isCriticallyDamped: Bool { abs(dampingRatio - 1.0) < 0.01 }

    /// Whether the spring is underdamped (ζ < 1) — oscillates.
    public var isUnderdamped: Bool { dampingRatio < 1 }

    /// Estimated settling duration based on the 5% amplitude rule.
    public var estimatedSettlingDuration: Double {
        guard dampingRatio > 0 else { return 2.0 }
        if isOverdamped || isCriticallyDamped {
            return 3.0 / (dampingRatio * angularFrequency)
        }
        let dampedFreq = angularFrequency * sqrt(max(1 - dampingRatio * dampingRatio, 1e-10))
        return -log(restDelta) / (dampingRatio * angularFrequency)
            + (dampedFreq > 0 ? .pi / dampedFreq : 0)
    }

    /// The SwiftUI `Animation` equivalent for this spring configuration.
    public var swiftUIAnimation: Animation {
        return .interpolatingSpring(
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity
        )
    }
}
