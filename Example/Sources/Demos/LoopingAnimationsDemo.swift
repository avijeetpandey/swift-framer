import SwiftUI
import FramerSwift

// MARK: - Looping Animations Demo
// Showcases motionLoop with mirror, loop, and reverse types.

struct LoopingAnimationsDemo: View {
    var body: some View {
        VStack(spacing: 32) {
            SectionHeader(
                title: "Loop Animations",
                subtitle: "Infinite repeating with mirror / loop / reverse"
            )

            // Pulsing circle — scale mirror
            LoopDemoRow(label: "Pulse", sublabel: "scale + opacity mirror") {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.blue, .cyan],
                            center: .center,
                            startRadius: 0,
                            endRadius: 35
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: .blue.opacity(0.5), radius: 12, y: 4)
                    .motionLoop(
                        initial: [.scale(0.85), .opacity(0.65)],
                        animate: [.scale(1.15), .opacity(1.0)],
                        transition: MotionTransition(
                            timing: .tween(
                                duration: 1.0,
                                easing: AnyEasing(CubicBezierEasing.easeInOut)
                            ),
                            repeatCount: .infinity,
                            repeatMirror: true
                        ),
                        type: .mirror
                    )
            }

            // Spinning icon — continuous rotation
            LoopDemoRow(label: "Spin", sublabel: "360° rotation loop") {
                Image(systemName: "rays")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .cyan, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .motionLoop(
                        initial: [.rotation(0)],
                        animate: [.rotation(360)],
                        transition: MotionTransition(
                            timing: .tween(
                                duration: 2.5,
                                easing: AnyEasing(LinearEasing())
                            ),
                            repeatCount: .infinity,
                            repeatMirror: false
                        ),
                        type: .loop
                    )
            }

            // Bouncing dot — y-axis mirror
            LoopDemoRow(label: "Bounce", sublabel: "y-offset spring mirror") {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 24, height: 24)
                    .shadow(color: .orange.opacity(0.6), radius: 6, y: 2)
                    .motionLoop(
                        initial: [.y(-18)],
                        animate: [.y(18)],
                        transition: MotionTransition(
                            timing: .spring(.wobbly),
                            repeatCount: .infinity,
                            repeatMirror: true
                        ),
                        type: .mirror
                    )
            }

            // Breathing square — blur + scale
            LoopDemoRow(label: "Breathe", sublabel: "blur + scale mirror") {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.teal.opacity(0.85))
                    .frame(width: 64, height: 64)
                    .motionLoop(
                        initial: [.scale(0.9), .blur(0)],
                        animate: [.scale(1.1), .blur(2)],
                        transition: MotionTransition(
                            timing: .tween(
                                duration: 1.8,
                                easing: AnyEasing(CubicBezierEasing.easeInOut)
                            ),
                            repeatCount: .infinity,
                            repeatMirror: true
                        ),
                        type: .mirror
                    )
            }

            // Saturation loop
            LoopDemoRow(label: "Saturate", sublabel: "saturation oscillation") {
                Image(systemName: "photo.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .purple],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .motionLoop(
                        initial: [.saturation(0.1)],
                        animate: [.saturation(1.5)],
                        transition: MotionTransition(
                            timing: .tween(
                                duration: 2.0,
                                easing: AnyEasing(CubicBezierEasing.easeInOut)
                            ),
                            repeatCount: .infinity,
                            repeatMirror: true
                        ),
                        type: .mirror
                    )
            }
        }
        .padding()
    }
}

struct LoopDemoRow<Content: View>: View {
    let label: String
    let sublabel: String
    let content: Content

    init(label: String, sublabel: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.sublabel = sublabel
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.body.weight(.semibold))
                Text(sublabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            content
                .frame(width: 80)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.secondary.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
        .motion(
            initial: [.opacity(0), .x(20)],
            animate: [.opacity(1), .x(0)],
            transition: .spring(.gentle)
        )
    }
}
