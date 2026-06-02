import SwiftUI

// MARK: - MotionViewModifierProtocol

/// Protocol for all FramerSwift `ViewModifier`s. Enforces consistent
/// configuration and application patterns.
public protocol MotionViewModifierProtocol: ViewModifier {
    /// Current rendering properties (interpolated between initial/animate/exit).
    var currentProperties: [AnimatableProperty] { get }

    /// Applies the given set of `AnimatableProperty` values to `content`.
    func applyProperties(_ properties: [AnimatableProperty], to content: Content) -> AnyView
}
