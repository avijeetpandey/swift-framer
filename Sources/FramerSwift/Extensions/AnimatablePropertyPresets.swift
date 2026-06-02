import SwiftUI

// MARK: - AnimatableProperty Convenience Constructors

public extension Array where Element == AnimatableProperty {
    /// Preset: fade in from transparent.
    static var fadeIn: [AnimatableProperty] { [.opacity(0)] }

    /// Preset: fade out to transparent.
    static var fadeOut: [AnimatableProperty] { [.opacity(0)] }

    /// Preset: visible state.
    static var visible: [AnimatableProperty] { [.opacity(1)] }

    /// Preset: slide in from bottom.
    static func slideInFromBottom(offset: CGFloat = 40) -> [AnimatableProperty] {
        [.opacity(0), .y(offset)]
    }

    /// Preset: slide in from top.
    static func slideInFromTop(offset: CGFloat = 40) -> [AnimatableProperty] {
        [.opacity(0), .y(-offset)]
    }

    /// Preset: slide in from left.
    static func slideInFromLeft(offset: CGFloat = 40) -> [AnimatableProperty] {
        [.opacity(0), .x(-offset)]
    }

    /// Preset: slide in from right.
    static func slideInFromRight(offset: CGFloat = 40) -> [AnimatableProperty] {
        [.opacity(0), .x(offset)]
    }

    /// Preset: pop in from a small scale.
    static func popIn(fromScale: CGFloat = 0.85) -> [AnimatableProperty] {
        [.opacity(0), .scale(fromScale)]
    }

    /// Preset: standard visible (no transforms).
    static var none: [AnimatableProperty] {
        [.opacity(1), .scale(1), .x(0), .y(0), .rotation(0)]
    }
}
