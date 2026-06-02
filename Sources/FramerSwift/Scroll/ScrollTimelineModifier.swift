import SwiftUI

// MARK: - ScrollTimelineModifier

/// A `ViewModifier` that links the scroll position of its content to a
/// normalized progress value, enabling scroll-driven animations.
///
/// The modifier installs a zero-cost `GeometryReader` background that reports the
/// content's leading edge within a named coordinate space (typically the
/// enclosing `ScrollView`'s space). The raw offset is normalized across a
/// configurable travel window `[start, start - distance]` into `0...1` and
/// emitted both through the `onChange` callback and, optionally, written into a
/// `MotionValue<Double>` for render-cycle-free propagation.
///
/// Because the work is performed entirely through SwiftUI's preference and
/// geometry systems, updates are coalesced and delivered off the critical
/// layout path — no timers, no polling.
public struct ScrollTimelineModifier: ViewModifier {

    private let coordinateSpace: String
    private let axis: MotionScrollAxis
    private let start: CGFloat
    private let distance: CGFloat
    private let progressValue: MotionValue<Double>?
    private let onChange: ((MotionScrollProgress) -> Void)?

    /// Creates a scroll-timeline modifier.
    ///
    /// - Parameters:
    ///   - coordinateSpace: The name of the `.coordinateSpace` defined on the
    ///     enclosing scroll container.
    ///   - axis: The scroll axis to measure. Defaults to `.vertical`.
    ///   - start: The offset (in the coordinate space) mapped to progress `0`.
    ///   - distance: The travel distance over which progress goes `0 -> 1`.
    ///     Must be non-zero; values are clamped to a minimum magnitude.
    ///   - progressValue: An optional `MotionValue<Double>` to receive progress.
    ///   - onChange: An optional callback invoked with each new progress snapshot.
    public init(
        coordinateSpace: String,
        axis: MotionScrollAxis = .vertical,
        start: CGFloat = 0,
        distance: CGFloat = 1,
        progressValue: MotionValue<Double>? = nil,
        onChange: ((MotionScrollProgress) -> Void)? = nil
    ) {
        self.coordinateSpace = coordinateSpace
        self.axis = axis
        self.start = start
        self.distance = distance
        self.progressValue = progressValue
        self.onChange = onChange
    }

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: leadingEdge(of: proxy)
                        )
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                emit(offset: offset)
            }
    }

    // MARK: Geometry

    private func leadingEdge(of proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        switch axis {
        case .vertical:   return frame.minY
        case .horizontal: return frame.minX
        }
    }

    // MARK: Emission

    private func emit(offset: CGFloat) {
        let progress = MotionScrollProgress.normalizedProgress(
            offset: offset,
            start: start,
            distance: distance
        )

        let snapshot = MotionScrollProgress(
            offset: offset,
            progress: progress,
            axis: axis
        )

        progressValue?.set(progress)
        onChange?(snapshot)
    }
}
