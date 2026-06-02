import SwiftUI
import FramerSwift

// MARK: - Text Effects Demo
// Demonstrates AnimateNumber, Typewriter, and ScrambleText.

struct TextEffectsDemo: View {
    @State private var counter: Double = 1240
    @State private var price: Double = 19.99
    @State private var scrambleSeed = 0

    var body: some View {
        VStack(spacing: 24) {
            SectionHeader(
                title: "Text Effects",
                subtitle: "AnimateNumber · Typewriter · ScrambleText"
            )

            // AnimateNumber — counter
            VStack(spacing: 12) {
                Text("Animated Counter")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                AnimateNumber(
                    value: counter,
                    font: .system(size: 44, weight: .bold, design: .rounded),
                    foregroundColor: .blue,
                    timing: .spring(.gentle)
                )

                AnimateNumber(
                    value: price,
                    font: .title3.weight(.semibold),
                    foregroundColor: .green,
                    timing: .tween(duration: 0.5),
                    format: { String(format: "$%.2f", $0) }
                )

                HStack(spacing: 12) {
                    Button("−250") { counter = max(0, counter - 250); price = max(0, price - 5) }
                        .whileTap([.scale(0.94)], inactive: [.scale(1)])
                    Button("+250") { counter += 250; price += 5 }
                        .whileTap([.scale(0.94)], inactive: [.scale(1)])
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.blue.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))

            // Typewriter
            VStack(alignment: .leading, spacing: 10) {
                Text("Typewriter")
                    .font(.subheadline.weight(.semibold))
                Typewriter(
                    "framer-swift makes motion effortless.",
                    charactersPerSecond: 18,
                    font: .system(.body, design: .monospaced),
                    foregroundColor: .primary
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))

            // ScrambleText
            VStack(alignment: .leading, spacing: 10) {
                Text("Scramble Text")
                    .font(.subheadline.weight(.semibold))
                ScrambleText(
                    "DECRYPTED",
                    duration: 1.4,
                    font: .system(size: 28, weight: .bold, design: .monospaced),
                    foregroundColor: .pink,
                    engine: TextScrambleEngine(seed: UInt64(scrambleSeed) &+ 1)
                )
                .id(scrambleSeed)

                Button("Re-scramble") { scrambleSeed += 1 }
                    .buttonStyle(.bordered)
                    .whileTap([.scale(0.95)], inactive: [.scale(1)])
            }
            .padding()
            .background(.pink.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }
}
