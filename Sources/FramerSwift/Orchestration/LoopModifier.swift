import SwiftUI

// MARK: - LoopModifier

/// Repeats a transition back and forth (yoyo) or in a single direction
/// indefinitely. Equivalent to Framer Motion's `repeat: Infinity` + `repeatType`.
public struct LoopModifier: ViewModifier {

    public enum LoopType: Sendable {
        /// Plays the animation forward, then instantly resets and replays.
        case loop
        /// Plays forward, then reverses (mirrors), creating a yoyo/ping-pong effect.
        case mirror
        /// Plays forward each time without reversing.
        case reverse
    }

    private let initial: [AnimatableProperty]
    private let animate: [AnimatableProperty]
    private let transition: MotionTransition
    private let loopType: LoopType

    @StateObject private var viewModel: MotionViewModel
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        initial: [AnimatableProperty],
        animate: [AnimatableProperty],
        transition: MotionTransition = .default,
        loopType: LoopType = .mirror
    ) {
        self.initial = initial
        self.animate = animate
        self.loopType = loopType
        let repeatTransition = MotionTransition(
            timing: transition.timing,
            delay: transition.delay,
            repeatCount: .infinity,
            repeatMirror: loopType == .mirror,
            staggerChildren: transition.staggerChildren,
            delayChildren: transition.delayChildren
        )
        self.transition = repeatTransition
        _viewModel = StateObject(wrappedValue: MotionViewModel(
            initial: initial,
            animate: animate,
            exit: [],
            transition: repeatTransition
        ))
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let anim = shouldAnimate ? viewModel.animation(for: .animate) : nil

        PropertyApplicator.apply(viewModel.resolvedProperties, to: content)
            .animation(anim, value: viewModel.resolvedProperties.map { $0.doubleValue })
            .onAppear {
                viewModel.appear()
            }
    }
}

// MARK: - View Extension for Loop

public extension View {
    /// Applies a looping animation between `initial` and `animate` states.
    func motionLoop(
        initial: [AnimatableProperty],
        animate: [AnimatableProperty],
        transition: MotionTransition = .default,
        type: LoopModifier.LoopType = .mirror
    ) -> some View {
        modifier(LoopModifier(
            initial: initial,
            animate: animate,
            transition: transition,
            loopType: type
        ))
    }
}
