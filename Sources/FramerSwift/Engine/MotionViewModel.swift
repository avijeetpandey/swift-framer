import SwiftUI
import Combine

// MARK: - MotionViewModel

/// The central state machine and observable engine for a single `MotionView`.
/// Manages phase transitions, interpolation, and publishes property changes
/// to drive SwiftUI re-renders.
@MainActor
public final class MotionViewModel: ObservableObject {

    // MARK: Published State

    /// Current phase driving which properties are active.
    @Published public private(set) var currentPhase: AnimationPhase = .initial

    /// The resolved, current-frame animatable properties.
    @Published public private(set) var resolvedProperties: [AnimatableProperty] = []

    // MARK: Configuration

    private let variantSet: VariantSet
    private let initialProperties: [AnimatableProperty]
    private let animateProperties: [AnimatableProperty]
    private let exitProperties: [AnimatableProperty]
    private let transition: MotionTransition
    private let exitTransition: MotionTransition

    // MARK: Keyframe support
    private var keyframeTimer: Timer?
    private var keyframeStartTime: Date?
    private var keyframeSequence: KeyframeSequence?

    // MARK: Exit Completion

    /// Called when the exit animation has fully completed.
    var onExitComplete: (() -> Void)?

    // MARK: Initializers

    public init(
        initial: [AnimatableProperty],
        animate: [AnimatableProperty],
        exit: [AnimatableProperty] = [],
        transition: MotionTransition = .default,
        exitTransition: MotionTransition = .default
    ) {
        self.initialProperties = initial
        self.animateProperties = animate
        self.exitProperties = exit.isEmpty ? initial : exit
        self.transition = transition
        self.exitTransition = exitTransition
        self.variantSet = VariantSet(variants: [])
        self.resolvedProperties = initial
    }

    public init(variantSet: VariantSet) {
        self.variantSet = variantSet
        self.initialProperties = variantSet.properties(for: .initial)
        self.animateProperties = variantSet.properties(for: .animate)
        self.exitProperties = variantSet.properties(for: .exit)
        self.transition = variantSet.transition(for: .animate)
        self.exitTransition = variantSet.transition(for: .exit)
        self.resolvedProperties = self.initialProperties
    }

    // MARK: - Phase Transitions

    /// Triggers the animate-in transition.
    public func appear(reducedMotion: Bool = false) {
        guard currentPhase != .animate else { return }
        currentPhase = .animate

        if case .keyframes(let entries) = transition.timing {
            startKeyframeAnimation(
                entries: entries,
                from: initialProperties,
                delay: transition.delay
            )
        } else {
            resolvedProperties = animateProperties
        }
    }

    /// Triggers the exit transition, calling `onExitComplete` when done.
    public func disappear(reducedMotion: Bool = false) {
        guard currentPhase != .exit else { return }
        currentPhase = .exit

        if case .keyframes(let entries) = exitTransition.timing {
            startKeyframeAnimation(
                entries: entries,
                from: animateProperties,
                delay: exitTransition.delay,
                completion: { [weak self] in
                    self?.onExitComplete?()
                }
            )
        } else {
            resolvedProperties = exitProperties
        }
    }

    /// Resets to the initial state without animation.
    public func reset() {
        keyframeTimer?.invalidate()
        keyframeTimer = nil
        currentPhase = .initial
        resolvedProperties = initialProperties
    }

    /// Transitions to a named custom variant phase.
    public func transition(to phase: AnimationPhase) {
        guard currentPhase != phase else { return }
        currentPhase = phase
        let properties = variantSet.properties(for: phase)
        if !properties.isEmpty {
            resolvedProperties = properties
        }
    }

    // MARK: - Keyframe Animation

    private func startKeyframeAnimation(
        entries: [KeyframeEntry],
        from: [AnimatableProperty],
        delay: Double,
        completion: (() -> Void)? = nil
    ) {
        keyframeTimer?.invalidate()
        let sequence = KeyframeSequence(entries: entries)
        keyframeSequence = sequence
        let totalDuration = sequence.entries.last?.time ?? 0.3

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else { return }
            self.keyframeStartTime = Date()
            self.keyframeTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 60.0,
                repeats: true
            ) { [weak self] timer in
                guard let self, let start = self.keyframeStartTime else { return }
                let elapsed = Date().timeIntervalSince(start)
                let t = min(elapsed / totalDuration, 1.0)
                self.resolvedProperties = sequence.evaluate(at: t)
                if t >= 1.0 {
                    timer.invalidate()
                    self.keyframeTimer = nil
                    completion?()
                }
            }
            RunLoop.main.add(self.keyframeTimer!, forMode: .common)
        }
    }

    // MARK: - SwiftUI Animation

    /// Returns the SwiftUI `Animation` to use for the current transition,
    /// applying speed multiplier and delay.
    public func animation(for phase: AnimationPhase, speedMultiplier: Double = 1.0) -> Animation? {
        let config = phase == .exit ? exitTransition : transition
        var animation = config.timing.swiftUIAnimation

        if config.delay > 0 {
            animation = animation.delay(config.delay)
        }

        switch config.repeatCount {
        case .infinity:
            animation = animation.repeatForever(autoreverses: config.repeatMirror)
        case .times(let n) where n > 0:
            animation = animation.repeatCount(n, autoreverses: config.repeatMirror)
        default:
            break
        }

        return animation
    }

    deinit {
        keyframeTimer?.invalidate()
    }
}
