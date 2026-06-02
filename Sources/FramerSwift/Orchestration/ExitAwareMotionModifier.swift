import SwiftUI

// MARK: - ExitAwareMotionModifier

/// A modifier applied to a child of `AnimatePresence` that listens for the
/// presence coordinator's `exitPhase` and triggers the exit animation.
public struct ExitAwareMotionModifier: ViewModifier {

    @Environment(\.motionPresenceCoordinator) private var coordinator
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var viewModel: MotionViewModel

    public init(
        initial: [AnimatableProperty],
        animate: [AnimatableProperty],
        exit: [AnimatableProperty],
        transition: MotionTransition = .default,
        exitTransition: MotionTransition = .default
    ) {
        _viewModel = StateObject(wrappedValue: MotionViewModel(
            initial: initial,
            animate: animate,
            exit: exit,
            transition: transition,
            exitTransition: exitTransition
        ))
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation = shouldAnimate
            ? viewModel.animation(for: viewModel.currentPhase)
            : nil

        PropertyApplicator.apply(viewModel.resolvedProperties, to: content)
            .animation(animation, value: viewModel.resolvedProperties.map { $0.doubleValue })
            .onAppear {
                viewModel.appear()
            }
            .onChange(of: coordinator?.exitPhase) { isExiting in
                if isExiting == true {
                    viewModel.disappear()
                } else {
                    viewModel.appear()
                }
            }
    }
}

// MARK: - View Extension for AnimatePresence integration

public extension View {
    /// Use inside `AnimatePresence` to enable exit animation awareness.
    func motionPresence(
        initial: [AnimatableProperty],
        animate: [AnimatableProperty],
        exit: [AnimatableProperty],
        transition: MotionTransition = .default,
        exitTransition: MotionTransition = .default
    ) -> some View {
        modifier(ExitAwareMotionModifier(
            initial: initial,
            animate: animate,
            exit: exit,
            transition: transition,
            exitTransition: exitTransition
        ))
    }
}
