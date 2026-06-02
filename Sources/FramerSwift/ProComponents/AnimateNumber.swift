import SwiftUI

// MARK: - AnimateNumber

/// A view that smoothly interpolates between numeric values whenever the target
/// changes, mirroring Framer Motion's animated counters.
///
/// Rather than relying on SwiftUI's `Animatable` (which crosses actor isolation
/// boundaries), the count is driven by the library's own timing engine: a
/// `Timer` advances elapsed time and the configured `MotionTiming` warps it into
/// eased progress, so springs and tweens feel identical to the rest of
/// `framer-swift`. A custom `format` closure controls presentation (currency,
/// percentages, decimals, grouping, etc.).
///
/// ```swift
/// AnimateNumber(value: total, format: { String(format: "$%.2f", $0) })
/// ```
public struct AnimateNumber: View {

    private let target: Double
    private let format: (Double) -> String
    private let font: Font
    private let foregroundColor: Color?
    private let monospacedDigits: Bool
    private let timing: MotionTiming

    @State private var displayed: Double
    @State private var animationStart: Double = 0
    @State private var startTime: Date?
    @State private var timer: Timer?

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Creates an animated number view.
    ///
    /// - Parameters:
    ///   - value: The target numeric value to display.
    ///   - font: The text font. Defaults to `.body`.
    ///   - foregroundColor: Optional text color.
    ///   - monospacedDigits: Use monospaced digits to avoid width jitter while
    ///     counting. Defaults to `true`.
    ///   - timing: The timing curve driving the count. Defaults to a 0.6s tween.
    ///   - format: Converts the interpolated value to a string. Defaults to a
    ///     rounded integer string.
    public init(
        value: Double,
        font: Font = .body,
        foregroundColor: Color? = nil,
        monospacedDigits: Bool = true,
        timing: MotionTiming = .tween(duration: 0.6),
        format: @escaping (Double) -> String = { String(Int($0.rounded())) }
    ) {
        self.target = value
        self.font = font
        self.foregroundColor = foregroundColor
        self.monospacedDigits = monospacedDigits
        self.timing = timing
        self.format = format
        self._displayed = State(initialValue: value)
    }

    public var body: some View {
        let text = Text(format(displayed)).font(font)
        return Group {
            if monospacedDigits {
                text.monospacedDigit()
            } else {
                text
            }
        }
        .foregroundColor(foregroundColor)
        .onAppear { displayed = target }
        .onDisappear { stop() }
        .onChange(of: target) { newValue in
            animate(to: newValue)
        }
    }

    // MARK: Animation Driver

    private func animate(to newValue: Double) {
        stop()

        if motionConfig.reducedMotion || reduceMotion {
            displayed = newValue
            return
        }

        animationStart = displayed
        startTime = Date()

        let t = Timer(timeInterval: 1.0 / 60.0, repeats: true) { _ in
            Task { @MainActor in
                tick(target: newValue)
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick(target newValue: Double) {
        guard let startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let progress = easedProgress(at: elapsed)
        displayed = ValueInterpolator.lerp(animationStart, newValue, t: progress)

        if progress >= 1 {
            displayed = newValue
            stop()
        }
    }

    /// Maps elapsed seconds to eased `0...1` progress using the active timing.
    private func easedProgress(at elapsed: Double) -> Double {
        switch timing {
        case .spring(let config):
            let simulator = SpringSimulator(config: config)
            if simulator.isAtRest(at: elapsed) { return 1 }
            return simulator.value(at: elapsed, from: 0, to: 1)
        case .tween(let duration, let easing):
            let linear = min(1, elapsed / max(duration, 0.0001))
            return easing.base.evaluate(at: linear)
        case .keyframes:
            let duration = timing.estimatedDuration
            return min(1, elapsed / max(duration, 0.0001))
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }
}
