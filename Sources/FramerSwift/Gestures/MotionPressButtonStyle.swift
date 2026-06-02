import SwiftUI

// MARK: - MotionPressButtonStyle

/// `ButtonStyle` that applies `AnimatableProperty` values based on press state.
/// Works natively in `ScrollView` because SwiftUI's `Button` has built-in
/// UIKit gesture integration that properly handles scroll/tap disambiguation.
public struct MotionPressButtonStyle: ButtonStyle {
    public let activeProperties: [AnimatableProperty]
    public let inactiveProperties: [AnimatableProperty]
    public let animation: Animation

    public init(
        activeProperties: [AnimatableProperty],
        inactiveProperties: [AnimatableProperty] = [],
        animation: Animation = .interactiveSpring()
    ) {
        self.activeProperties = activeProperties
        self.inactiveProperties = inactiveProperties
        self.animation = animation
    }

    public func makeBody(configuration: Configuration) -> some View {
        let current = configuration.isPressed ? activeProperties : inactiveProperties
        PropertyApplicator.apply(current, to: configuration.label)
            .animation(animation, value: configuration.isPressed)
    }
}
