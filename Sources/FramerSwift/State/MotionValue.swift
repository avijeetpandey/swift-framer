import Foundation
import Combine

// MARK: - MotionValue

/// A high-performance, observable container for a single animatable value that
/// lives *outside* of SwiftUI's standard render cycle.
///
/// `MotionValue` is the Swift equivalent of Framer Motion's `useMotionValue`.
/// Updating the value via ``set(_:)`` notifies subscribers directly without
/// invalidating the SwiftUI view tree, making it ideal for high-frequency
/// signals such as scroll offsets, drag velocities, and pointer positions where
/// triggering a full `body` recomputation on every frame would be prohibitively
/// expensive.
///
/// Consumers can:
/// - **Track**: read the latest value synchronously via ``value``.
/// - **Subscribe**: receive change callbacks via ``onChange(_:)`` or the Combine ``publisher``.
/// - **Derive**: build dependent values via ``map(_:)`` that update automatically.
/// - **Inject**: bridge back into SwiftUI on demand using `MotionValueReader`.
///
/// The class is `@MainActor`-isolated to guarantee thread-safe mutation from the
/// UI thread, matching the threading model of the rest of the engine.
@MainActor
public final class MotionValue<Value> {

    // MARK: Stored State

    private var storage: Value
    private var observers: [UUID: (Value) -> Void] = [:]
    private let subject: CurrentValueSubject<Value, Never>

    /// Subscriptions retained by this value (used to keep derived chains alive).
    private var retainedSubscriptions: [MotionValueSubscription] = []

    // MARK: Initialization

    /// Creates a motion value seeded with an initial value.
    public init(_ initialValue: Value) {
        self.storage = initialValue
        self.subject = CurrentValueSubject(initialValue)
    }

    // MARK: Reading

    /// The latest value. Reading never triggers a SwiftUI invalidation.
    public var value: Value {
        storage
    }

    /// A Combine publisher emitting the current value immediately and every
    /// subsequent change. Useful for `.onReceive` bridging or operator chains.
    public var publisher: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }

    // MARK: Writing

    /// Updates the value and synchronously notifies all observers.
    ///
    /// This does **not** invalidate any SwiftUI view unless a consumer has
    /// explicitly opted into re-rendering (e.g. via `MotionValueReader`).
    public func set(_ newValue: Value) {
        storage = newValue
        subject.send(newValue)
        // Snapshot to allow observers to mutate the set during iteration.
        for handler in observers.values {
            handler(newValue)
        }
    }

    /// Mutates the value in place using a closure, then notifies observers.
    public func update(_ transform: (inout Value) -> Void) {
        var copy = storage
        transform(&copy)
        set(copy)
    }

    // MARK: Subscribing

    /// Registers a change handler invoked on every subsequent ``set(_:)``.
    ///
    /// - Parameter handler: Called with the new value after each change.
    /// - Returns: A subscription token. Retain it to keep the subscription
    ///   alive; release or ``MotionValueSubscription/cancel()`` it to stop.
    @discardableResult
    public func onChange(_ handler: @escaping (Value) -> Void) -> MotionValueSubscription {
        let id = UUID()
        observers[id] = handler
        return MotionValueSubscription { [weak self] in
            self?.observers.removeValue(forKey: id)
        }
    }

    // MARK: Deriving

    /// Creates a new `MotionValue` whose value is derived from this one.
    ///
    /// The derived value updates automatically whenever the source changes.
    /// The returned value retains the internal subscription, so its lifetime is
    /// bound to the lifetime of the returned object (no manual bookkeeping).
    ///
    /// - Parameter transform: Maps a source value to a derived value.
    /// - Returns: A live, auto-updating derived `MotionValue`.
    public func map<Derived>(_ transform: @escaping (Value) -> Derived) -> MotionValue<Derived> {
        let derived = MotionValue<Derived>(transform(storage))
        let subscription = onChange { [weak derived] newValue in
            derived?.set(transform(newValue))
        }
        derived.retain(subscription)
        return derived
    }

    // MARK: Lifetime Helpers

    /// Retains a subscription for the lifetime of this value.
    func retain(_ subscription: MotionValueSubscription) {
        retainedSubscriptions.append(subscription)
    }
}

// MARK: - Numeric Conveniences

public extension MotionValue where Value == Double {

    /// Creates a derived `MotionValue` that remaps this value from an input
    /// range to an output range, mirroring Framer Motion's `useTransform`.
    ///
    /// - Parameters:
    ///   - inputRange: The source range `[low, high]`.
    ///   - outputRange: The destination range `[low, high]`.
    ///   - clamp: When `true`, output is clamped to `outputRange`.
    /// - Returns: A live derived value following the mapping.
    func transform(
        inputRange: ClosedRange<Double>,
        outputRange: ClosedRange<Double>,
        clamp: Bool = true
    ) -> MotionValue<Double> {
        map { input in
            ValueInterpolator.mapRange(
                input,
                inLow: inputRange.lowerBound,
                inHigh: inputRange.upperBound,
                outLow: outputRange.lowerBound,
                outHigh: outputRange.upperBound,
                clamp: clamp
            )
        }
    }
}
