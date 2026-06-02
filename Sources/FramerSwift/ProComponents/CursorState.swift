import Foundation

// MARK: - CursorState

/// The lifecycle states of a pointer interacting with a `customCursor` target on
/// iPadOS / pointer-capable devices.
public enum CursorState: Sendable, Equatable {

    /// No pointer is interacting with the target.
    case idle

    /// The pointer is hovering the target's region (engaged but not pulled).
    case active

    /// The pointer is within the target and "magnetically" attracted to it,
    /// producing the emphasized lift/scale effect.
    case magnetic
}
