import SwiftUI

// MARK: - SpringSimulator

/// Numerically simulates spring physics using the analytical solution
/// for underdamped, overdamped, and critically damped systems.
/// This matches the Framer Motion / Popmotion spring implementation.
public struct SpringSimulator: Sendable {
    public let config: SpringConfiguration

    public init(config: SpringConfiguration = .default) {
        self.config = config
    }

    /// Evaluates the spring position at time `t` (seconds), interpolating
    /// from `from` to `to`.
    /// - Returns: The spring's displacement value at time `t`.
    public func value(at t: Double, from: Double = 0, to: Double = 1) -> Double {
        let x0 = from - to  // displacement from rest position
        let v0 = config.initialVelocity
        let ω0 = config.angularFrequency
        let ζ = config.dampingRatio

        let result: Double
        if config.isOverdamped {
            let α = ω0 * sqrt(ζ * ζ - 1)
            let c1 = (x0 * (ω0 * ζ + α) + v0) / (2 * α)
            let c2 = x0 - c1
            let eNeg = exp((-ω0 * ζ + α) * t)
            let ePos = exp((-ω0 * ζ - α) * t)
            result = c1 * eNeg + c2 * ePos
        } else if config.isCriticallyDamped {
            let e = exp(-ω0 * t)
            result = (x0 + (v0 + ω0 * x0) * t) * e
        } else {
            let ωd = ω0 * sqrt(1 - ζ * ζ)
            let e = exp(-ζ * ω0 * t)
            let c1 = x0
            let c2 = (v0 + ζ * ω0 * x0) / ωd
            result = e * (c1 * cos(ωd * t) + c2 * sin(ωd * t))
        }

        return result + to
    }

    /// Evaluates the spring velocity at time `t` (seconds).
    public func velocity(at t: Double, from: Double = 0, to: Double = 1) -> Double {
        let dt = 1e-5
        let v1 = value(at: t, from: from, to: to)
        let v2 = value(at: t + dt, from: from, to: to)
        return (v2 - v1) / dt
    }

    /// Checks if the spring has settled (position and velocity within rest thresholds).
    public func isAtRest(at t: Double, from: Double = 0, to: Double = 1) -> Bool {
        let pos = value(at: t, from: from, to: to)
        let vel = velocity(at: t, from: from, to: to)
        return abs(pos - to) <= config.restDelta && abs(vel) <= config.restSpeed
    }

    /// Finds the settling time using binary search.
    public func settlingTime(from: Double = 0, to: Double = 1) -> Double {
        var low = 0.0, high = 10.0
        for _ in 0..<50 {
            let mid = (low + high) / 2
            if isAtRest(at: mid, from: from, to: to) {
                high = mid
            } else {
                low = mid
            }
        }
        return high
    }

    /// Generates a normalized progress value `∈ [0, 1]` at normalized time `t ∈ [0, 1]`,
    /// suitable for use as an `EasingFunction.evaluate`.
    public func normalizedProgress(at t: Double) -> Double {
        let duration = settlingTime()
        guard duration > 0 else { return 1.0 }
        let pos = value(at: t * duration, from: 0, to: 1)
        return pos
    }
}
