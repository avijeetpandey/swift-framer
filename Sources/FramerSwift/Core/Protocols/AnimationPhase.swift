import SwiftUI

// MARK: - AnimationPhase

/// Represents the discrete lifecycle phase of an animated element.
public enum AnimationPhase: Equatable, Hashable, Sendable {
    /// The element is not yet visible; initial state before any animation triggers.
    case initial
    /// The element is actively animating toward its target values.
    case animate
    /// The element has exited the view hierarchy and is playing its exit animation.
    case exit
    /// A named custom phase for variant-driven orchestration.
    case custom(String)

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .initial: hasher.combine(0)
        case .animate: hasher.combine(1)
        case .exit:    hasher.combine(2)
        case .custom(let s): hasher.combine(3); hasher.combine(s)
        }
    }

    public static func == (lhs: AnimationPhase, rhs: AnimationPhase) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial): return true
        case (.animate, .animate): return true
        case (.exit, .exit): return true
        case (.custom(let a), .custom(let b)): return a == b
        default: return false
        }
    }
}
