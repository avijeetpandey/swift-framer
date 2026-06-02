import SwiftUI

// MARK: - AnimatablePropertyInterpolator

/// Interpolates a single `AnimatableProperty` value between two states
/// at a given normalized time, using a provided `EasingFunction`.
public struct AnimatablePropertyInterpolator: Sendable {

    /// Interpolates `from` → `to` at normalized time `t` using `easing`.
    public static func interpolate(
        from: AnimatableProperty,
        to: AnimatableProperty,
        t: Double,
        easing: any EasingFunction = CubicBezierEasing.easeInOut
    ) -> AnimatableProperty {
        guard from.key == to.key else { return from }
        let easedT = easing.evaluate(at: max(0, min(1, t)))
        let value = ValueInterpolator.lerp(from.doubleValue, to.doubleValue, t: easedT)
        return from.withValue(value)
    }

    /// Interpolates a full array of properties, matching by key.
    public static func interpolateAll(
        from: [AnimatableProperty],
        to: [AnimatableProperty],
        t: Double,
        easing: any EasingFunction = CubicBezierEasing.easeInOut
    ) -> [AnimatableProperty] {
        let toDict = Dictionary(uniqueKeysWithValues: to.map { ($0.key, $0) })
        return from.map { fromProp in
            guard let toProp = toDict[fromProp.key] else { return fromProp }
            return interpolate(from: fromProp, to: toProp, t: t, easing: easing)
        }
    }
}
