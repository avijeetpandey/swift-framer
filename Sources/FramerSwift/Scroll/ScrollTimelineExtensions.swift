import SwiftUI

// MARK: - Scroll Timeline View Extensions

public extension View {

    /// Links this view's scroll position to a normalized progress value,
    /// delivered through a callback.
    ///
    /// Define a coordinate space on the enclosing scroll container and pass its
    /// name here:
    ///
    /// ```swift
    /// ScrollView {
    ///     content
    ///         .motionScrollTimeline(in: "feed", distance: 400) { progress in
    ///             // react to progress.progress (0...1)
    ///         }
    /// }
    /// .coordinateSpace(name: "feed")
    /// ```
    ///
    /// - Parameters:
    ///   - coordinateSpace: Name of the enclosing scroll container's coordinate space.
    ///   - axis: The scroll axis to measure. Defaults to `.vertical`.
    ///   - start: The offset mapped to progress `0`. Defaults to `0`.
    ///   - distance: Travel distance over which progress goes `0 -> 1`.
    ///   - onChange: Callback invoked with each new progress snapshot.
    func motionScrollTimeline(
        in coordinateSpace: String,
        axis: MotionScrollAxis = .vertical,
        start: CGFloat = 0,
        distance: CGFloat = 1,
        onChange: @escaping (MotionScrollProgress) -> Void
    ) -> some View {
        modifier(
            ScrollTimelineModifier(
                coordinateSpace: coordinateSpace,
                axis: axis,
                start: start,
                distance: distance,
                progressValue: nil,
                onChange: onChange
            )
        )
    }

    /// Links this view's scroll position to a normalized progress value, written
    /// directly into a `MotionValue<Double>` for render-cycle-free propagation.
    ///
    /// ```swift
    /// let progress = MotionValue<Double>(0)
    /// // ...
    /// content
    ///     .motionScrollTimeline(in: "feed", distance: 400, progress: progress)
    /// ```
    ///
    /// - Parameters:
    ///   - coordinateSpace: Name of the enclosing scroll container's coordinate space.
    ///   - axis: The scroll axis to measure. Defaults to `.vertical`.
    ///   - start: The offset mapped to progress `0`. Defaults to `0`.
    ///   - distance: Travel distance over which progress goes `0 -> 1`.
    ///   - progress: A `MotionValue<Double>` that receives the `0...1` progress.
    func motionScrollTimeline(
        in coordinateSpace: String,
        axis: MotionScrollAxis = .vertical,
        start: CGFloat = 0,
        distance: CGFloat = 1,
        progress: MotionValue<Double>
    ) -> some View {
        modifier(
            ScrollTimelineModifier(
                coordinateSpace: coordinateSpace,
                axis: axis,
                start: start,
                distance: distance,
                progressValue: progress,
                onChange: nil
            )
        )
    }
}
