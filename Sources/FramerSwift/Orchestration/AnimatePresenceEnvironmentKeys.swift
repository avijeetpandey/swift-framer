import SwiftUI

// MARK: - EnvironmentKey for AnimatePresenceCoordinator

private struct AnimatePresenceCoordinatorKey: EnvironmentKey {
    static let defaultValue: AnimatePresenceCoordinator? = nil
}

public extension EnvironmentValues {
    var motionPresenceCoordinator: AnimatePresenceCoordinator? {
        get { self[AnimatePresenceCoordinatorKey.self] }
        set { self[AnimatePresenceCoordinatorKey.self] = newValue }
    }
}
