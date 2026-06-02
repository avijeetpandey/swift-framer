import SwiftUI

// MARK: - AnimatePresenceMode

/// Controls how entering and exiting elements interact.
public enum AnimatePresenceMode: Sendable {
    /// Both enter and exit animations play simultaneously.
    case sync
    /// Exit animation completes before enter animation begins.
    case wait
    /// Enter animation begins before exit animation starts.
    case popLayout
}
