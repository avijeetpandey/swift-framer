import SwiftUI

// MARK: - MotionView Protocol

/// Base protocol for all FramerSwift-aware views. Provides the standard interface
/// for configuring initial, animate, exit states, and transitions. This is the
/// primary contract that bridges the declarative API to the animation engine.
public protocol MotionViewProtocol: View {
    associatedtype MotionBody: View

    /// The initial (hidden / pre-animation) state properties.
    var initial: [AnimatableProperty] { get }

    /// The animated (visible / target) state properties.
    var animate: [AnimatableProperty] { get }

    /// The exit (removal) state properties. Used with `AnimatePresence`.
    var exit: [AnimatableProperty] { get }

    /// The transition configuration for the animate state.
    var transition: MotionTransition { get }

    /// The exit transition configuration.
    var exitTransition: MotionTransition { get }

    /// Renders the view body with all motion properties applied.
    @ViewBuilder
    var motionBody: MotionBody { get }
}
