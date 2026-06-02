import SwiftUI

// MARK: - MotionStateModifier

/// A ViewModifier that drives animations from an externally-owned `MotionViewModel`.
/// Use this when you need to control animation state from outside the view hierarchy.
public struct MotionStateModifier: ViewModifier {

    @ObservedObject private var viewModel: MotionViewModel
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(viewModel: MotionViewModel) {
        self.viewModel = viewModel
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation = shouldAnimate
            ? viewModel.animation(for: viewModel.currentPhase)
            : nil

        PropertyApplicator.apply(viewModel.resolvedProperties, to: content)
            .animation(animation, value: viewModel.resolvedProperties.map { $0.doubleValue })
    }
}
