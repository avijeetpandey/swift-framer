import SwiftUI

// MARK: - MotionTicker

/// An infinitely scrolling, seamlessly looping horizontal ticker (marquee).
///
/// The consumer supplies their data **once** — `MotionTicker` handles the
/// continuous looping internally without requiring the caller to duplicate items.
/// It measures the natural width of a single pass, then drives a continuously
/// wrapping offset via `TimelineView(.animation)` so motion stays buttery even
/// while the rest of the UI updates. A second back-to-back pass fills the
/// trailing gap to guarantee a seam-free loop at any width.
///
/// ```swift
/// MotionTicker(items: headlines, speed: 60) { headline in
///     Text(headline).padding(.horizontal, 12)
/// }
/// .frame(height: 32)
/// ```
public struct MotionTicker<Item: Identifiable, ItemContent: View>: View {

    private let items: [Item]
    private let spacing: CGFloat
    private let speed: CGFloat
    private let direction: MotionTickerDirection
    private let content: (Item) -> ItemContent

    @State private var contentWidth: CGFloat = 0
    @State private var startDate: Date = Date()

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Creates a ticker.
    ///
    /// - Parameters:
    ///   - items: The data to scroll. Supplied once; looping is automatic.
    ///   - spacing: Spacing between items. Defaults to `16`.
    ///   - speed: Scroll speed in points per second. Defaults to `50`.
    ///   - direction: Travel direction. Defaults to `.leading`.
    ///   - content: Builds the view for each item.
    public init(
        items: [Item],
        spacing: CGFloat = 16,
        speed: CGFloat = 50,
        direction: MotionTickerDirection = .leading,
        @ViewBuilder content: @escaping (Item) -> ItemContent
    ) {
        self.items = items
        self.spacing = spacing
        self.speed = max(0, speed)
        self.direction = direction
        self.content = content
    }

    public var body: some View {
        TimelineView(.animation) { timeline in
            let offset = currentOffset(at: timeline.date)
            HStack(spacing: 0) {
                pass
                pass
            }
            .offset(x: offset)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
        }
        .background(widthReader)
    }

    // MARK: Single pass of items

    private var pass: some View {
        HStack(spacing: spacing) {
            ForEach(items) { item in
                content(item)
            }
        }
        .padding(.trailing, spacing)
    }

    // MARK: Offset

    private func currentOffset(at date: Date) -> CGFloat {
        guard contentWidth > 0, speed > 0 else { return 0 }
        if motionConfig.reducedMotion || reduceMotion { return 0 }

        let elapsed = CGFloat(date.timeIntervalSince(startDate))
        let distance = (elapsed * speed).truncatingRemainder(dividingBy: contentWidth)

        switch direction {
        case .leading:  return -distance
        case .trailing: return distance - contentWidth
        }
    }

    // MARK: Width measurement

    private var widthReader: some View {
        // Measure a single pass to know the wrap distance.
        HStack(spacing: spacing) {
            ForEach(items) { item in
                content(item)
            }
        }
        .padding(.trailing, spacing)
        .fixedSize()
        .hidden()
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: TickerWidthPreferenceKey.self, value: proxy.size.width)
            }
        )
        .onPreferenceChange(TickerWidthPreferenceKey.self) { width in
            contentWidth = width
        }
    }
}

// MARK: - TickerWidthPreferenceKey

private struct TickerWidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
