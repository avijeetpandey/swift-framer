import SwiftUI

// MARK: - KeyframeSequence

/// Manages a sequence of `KeyframeEntry` values and resolves interpolated
/// `AnimatableProperty` values at any normalized time `t ∈ [0, 1]`.
/// Supports per-keyframe easing overrides.
public struct KeyframeSequence: Sendable {
    public let entries: [KeyframeEntry]

    /// The default easing applied between keyframes when no override is set.
    public let defaultEasing: AnyEasing

    public init(
        entries: [KeyframeEntry],
        defaultEasing: any EasingFunction = CubicBezierEasing.easeInOut
    ) {
        precondition(!entries.isEmpty, "KeyframeSequence requires at least one entry.")
        self.entries = entries.sorted { $0.time < $1.time }
        self.defaultEasing = AnyEasing(defaultEasing)
    }

    // MARK: - Evaluation

    /// Returns interpolated properties at normalized time `t`.
    public func evaluate(at t: Double) -> [AnimatableProperty] {
        let clampedT = max(0, min(1, t))

        // Return last keyframe if we've passed the end.
        guard let last = entries.last, clampedT < last.time else {
            return entries.last?.properties ?? []
        }

        // Return first keyframe before animation starts.
        guard let first = entries.first, clampedT >= first.time else {
            return entries.first?.properties ?? []
        }

        // Find the surrounding keyframe pair.
        let (before, after) = surroundingKeyframes(at: clampedT)
        guard let before = before, let after = after else {
            return entries.first?.properties ?? []
        }

        let span = after.time - before.time
        guard span > 0 else { return before.properties }

        let localT = (clampedT - before.time) / span
        let easing = before.easing?.base ?? defaultEasing.base
        let easedT = easing.evaluate(at: localT)

        return interpolateProperties(
            from: before.properties,
            to: after.properties,
            t: easedT
        )
    }

    // MARK: - Private Helpers

    private func surroundingKeyframes(
        at t: Double
    ) -> (before: KeyframeEntry?, after: KeyframeEntry?) {
        var before: KeyframeEntry?
        var after: KeyframeEntry?

        for entry in entries {
            if entry.time <= t {
                before = entry
            } else if after == nil {
                after = entry
            }
        }
        return (before, after)
    }

    /// Interpolates a property array by matching keys and lerping values.
    private func interpolateProperties(
        from: [AnimatableProperty],
        to: [AnimatableProperty],
        t: Double
    ) -> [AnimatableProperty] {
        var result: [AnimatableProperty] = []
        let toDict = Dictionary(uniqueKeysWithValues: to.map { ($0.key, $0) })

        for fromProp in from {
            if let toProp = toDict[fromProp.key] {
                let interpolatedValue = ValueInterpolator.lerp(
                    fromProp.doubleValue,
                    toProp.doubleValue,
                    t: t
                )
                result.append(fromProp.withValue(interpolatedValue))
            } else {
                result.append(fromProp)
            }
        }

        // Include any properties present in `to` but not `from` (interpolate from their natural default).
        let fromKeys = Set(from.map { $0.key })
        for toProp in to where !fromKeys.contains(toProp.key) {
            let interpolatedValue = ValueInterpolator.lerp(
                toProp.withValue(defaultDoubleValue(for: toProp)).doubleValue,
                toProp.doubleValue,
                t: t
            )
            result.append(toProp.withValue(interpolatedValue))
        }

        return result
    }

    /// Returns the natural identity value for a given property type.
    private func defaultDoubleValue(for property: AnimatableProperty) -> Double {
        switch property {
        case .opacity: return 1.0
        case .scale, .scaleX, .scaleY: return 1.0
        case .rotation, .rotationX, .rotationY: return 0.0
        case .x, .y: return 0.0
        case .width, .height: return 0.0
        case .blur: return 0.0
        case .brightness: return 0.0
        case .saturation: return 1.0
        case .cornerRadius: return 0.0
        }
    }
}
