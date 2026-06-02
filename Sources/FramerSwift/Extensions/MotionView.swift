import SwiftUI

// MARK: - MotionView (Main Public View)

/// The primary FramerSwift view wrapper. Wraps any SwiftUI `Content` and animates
/// its `AnimatableProperty` values declaratively, matching Framer Motion's API surface.
///
/// ## Usage
/// ```swift
/// MotionView {
///     Circle().fill(.blue)
/// }
/// .motionInitial([.opacity(0), .scale(0.8)])
/// .motionAnimate([.opacity(1), .scale(1)])
/// .motionTransition(.spring(.bouncy))
/// ```
public struct MotionView<Content: View>: View {

    // MARK: Private State

    @StateObject private var viewModel: MotionViewModel
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.motionStaggerIndex) private var staggerIndex
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let content: Content
    private let initial: [AnimatableProperty]
    private let animate: [AnimatableProperty]
    private let exit: [AnimatableProperty]
    private let transition: MotionTransition
    private let exitTransition: MotionTransition
    private let triggerOnAppear: Bool

    // MARK: Initializers

    public init(
        initial: [AnimatableProperty] = [],
        animate: [AnimatableProperty] = [],
        exit: [AnimatableProperty] = [],
        transition: MotionTransition = .default,
        exitTransition: MotionTransition = .default,
        triggerOnAppear: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.initial = initial
        self.animate = animate
        self.exit = exit
        self.transition = transition
        self.exitTransition = exitTransition
        self.triggerOnAppear = triggerOnAppear
        self.content = content()
        _viewModel = StateObject(wrappedValue: MotionViewModel(
            initial: initial,
            animate: animate,
            exit: exit,
            transition: transition,
            exitTransition: exitTransition
        ))
    }

    public init(
        variantSet: VariantSet,
        triggerOnAppear: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.initial = variantSet.properties(for: .initial)
        self.animate = variantSet.properties(for: .animate)
        self.exit = variantSet.properties(for: .exit)
        self.transition = variantSet.transition(for: .animate)
        self.exitTransition = variantSet.transition(for: .exit)
        self.triggerOnAppear = triggerOnAppear
        self.content = content()
        _viewModel = StateObject(wrappedValue: MotionViewModel(variantSet: variantSet))
    }

    // MARK: Body

    public var body: some View {
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
                guard triggerOnAppear else { return }
                let baseDelay = transition.delay
                let staggerDelay = Double(staggerIndex) * transition.staggerChildren
                let totalDelay = baseDelay + staggerDelay
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) { [weak viewModel] in
                    viewModel?.appear(
                        reducedMotion: motionConfig.reducedMotion || reduceMotion
                    )
                }
            }
    }

    // MARK: - Programmatic Control

    /// Triggers the animate-in transition immediately.
    public func appear() { viewModel.appear() }

    /// Triggers the exit transition immediately.
    public func disappear() { viewModel.disappear() }

    /// Transitions to a named custom phase.
    public func setPhase(_ phase: AnimationPhase) { viewModel.transition(to: phase) }
}
