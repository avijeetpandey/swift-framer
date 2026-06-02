import SwiftUI
import FramerSwift

// MARK: - Scroll & Layout Demo
// Demonstrates motionScrollTimeline (scroll-linked progress) and motionLayout
// (fluid layout animation between two states).

struct ScrollLayoutDemo: View {
    @State private var headerProgress: Double = 0
    @Namespace private var layoutNS
    @State private var expanded = false

    var body: some View {
        VStack(spacing: 24) {
            SectionHeader(
                title: "Scroll & Layout",
                subtitle: "motionScrollTimeline · motionLayout"
            )

            // Scroll-linked progress bar
            VStack(alignment: .leading, spacing: 8) {
                Text("Scroll Progress")
                    .font(.subheadline.weight(.semibold))
                ProgressView(value: headerProgress)
                    .tint(.purple)
                Text("\(Int(headerProgress * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.purple.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))

            // Layout animation card — taps morph between two layouts
            Text("Tap the card to animate its layout")
                .font(.caption)
                .foregroundStyle(.secondary)

            ZStack {
                if expanded {
                    expandedCard
                        .motionLayout(id: "card", in: layoutNS)
                } else {
                    collapsedCard
                        .motionLayout(id: "card", in: layoutNS)
                }
            }
            .frame(maxWidth: .infinity, alignment: expanded ? .center : .leading)
            .contentShape(Rectangle())
            .onTapGesture { expanded.toggle() }

            // Scroll-linked content
            ForEach(0..<8) { i in
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hue: Double(i) / 8.0, saturation: 0.5, brightness: 0.95))
                    .frame(height: 70)
                    .overlay(
                        Text("Scroll item \(i + 1)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    )
            }
        }
        .padding()
        .motionScrollTimeline(in: "appScroll", start: 180, distance: 500) { snapshot in
            headerProgress = snapshot.progress
        }
    }

    private var collapsedCard: some View {
        HStack {
            Image(systemName: "rectangle.compress.vertical")
                .font(.title2)
                .foregroundStyle(.white)
            Text("Collapsed")
                .font(.headline)
                .foregroundStyle(.white)
        }
        .padding()
        .frame(width: 180, height: 70)
        .background(
            LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing),
            in: RoundedRectangle(cornerRadius: 16)
        )
    }

    private var expandedCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "rectangle.expand.vertical")
                .font(.largeTitle)
                .foregroundStyle(.white)
            Text("Expanded")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("matchedGeometry-driven layout")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(
            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 24)
        )
    }
}
