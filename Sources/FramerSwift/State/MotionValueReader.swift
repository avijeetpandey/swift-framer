import SwiftUI

// MARK: - MotionValueReader

/// A SwiftUI view that subscribes to a `MotionValue` and rebuilds its content
/// whenever the value changes.
///
/// `MotionValue` deliberately lives outside the render cycle for performance.
/// `MotionValueReader` is the explicit, opt-in bridge back *into* SwiftUI: use
/// it only around the small subtree that must visually react to the value,
/// keeping expensive parent views from re-rendering on every frame.
///
/// ```swift
/// MotionValueReader(scrollProgress) { progress in
///     ProgressBar(value: progress)
/// }
/// ```
public struct MotionValueReader<Value, Content: View>: View {

    private let motionValue: MotionValue<Value>
    private let content: (Value) -> Content

    @State private var current: Value
    @State private var subscription: MotionValueSubscription?

    /// Creates a reader bound to `motionValue`.
    ///
    /// - Parameters:
    ///   - motionValue: The value to observe.
    ///   - content: Builds content from the latest value.
    public init(
        _ motionValue: MotionValue<Value>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.motionValue = motionValue
        self.content = content
        self._current = State(initialValue: motionValue.value)
    }

    public var body: some View {
        content(current)
            .onAppear {
                current = motionValue.value
                subscription = motionValue.onChange { newValue in
                    current = newValue
                }
            }
            .onDisappear {
                subscription?.cancel()
                subscription = nil
            }
    }
}
