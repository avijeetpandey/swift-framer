import SwiftUI
import FramerSwift

// MARK: - Stagger List Demo
// Every row animates in staggered on appear, and shows a spring press effect on tap.

struct StaggerListDemo: View {
    @State private var lastTapped: String = ""

    let items: [(icon: String, title: String, subtitle: String, color: Color)] = [
        ("wand.and.stars",           "Fluid Springs",    "Mass · Stiffness · Damping",    .purple),
        ("arrow.left.arrow.right",   "Stagger",          "Orchestrated entry delays",      .blue),
        ("eye",                      "AnimatePresence",  "Exit animations before removal", .pink),
        ("hand.tap",                 "Gesture States",   "whileTap · whileHover · drag",   .orange),
        ("repeat",                   "Loop Animations",  "Mirror · loop · reverse",        .green),
        ("bezierpath",               "Custom Easings",   "Cubic Bézier control points",    .teal),
        ("slider.horizontal.3",      "Keyframes",        "Multi-stop property sequences",  .indigo),
        ("arrow.up.arrow.down",      "Variants",         "Named phase orchestration",      .red),
    ]

    var body: some View {
        VStack(spacing: 0) {
            if !lastTapped.isEmpty {
                Text("Tapped: \(lastTapped)")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color.green, in: Capsule())
                    .motion(
                        initial: [.opacity(0), .scale(0.8)],
                        animate: [.opacity(1), .scale(1)],
                        transition: .spring(.bouncy)
                    )
                    .padding(.bottom, 8)
                    .id(lastTapped)
            }

            VStack(spacing: 10) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    FeatureRow(item: item, index: index) {
                        lastTapped = item.title
                        // Reset after 1.5s
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            if lastTapped == item.title { lastTapped = "" }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct FeatureRow: View {
    let item: (icon: String, title: String, subtitle: String, color: Color)
    let index: Int
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: item.icon)
                    .foregroundStyle(item.color)
                    .font(.system(size: 18, weight: .medium))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .font(.caption)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
        .motion(
            initial: [.opacity(0), .x(-28)],
            animate: [.opacity(1), .x(0)],
            transition: MotionTransition(
                timing: .spring(.gentle),
                delay: Double(index) * 0.07
            )
        )
        .whileTap(
            [.scale(0.96), .opacity(0.75)],
            inactive: [.scale(1.0), .opacity(1.0)],
            transition: MotionTransition(timing: .spring(SpringConfiguration.stiff)),
            action: onTap
        )
    }
}
