import SwiftUI
import FramerSwift

// MARK: - Modal Demo
// Demonstrates AnimatePresence: content animates in/out of the hierarchy.

struct ModalDemo: View {
    @Binding var showModal: Bool
    @State private var showToast = false

    var body: some View {
        VStack(spacing: 20) {
            SectionHeader(
                title: "AnimatePresence",
                subtitle: "Animate views out before removing them from the hierarchy"
            )

            // Conditional view with AnimatePresence
            AnimatePresence(isPresent: showToast) {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Dismissed with exit animation!")
                        .font(.subheadline.weight(.medium))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                .motionPresence(
                    initial: [.opacity(0), .scale(0.9), .y(-10)],
                    animate: [.opacity(1), .scale(1),   .y(0)],
                    exit:    [.opacity(0), .scale(0.9), .y(-10)],
                    transition:     MotionTransition(timing: .spring(.bouncy)),
                    exitTransition: MotionTransition(timing: .tween(duration: 0.2))
                )
            }

            VStack(spacing: 12) {
                // Show toast button
                Button {
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showToast = false
                    }
                } label: {
                    Label("Show Toast (auto-dismiss)", systemImage: "bell.fill")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.green, in: RoundedRectangle(cornerRadius: 14))
                }
                .whileTap(
                    [.scale(0.96)],
                    inactive: [.scale(1)]
                )
                .motion(
                    initial: [.opacity(0), .y(16)],
                    animate: [.opacity(1), .y(0)],
                    transition: MotionTransition(timing: .spring(.gentle), delay: 0.15)
                )

                // Show full modal button
                Button {
                    showModal = true
                } label: {
                    Label("Open Full Modal", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 14))
                }
                .whileTap(
                    [.scale(0.96)],
                    inactive: [.scale(1)]
                )
                .motion(
                    initial: [.opacity(0), .y(16)],
                    animate: [.opacity(1), .y(0)],
                    transition: MotionTransition(timing: .spring(.gentle), delay: 0.22)
                )
            }

            SectionHeader(
                title: "Variants DSL",
                subtitle: "Named phase states with the variants {} builder"
            )
            .padding(.top, 8)

            VariantsDemo()
        }
        .padding()
    }
}

struct VariantsDemo: View {
    @State private var isExpanded = false

    private let cardVariants = variants {
        MotionVariantState.initial(
            [.opacity(0), .scale(0.88), .y(12)],
            transition: .spring(.gentle)
        )
        MotionVariantState.animate(
            [.opacity(1), .scale(1.0),  .y(0)],
            transition: .spring(.bouncy)
        )
    }

    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: isExpanded ? [.indigo, .purple] : [.gray.opacity(0.3), .gray.opacity(0.2)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(height: isExpanded ? 160 : 80)
                .overlay(
                    Text(isExpanded ? "Expanded ✦" : "Tap to expand")
                        .font(.headline)
                        .foregroundStyle(isExpanded ? .white : .primary)
                )
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: isExpanded)
                .motion(variantSet: cardVariants)
                .whileTap(
                    [.scale(0.97)],
                    inactive: [.scale(1)],
                    action: { isExpanded.toggle() }
                )
        }
    }
}

// MARK: - Modal Overlay (AnimatePresence child)

struct ModalOverlay: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }
                .motionPresence(
                    initial: [.opacity(0)],
                    animate: [.opacity(1)],
                    exit:    [.opacity(0)],
                    transition:     MotionTransition(timing: .tween(duration: 0.25)),
                    exitTransition: MotionTransition(timing: .tween(duration: 0.2))
                )

            VStack(spacing: 0) {
                // Handle
                Capsule()
                    .fill(Color.secondary.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 20)

                VStack(spacing: 16) {
                    // Animated icon
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.12))
                            .frame(width: 72, height: 72)
                        Image(systemName: "sparkles")
                            .font(.system(size: 32))
                            .foregroundStyle(.blue)
                    }
                    .motion(
                        initial: [.scale(0), .opacity(0), .rotation(-180)],
                        animate: [.scale(1), .opacity(1), .rotation(0)],
                        transition: MotionTransition(timing: .spring(.bouncy), delay: 0.1)
                    )

                    Text("framer-swift Modal")
                        .font(.title2.bold())
                        .motion(
                            initial: [.opacity(0), .y(12)],
                            animate: [.opacity(1), .y(0)],
                            transition: MotionTransition(timing: .spring(.gentle), delay: 0.2)
                        )

                    Text("This sheet animated in from below via AnimatePresence + motionPresence. Tap Dismiss or the backdrop to trigger the exit animation.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .motion(
                            initial: [.opacity(0), .y(8)],
                            animate: [.opacity(1), .y(0)],
                            transition: MotionTransition(timing: .spring(.gentle), delay: 0.28)
                        )
                }
                .padding(.horizontal, 24)

                Button {
                    isPresented = false
                } label: {
                    Text("Dismiss")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 14))
                }
                .whileTap(
                    [.scale(0.97)],
                    inactive: [.scale(1)]
                )
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .motion(
                    initial: [.opacity(0), .y(16)],
                    animate: [.opacity(1), .y(0)],
                    transition: MotionTransition(timing: .spring(.gentle), delay: 0.35)
                )

                Spacer(minLength: 32)
            }
            .background(
                Color(.systemBackground),
                in: RoundedRectangle(cornerRadius: 28)
            )
            .padding(.horizontal, 8)
            .motionPresence(
                initial: [.opacity(0), .y(100)],
                animate: [.opacity(1), .y(0)],
                exit:    [.opacity(0), .y(100)],
                transition:     MotionTransition(timing: .spring(.gentle)),
                exitTransition: MotionTransition(timing: .spring(SpringConfiguration.stiff))
            )
        }
        .ignoresSafeArea()
    }
}
