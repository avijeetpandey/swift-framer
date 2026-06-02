import SwiftUI

// MARK: - MotionStagger Environment Keys

private struct MotionStaggerIndexKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

private struct MotionStaggerTotalKey: EnvironmentKey {
    static let defaultValue: Int = 1
}

public extension EnvironmentValues {
    /// The index of this view within a staggered container (0-based).
    var motionStaggerIndex: Int {
        get { self[MotionStaggerIndexKey.self] }
        set { self[MotionStaggerIndexKey.self] = newValue }
    }

    /// Total number of staggered children in the parent container.
    var motionStaggerTotal: Int {
        get { self[MotionStaggerTotalKey.self] }
        set { self[MotionStaggerTotalKey.self] = newValue }
    }
}
