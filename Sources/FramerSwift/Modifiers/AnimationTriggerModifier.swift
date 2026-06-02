import SwiftUI

// MARK: - AnimationTriggerModifier

/// Triggers a `MotionViewModel` phase transition when the wrapped view appears
/// or a binding changes.
public struct AnimationTriggerModifier: ViewModifier {

    @ObservedObject private var viewModel: MotionViewModel
    private let phase: AnimationPhase
    private let delay: Double

    public init(viewModel: MotionViewModel, phase: AnimationPhase, delay: Double = 0) {
        self.viewModel = viewModel
        self.phase = phase
        self.delay = delay
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                viewModel.transition(to: phase)
            }
        }
    }
}
