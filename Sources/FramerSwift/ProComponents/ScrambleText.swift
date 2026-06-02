import SwiftUI

// MARK: - ScrambleText

/// A text view that resolves to its final string through a "decoding" scramble
/// effect: unresolved characters churn through random glyphs while the text
/// settles from left to right.
///
/// The visual is produced by ``TextScrambleEngine`` advancing a `0...1` progress
/// via a `Timer`. Changing `text` restarts the effect.
///
/// ```swift
/// ScrambleText("DECRYPTED", duration: 1.2)
/// ```
public struct ScrambleText: View {

    private let text: String
    private let duration: Double
    private let font: Font
    private let foregroundColor: Color?
    private let engine: TextScrambleEngine
    private let onComplete: (() -> Void)?

    @State private var progress: Double = 0
    @State private var timer: Timer?
    @State private var startTime: Date?

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Creates a scramble-text view.
    ///
    /// - Parameters:
    ///   - text: The final resolved string.
    ///   - duration: Total time to fully resolve. Defaults to `1.0`.
    ///   - font: The text font. Defaults to `.body` (monospaced recommended).
    ///   - foregroundColor: Optional text color.
    ///   - engine: The scramble engine. Defaults to a standard alphabet engine.
    ///   - onComplete: Called once fully resolved.
    public init(
        _ text: String,
        duration: Double = 1.0,
        font: Font = .system(.body, design: .monospaced),
        foregroundColor: Color? = nil,
        engine: TextScrambleEngine = TextScrambleEngine(),
        onComplete: (() -> Void)? = nil
    ) {
        self.text = text
        self.duration = max(0.01, duration)
        self.font = font
        self.foregroundColor = foregroundColor
        self.engine = engine
        self.onComplete = onComplete
    }

    public var body: some View {
        Text(engine.frame(for: text, progress: progress))
            .font(font)
            .foregroundColor(foregroundColor)
            .onAppear { start() }
            .onDisappear { stop() }
            .onChange(of: text) { _ in restart() }
    }

    // MARK: Timer

    private func start() {
        if motionConfig.reducedMotion || reduceMotion {
            progress = 1
            onComplete?()
            return
        }

        startTime = Date()
        let t = Timer(timeInterval: 1.0 / 30.0, repeats: true) { _ in
            Task { @MainActor in
                tick()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        guard let startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let newProgress = min(1, elapsed / duration)
        progress = newProgress
        if newProgress >= 1 {
            stop()
            onComplete?()
        }
    }

    private func restart() {
        stop()
        progress = 0
        start()
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }
}
