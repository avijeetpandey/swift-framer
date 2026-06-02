import SwiftUI

// MARK: - Environment Keys for Stagger

private struct MotionStaggerDelayKey: EnvironmentKey {
    static let defaultValue: Double = 0.05
}

private struct MotionDelayChildrenKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

private struct MotionExtraDelayKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

public extension EnvironmentValues {
    var motionStaggerDelay: Double {
        get { self[MotionStaggerDelayKey.self] }
        set { self[MotionStaggerDelayKey.self] = newValue }
    }

    var motionDelayChildren: Double {
        get { self[MotionDelayChildrenKey.self] }
        set { self[MotionDelayChildrenKey.self] = newValue }
    }

    var motionExtraDelay: Double {
        get { self[MotionExtraDelayKey.self] }
        set { self[MotionExtraDelayKey.self] = newValue }
    }
}
