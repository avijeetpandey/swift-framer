import SwiftUI

// MARK: - GestureMotionProtocol

/// Protocol for views that expose gesture-driven animation states.
public protocol GestureMotionProtocol: View {
    /// Properties applied while a tap gesture is active.
    var whileTap: [AnimatableProperty] { get set }

    /// Properties applied while a drag gesture is active.
    var whileDrag: [AnimatableProperty] { get set }

    /// Properties applied while the pointer hovers (macOS / iPadOS pointer).
    var whileHover: [AnimatableProperty] { get set }

    /// The transition used for gesture state changes.
    var gestureTransition: MotionTransition { get set }
}
