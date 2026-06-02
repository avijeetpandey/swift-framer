import Foundation

// MARK: - MotionTickerDirection

/// The travel direction of a `MotionTicker`.
public enum MotionTickerDirection: Sendable, Equatable {
    case leading   // Scrolls content toward the leading edge (right-to-left).
    case trailing  // Scrolls content toward the trailing edge (left-to-right).
}
