import SwiftUI

// MARK: - WhileHoverModifier

/// Applies `activeProperties` while the pointer hovers over the view.
/// On macOS and iPadOS with pointer support, this gives hover feedback.
/// Falls back gracefully on iOS without pointer.
public struct WhileHoverModifier: ViewModifier {

    private let activeProperties: [AnimatableProperty]
    private let inactiveProperties: [AnimatableProperty]
    private let transition: MotionTransition

    @StateObject private var gestureState = GestureMotionState()
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        activeProperties: [AnimatableProperty],
        inactiveProperties: [AnimatableProperty] = [],
        transition: MotionTransition = MotionTransition(timing: .tween(duration: 0.15))
    ) {
        self.activeProperties = activeProperties
        self.inactiveProperties = inactiveProperties
        self.transition = transition
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation: Animation? = shouldAnimate ? transition.timing.swiftUIAnimation : nil
        let current = gestureState.isHovered ? activeProperties : inactiveProperties

        PropertyApplicator.apply(current, to: content)
            .animation(animation, value: gestureState.isHovered)
            .onHover { hovering in
                gestureState.isHovered = hovering
            }
    }
}
