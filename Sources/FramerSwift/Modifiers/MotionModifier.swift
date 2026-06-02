import SwiftUI

// MARK: - MotionModifier

/// The primary `ViewModifier` that drives all FramerSwift property animations.
/// Observes a `MotionViewModel` and applies `AnimatableProperty` values to
/// the wrapped content on each state change.
public struct MotionModifier: ViewModifier {

    @StateObject private var viewModel: MotionViewModel
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.motionStaggerIndex) private var staggerIndex
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let triggerOnAppear: Bool

    public init(
        initial: [AnimatableProperty],
        animate: [AnimatableProperty],
        exit: [AnimatableProperty] = [],
        transition: MotionTransition = .default,
        exitTransition: MotionTransition = .default,
        triggerOnAppear: Bool = true
    ) {
        _viewModel = StateObject(wrappedValue: MotionViewModel(
            initial: initial,
            animate: animate,
            exit: exit,
            transition: transition,
            exitTransition: exitTransition
        ))
        self.triggerOnAppear = triggerOnAppear
    }

    public init(variantSet: VariantSet, triggerOnAppear: Bool = true) {
        _viewModel = StateObject(wrappedValue: MotionViewModel(variantSet: variantSet))
        self.triggerOnAppear = triggerOnAppear
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation = shouldAnimate
            ? viewModel.animation(
                for: viewModel.currentPhase,
                speedMultiplier: motionConfig.speedMultiplier
              )
            : nil

        PropertyApplicator.apply(viewModel.resolvedProperties, to: content)
            .animation(animation, value: viewModel.resolvedProperties.map { $0.doubleValue })
            .onAppear {
                if triggerOnAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        viewModel.appear(reducedMotion: motionConfig.reducedMotion || reduceMotion)
                    }
                }
            }
    }

    /// Programmatically trigger the animate phase.
    public func animate() {
        viewModel.appear()
    }

    /// Programmatically trigger the exit phase.
    public func exit() {
        viewModel.disappear()
    }
}


