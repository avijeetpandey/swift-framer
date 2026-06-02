import SwiftUI

// MARK: - LongPressMotionModifier

/// Applies `activeProperties` after a long press is recognized.
public struct LongPressMotionModifier: ViewModifier {

    private let activeProperties: [AnimatableProperty]
    private let inactiveProperties: [AnimatableProperty]
    private let minimumDuration: Double
    private let transition: MotionTransition
    private let onLongPress: (() -> Void)?

    @StateObject private var gestureState = GestureMotionState()
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        activeProperties: [AnimatableProperty],
        inactiveProperties: [AnimatableProperty] = [],
        minimumDuration: Double = 0.5,
        transition: MotionTransition = .default,
        onLongPress: (() -> Void)? = nil
    ) {
        self.activeProperties = activeProperties
        self.inactiveProperties = inactiveProperties
        self.minimumDuration = minimumDuration
        self.transition = transition
        self.onLongPress = onLongPress
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation: Animation? = shouldAnimate ? transition.timing.swiftUIAnimation : nil
        let current = gestureState.isTapped ? activeProperties : inactiveProperties

        PropertyApplicator.apply(current, to: content)
            .animation(animation, value: gestureState.isTapped)
            .gesture(
                LongPressGesture(minimumDuration: minimumDuration)
                    .onEnded { _ in
                        gestureState.isTapped = true
                        onLongPress?()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            gestureState.isTapped = false
                        }
                    }
            )
    }
}
