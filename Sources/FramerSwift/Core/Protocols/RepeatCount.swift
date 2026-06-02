import SwiftUI

// MARK: - RepeatCount

/// Specifies how many times an animation should repeat.
public enum RepeatCount: Sendable, Equatable {
    case none
    case times(Int)
    case infinity

    public var swiftUIRepeatCount: Int? {
        switch self {
        case .none: return nil
        case .times(let n): return n
        case .infinity: return nil
        }
    }

    public var isInfinite: Bool {
        if case .infinity = self { return true }
        return false
    }
}
