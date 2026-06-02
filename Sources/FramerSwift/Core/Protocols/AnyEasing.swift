import SwiftUI

// MARK: - AnyEasing (Type Eraser)

/// Type-erased wrapper for `EasingFunction`, enabling storage in enums and structs.
public struct AnyEasing: Sendable {
    let base: any EasingFunction

    public init(_ easing: any EasingFunction) {
        self.base = easing
    }
}
