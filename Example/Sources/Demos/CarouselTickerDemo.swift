import SwiftUI
import FramerSwift

// MARK: - Carousel & Ticker Demo
// Demonstrates MotionCarousel, MotionTicker, and customCursor.

struct CarouselTickerDemo: View {
    @State private var page = 0

    private let cards: [CarouselCard] = [
        CarouselCard(title: "Springs",   icon: "wand.and.stars",       colors: [.purple, .indigo]),
        CarouselCard(title: "Gestures",  icon: "hand.draw",            colors: [.blue, .cyan]),
        CarouselCard(title: "Layout",    icon: "rectangle.3.group",    colors: [.orange, .red]),
        CarouselCard(title: "Text",      icon: "textformat",           colors: [.green, .teal]),
        CarouselCard(title: "Scroll",    icon: "arrow.up.arrow.down",  colors: [.pink, .purple]),
    ]

    private let tickerItems: [TickerItem] = [
        "Springs", "Tweens", "Keyframes", "AnimatePresence", "Stagger",
        "Drag", "Hover", "Loop", "Scroll", "Layout", "Carousel"
    ].enumerated().map { TickerItem(id: $0.offset, text: $0.element) }

    var body: some View {
        VStack(spacing: 24) {
            SectionHeader(
                title: "Carousels & Tickers",
                subtitle: "MotionCarousel · MotionTicker · customCursor"
            )

            // Carousel
            MotionCarousel(items: cards, selection: $page) { card in
                VStack(spacing: 12) {
                    Image(systemName: card.icon)
                        .font(.system(size: 44, weight: .semibold))
                    Text(card.title)
                        .font(.title2.bold())
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .background(
                    LinearGradient(colors: card.colors, startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 24)
                )
                .customCursor(magneticScale: 1.04)
            }
            .frame(height: 200)

            // Page indicators
            HStack(spacing: 8) {
                ForEach(cards.indices, id: \.self) { i in
                    Circle()
                        .fill(i == page ? Color.primary : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .motion(
                            initial: [.scale(1)],
                            animate: [.scale(i == page ? 1.3 : 1.0)],
                            transition: .spring(.bouncy)
                        )
                        .id(page)
                }
            }

            Text("Drag the card · flick to page")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Ticker
            VStack(alignment: .leading, spacing: 10) {
                Text("Infinite Ticker")
                    .font(.subheadline.weight(.semibold))

                MotionTicker(items: tickerItems, spacing: 12, speed: 55) { item in
                    Text(item.text)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.blue.opacity(0.15), in: Capsule())
                        .foregroundStyle(.blue)
                }
                .frame(height: 40)

                MotionTicker(items: tickerItems, spacing: 12, speed: 40, direction: .trailing) { item in
                    Text(item.text)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.purple.opacity(0.15), in: Capsule())
                        .foregroundStyle(.purple)
                }
                .frame(height: 40)
            }
            .padding()
            .background(.secondary.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }
}

// MARK: - Models

struct CarouselCard: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let colors: [Color]
}

struct TickerItem: Identifiable {
    let id: Int
    let text: String
}
