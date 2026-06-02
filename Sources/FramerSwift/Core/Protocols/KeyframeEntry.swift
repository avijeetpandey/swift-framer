import SwiftUI

// MARK: - KeyframeEntry

/// A single keyframe point: a normalized time offset and a set of target properties.
public struct KeyframeEntry: Sendable {
    /// Normalized time in `[0, 1]`.
    public let time: Double
    /// Properties at this keyframe.
    public let properties: [AnimatableProperty]
    /// Optional per-keyframe easing override.
    public let easing: AnyEasing?

    public init(
        time: Double,
        properties: [AnimatableProperty],
        easing: (any EasingFunction)? = nil
    ) {
        self.time = time
        self.properties = properties
        self.easing = easing.map { AnyEasing($0) }
    }
}
