import SwiftUI

// MARK: - WhileTapModifier

/// Applies `activeProperties` while a tap gesture is held down, returning to
/// `inactiveProperties` (or the base state) on release.
/// Replicates Framer Motion's `whileTap` prop.
///
/// Uses a `Button` + `ButtonStyle` internally so it works correctly inside
/// `ScrollView` without gesture conflicts.
public struct WhileTapModifier: ViewModifier {

    private let activeProperties: [AnimatableProperty]
    private let inactiveProperties: [AnimatableProperty]
    private let transition: MotionTransition
    private let onTap: (() -> Void)?

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        activeProperties: [AnimatableProperty],
        inactiveProperties: [AnimatableProperty] = [],
        transition: MotionTransition = MotionTransition(timing: .spring(SpringConfiguration.stiff)),
        onTap: (() -> Void)? = nil
    ) {
        self.activeProperties = activeProperties
        self.inactiveProperties = inactiveProperties
        self.transition = transition
        self.onTap = onTap
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        Button(action: { onTap?() }) {
            content
        }
        .buttonStyle(
            MotionPressButtonStyle(
                activeProperties: activeProperties,
                inactiveProperties: inactiveProperties,
                animation: shouldAnimate ? transition.timing.swiftUIAnimation : .linear(duration: 0)
            )
        )
    }
}
