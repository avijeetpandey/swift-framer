import SwiftUI
import FramerSwift

// MARK: - Draggable Cards Demo
// Three cards: free drag, horizontal-only, vertical-only.
// All show scale + shadow change while dragging.

struct DraggableCardsDemo: View {
    var body: some View {
        VStack(spacing: 20) {
            SectionHeader(
                title: "Drag Interactions",
                subtitle: "whileDrag with axis constraints"
            )

            DraggableCard(
                label: "Free Drag 🚀",
                sublabel: "Move in any direction",
                gradient: [.blue, .cyan],
                axis: .free,
                index: 0
            )
            DraggableCard(
                label: "Horizontal Only ↔️",
                sublabel: "axis: .horizontal",
                gradient: [.purple, .pink],
                axis: .horizontal,
                index: 1
            )
            DraggableCard(
                label: "Vertical Only ↕️",
                sublabel: "axis: .vertical",
                gradient: [.orange, .red],
                axis: .vertical,
                index: 2
            )

            // whileHover card (pointer devices)
            SectionHeader(
                title: "Hover Effect",
                subtitle: "whileHover (pointer devices / macOS)"
            )
            .padding(.top, 8)

            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.green, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 100)
                .overlay(
                    Text("Hover over me 🖱️")
                        .font(.headline)
                        .foregroundStyle(.white)
                )
                .shadow(color: .green.opacity(0.3), radius: 12, y: 6)
                .motion(
                    initial: [.opacity(0), .y(20)],
                    animate: [.opacity(1), .y(0)],
                    transition: MotionTransition(timing: .spring(.gentle), delay: 0.3)
                )
                .whileHover(
                    [.scale(1.04), .brightness(0.06)],
                    inactive: [.scale(1.0), .brightness(0)],
                    transition: MotionTransition(timing: .tween(duration: 0.18))
                )
        }
        .padding()
    }
}

struct DraggableCard: View {
    let label: String
    let sublabel: String
    let gradient: [Color]
    let axis: WhileDragModifier.DragAxis
    let index: Int
    @State private var lastVelocity: String = ""

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            VStack(spacing: 4) {
                Text(label)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(sublabel)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                if !lastVelocity.isEmpty {
                    Text(lastVelocity)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.top, 2)
                }
            }
        }
        .frame(height: 110)
        .shadow(color: gradient[0].opacity(0.4), radius: 14, y: 7)
        .motion(
            initial: [.opacity(0), .y(30), .scale(0.92)],
            animate: [.opacity(1), .y(0), .scale(1)],
            transition: MotionTransition(
                timing: .spring(.gentle),
                delay: Double(index) * 0.1
            )
        )
        .whileDrag(
            [.scale(1.05), .opacity(0.92)],
            inactive: [.scale(1.0), .opacity(1.0)],
            axis: axis,
            transition: MotionTransition(timing: .spring(SpringConfiguration.stiff)),
            applyTranslation: true,
            onDragEnd: { translation, velocity in
                let speed = Int(hypot(velocity.width, velocity.height))
                lastVelocity = "velocity: \(speed)pt/s"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { lastVelocity = "" }
            }
        )
    }
}
