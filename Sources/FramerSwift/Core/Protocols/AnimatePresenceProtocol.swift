import SwiftUI

// MARK: - AnimatePresenceProtocol

/// Protocol for containers that manage animated insertion and removal
/// of child views from the view hierarchy.
public protocol AnimatePresenceProtocol: View {
    associatedtype PresenceContent: View

    /// Whether the managed content is currently present.
    var isPresent: Bool { get }

    /// The wrapped content to show/hide with animation.
    @ViewBuilder
    var presenceContent: PresenceContent { get }
}
