import Foundation
import Combine

// MARK: - MotionValueSubscription

/// A cancellable token returned when subscribing to a `MotionValue`.
///
/// Retaining this token keeps the subscription alive. Releasing it (or calling
/// ``cancel()``) removes the observer from its owning `MotionValue`, preventing
/// retain cycles and dangling closures.
public final class MotionValueSubscription: Cancellable {

    private var onCancel: (() -> Void)?

    init(onCancel: @escaping () -> Void) {
        self.onCancel = onCancel
    }

    /// Removes the observer from its owning `MotionValue`.
    /// Safe to call multiple times; subsequent calls are no-ops.
    public func cancel() {
        onCancel?()
        onCancel = nil
    }

    deinit {
        onCancel?()
    }
}
