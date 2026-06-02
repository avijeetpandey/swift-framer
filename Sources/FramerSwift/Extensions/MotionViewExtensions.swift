import SwiftUI

// MARK: - View Extension: .motion(...)

public extension View {

    /// Attaches a full FramerSwift animation configuration to any view.
    ///
    /// - Parameters:
    ///   - initial: Properties in the initial (pre-animation) state.
    ///   - animate: Properties in the animated (visible) state.
    ///   - exit: Properties in the exit state. Falls back to `initial` if empty.
    ///   - transition: Timing and configuration for the animate transition.
    ///   - exitTransition: Timing and configuration for the exit transition.
    /// - Returns: The view with motion properties attached.
    func motion(
        initial: [AnimatableProperty] = [],
        animate: [AnimatableProperty] = [],
        exit: [AnimatableProperty] = [],
        transition: MotionTransition = .default,
        exitTransition: MotionTransition = .default
    ) -> some View {
        modifier(MotionModifier(
            initial: initial,
            animate: animate,
            exit: exit,
            transition: transition,
            exitTransition: exitTransition
        ))
    }

    /// Attaches a FramerSwift `VariantSet` to any view, driving animations
    /// from named phase states.
    func motion(variantSet: VariantSet) -> some View {
        modifier(MotionModifier(variantSet: variantSet))
    }

    /// Attaches an externally-owned `MotionViewModel` to drive animations.
    func motionState(_ viewModel: MotionViewModel) -> some View {
        modifier(MotionStateModifier(viewModel: viewModel))
    }
}
