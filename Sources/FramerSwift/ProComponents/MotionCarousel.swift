import SwiftUI

// MARK: - MotionCarousel

/// A draggable, snappable horizontal carousel that pages between equally sized
/// items with spring physics and velocity-aware snapping.
///
/// The carousel tracks the active page in a binding, follows the finger during a
/// drag (with elastic rubber-banding at the ends), and on release snaps to the
/// nearest page — or flicks to the next/previous page when drag velocity exceeds
/// a threshold, just like native paged scroll views but with fully tunable
/// spring feel.
///
/// ```swift
/// MotionCarousel(items: cards, selection: $index) { card in
///     CardView(card)
/// }
/// .frame(height: 220)
/// ```
public struct MotionCarousel<Item: Identifiable, ItemContent: View>: View {

    private let items: [Item]
    private let spacing: CGFloat
    private let sidePadding: CGFloat
    private let velocityThreshold: CGFloat
    private let transition: MotionTransition
    private let content: (Item) -> ItemContent

    @Binding private var selection: Int
    @GestureState private var dragTranslation: CGFloat = 0
    @State private var isDragging: Bool = false

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Creates a carousel.
    ///
    /// - Parameters:
    ///   - items: The pages to display.
    ///   - selection: A binding to the active page index.
    ///   - spacing: Gap between pages. Defaults to `16`.
    ///   - sidePadding: Inset revealing neighbor pages. Defaults to `32`.
    ///   - velocityThreshold: Drag velocity (pts/sec) above which a flick pages.
    ///     Defaults to `300`.
    ///   - transition: The snap transition. Defaults to a gentle spring.
    ///   - content: Builds the view for each page.
    public init(
        items: [Item],
        selection: Binding<Int>,
        spacing: CGFloat = 16,
        sidePadding: CGFloat = 32,
        velocityThreshold: CGFloat = 300,
        transition: MotionTransition = MotionTransition(timing: .spring(.gentle)),
        @ViewBuilder content: @escaping (Item) -> ItemContent
    ) {
        self.items = items
        self._selection = selection
        self.spacing = spacing
        self.sidePadding = sidePadding
        self.velocityThreshold = velocityThreshold
        self.transition = transition
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            let pageWidth = max(1, proxy.size.width - sidePadding * 2)
            let step = pageWidth + spacing
            let baseOffset = -CGFloat(selection) * step
            let elastic = rubberBanded(dragTranslation, pageWidth: pageWidth, step: step)

            HStack(spacing: spacing) {
                ForEach(items) { item in
                    content(item)
                        .frame(width: pageWidth)
                }
            }
            .padding(.horizontal, sidePadding)
            .offset(x: baseOffset + elastic)
            .animation(snapAnimation, value: selection)
            .animation(isDragging ? nil : snapAnimation, value: isDragging)
            .contentShape(Rectangle())
            .gesture(dragGesture(step: step))
        }
    }

    // MARK: Gesture

    private func dragGesture(step: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 8)
            .updating($dragTranslation) { value, state, _ in
                state = value.translation.width
            }
            .onChanged { _ in
                if !isDragging { isDragging = true }
            }
            .onEnded { value in
                isDragging = false
                let predicted = value.predictedEndTranslation.width
                let velocity = predicted - value.translation.width
                snap(translation: value.translation.width, velocity: velocity, step: step)
            }
    }

    private func snap(translation: CGFloat, velocity: CGFloat, step: CGFloat) {
        let calculator = CarouselSnapCalculator(velocityThreshold: velocityThreshold)
        selection = calculator.destinationIndex(
            currentIndex: selection,
            translation: translation,
            velocity: velocity,
            step: step,
            count: items.count
        )
    }

    // MARK: Helpers

    private var snapAnimation: Animation? {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        return shouldAnimate ? transition.timing.swiftUIAnimation : nil
    }

    /// Applies resistance when dragging past the first/last page.
    private func rubberBanded(_ translation: CGFloat, pageWidth: CGFloat, step: CGFloat) -> CGFloat {
        let atStart = selection == 0 && translation > 0
        let atEnd = selection == items.count - 1 && translation < 0
        guard atStart || atEnd else { return translation }
        // Logarithmic-style resistance for an elastic feel.
        let limit = pageWidth
        let ratio = abs(translation) / limit
        let resisted = limit * (1 - 1 / (ratio + 1))
        return translation < 0 ? -resisted : resisted
    }
}
