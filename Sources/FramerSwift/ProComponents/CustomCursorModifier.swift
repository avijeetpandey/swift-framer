import SwiftUI

// MARK: - CustomCursorModifier

/// An iPadOS-focused modifier that intercepts the native pointer over a target
/// and drives a ``CursorState`` machine (`idle → active → magnetic`), applying a
/// magnetic "pull" emphasis while the pointer engages the view.
///
/// On pointer-capable devices the modifier:
/// - transitions `idle → magnetic` when the pointer enters the target,
/// - applies a configurable scale + lift while magnetic, and
/// - layers the system `hoverEffect` for native pointer morphing.
///
/// On touch-only devices `onHover` never fires, so the view renders in its
/// resting state with zero overhead — making this safe to apply universally.
///
/// `onContinuousHover` (which exposes pointer coordinates) is iOS 16+; to remain
/// iOS 15 compatible this modifier models magnetism as a hover-activated
/// emphasis rather than coordinate-tracked attraction.
public struct CustomCursorModifier: ViewModifier {

    private let magneticScale: CGFloat
    private let lift: CGFloat
    private let hoverEffect: HoverEffect
    private let transition: MotionTransition
    private let onStateChange: ((CursorState) -> Void)?

    @State private var state: CursorState = .idle

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The native pointer hover effects supported on iPadOS.
    public enum HoverEffect: Sendable, Equatable {
        case automatic
        case highlight
        case lift
        case none
    }

    /// Creates a custom-cursor modifier.
    ///
    /// - Parameters:
    ///   - magneticScale: Scale applied while magnetic. Defaults to `1.08`.
    ///   - lift: Upward offset (points) applied while magnetic. Defaults to `4`.
    ///   - hoverEffect: The native pointer effect. Defaults to `.automatic`.
    ///   - transition: The transition driving state changes.
    ///   - onStateChange: Callback fired whenever the cursor state changes.
    public init(
        magneticScale: CGFloat = 1.08,
        lift: CGFloat = 4,
        hoverEffect: HoverEffect = .automatic,
        transition: MotionTransition = MotionTransition(timing: .spring(.gentle)),
        onStateChange: ((CursorState) -> Void)? = nil
    ) {
        self.magneticScale = magneticScale
        self.lift = lift
        self.hoverEffect = hoverEffect
        self.transition = transition
        self.onStateChange = onStateChange
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation: Animation? = shouldAnimate ? transition.timing.swiftUIAnimation : nil
        let isMagnetic = state == .magnetic

        applyHoverEffect(to: content)
            .scaleEffect(isMagnetic ? magneticScale : 1.0)
            .offset(y: isMagnetic ? -lift : 0)
            .animation(animation, value: state)
            .onHover { hovering in
                let newState: CursorState = hovering ? .magnetic : .idle
                guard newState != state else { return }
                state = newState
                onStateChange?(newState)
            }
    }

    @ViewBuilder
    private func applyHoverEffect(to content: Content) -> some View {
        #if os(iOS)
        switch hoverEffect {
        case .automatic: content.hoverEffect(.automatic)
        case .highlight: content.hoverEffect(.highlight)
        case .lift:      content.hoverEffect(.lift)
        case .none:      content
        }
        #else
        content
        #endif
    }
}
