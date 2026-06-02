import SwiftUI

// MARK: - ValueInterpolator

/// Generic numeric interpolator for `Double` values.
/// Supports linear, bezier, and spring-driven interpolation.
public struct ValueInterpolator: Sendable {
    /// Linearly interpolates between `a` and `b` by factor `t`.
    public static func lerp(_ a: Double, _ b: Double, t: Double) -> Double {
        a + (b - a) * t
    }

    /// Clamps `value` to the range `[min, max]`.
    public static func clamp(_ value: Double, min: Double, max: Double) -> Double {
        Swift.max(min, Swift.min(max, value))
    }

    /// Normalizes `value` from the range `[low, high]` to `[0, 1]`.
    public static func normalize(_ value: Double, low: Double, high: Double) -> Double {
        guard high != low else { return 0 }
        return (value - low) / (high - low)
    }

    /// Maps `value` from input range `[inLow, inHigh]` to output range `[outLow, outHigh]`.
    public static func mapRange(
        _ value: Double,
        inLow: Double, inHigh: Double,
        outLow: Double, outHigh: Double,
        clamp: Bool = false
    ) -> Double {
        let t = normalize(value, low: inLow, high: inHigh)
        let mapped = lerp(outLow, outHigh, t: t)
        if clamp {
            let lo = Swift.min(outLow, outHigh)
            let hi = Swift.max(outLow, outHigh)
            return ValueInterpolator.clamp(mapped, min: lo, max: hi)
        }
        return mapped
    }

    /// Interpolates between two `CGPoint` values.
    public static func lerp(_ a: CGPoint, _ b: CGPoint, t: Double) -> CGPoint {
        CGPoint(
            x: lerp(Double(a.x), Double(b.x), t: t),
            y: lerp(Double(a.y), Double(b.y), t: t)
        )
    }

    /// Interpolates between two `CGSize` values.
    public static func lerp(_ a: CGSize, _ b: CGSize, t: Double) -> CGSize {
        CGSize(
            width: lerp(Double(a.width), Double(b.width), t: t),
            height: lerp(Double(a.height), Double(b.height), t: t)
        )
    }
}
