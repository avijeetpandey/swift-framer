import SwiftUI

// MARK: - Typewriter

/// A text view that reveals its content one character at a time, emulating a
/// typewriter / terminal effect.
///
/// The reveal is driven by a `Timer` running at a fixed per-character cadence.
/// An optional blinking cursor glyph trails the revealed text while typing.
/// Changing `text` restarts the animation from the beginning.
///
/// ```swift
/// Typewriter("Hello, framer-swift", charactersPerSecond: 18)
/// ```
public struct Typewriter: View {

    private let text: String
    private let charactersPerSecond: Double
    private let font: Font
    private let foregroundColor: Color?
    private let cursor: String?
    private let startDelay: Double
    private let onComplete: (() -> Void)?

    @State private var revealedCount: Int = 0
    @State private var timer: Timer?
    @State private var cursorVisible: Bool = true
    @State private var cursorTimer: Timer?

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Creates a typewriter text view.
    ///
    /// - Parameters:
    ///   - text: The full string to reveal.
    ///   - charactersPerSecond: Typing speed. Defaults to `20`.
    ///   - font: The text font. Defaults to `.body`.
    ///   - foregroundColor: Optional text color.
    ///   - cursor: A trailing cursor glyph shown while typing. Pass `nil` to hide.
    ///     Defaults to `"|"`.
    ///   - startDelay: Seconds to wait before typing begins. Defaults to `0`.
    ///   - onComplete: Called once the full string is revealed.
    public init(
        _ text: String,
        charactersPerSecond: Double = 20,
        font: Font = .body,
        foregroundColor: Color? = nil,
        cursor: String? = "|",
        startDelay: Double = 0,
        onComplete: (() -> Void)? = nil
    ) {
        self.text = text
        self.charactersPerSecond = max(1, charactersPerSecond)
        self.font = font
        self.foregroundColor = foregroundColor
        self.cursor = cursor
        self.startDelay = startDelay
        self.onComplete = onComplete
    }

    private var revealedText: String {
        String(text.prefix(revealedCount))
    }

    private var isComplete: Bool {
        revealedCount >= text.count
    }

    public var body: some View {
        HStack(spacing: 1) {
            Text(revealedText)
            if let cursor, (!isComplete || cursorVisible) {
                Text(cursor)
                    .opacity(cursorVisible ? 1 : 0)
            }
        }
        .font(font)
        .foregroundColor(foregroundColor)
        .onAppear { start() }
        .onDisappear { stopAll() }
        .onChange(of: text) { _ in restart() }
    }

    // MARK: Timers

    private func start() {
        // Reduced motion: reveal instantly.
        if motionConfig.reducedMotion || reduceMotion {
            revealedCount = text.count
            onComplete?()
            return
        }

        startCursorBlink()

        let interval = 1.0 / charactersPerSecond
        DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
            let t = Timer(timeInterval: interval, repeats: true) { _ in
                Task { @MainActor in
                    advance()
                }
            }
            RunLoop.main.add(t, forMode: .common)
            timer = t
        }
    }

    private func advance() {
        guard revealedCount < text.count else {
            timer?.invalidate()
            timer = nil
            onComplete?()
            return
        }
        revealedCount += 1
    }

    private func startCursorBlink() {
        let blink = Timer(timeInterval: 0.5, repeats: true) { _ in
            Task { @MainActor in
                cursorVisible.toggle()
            }
        }
        RunLoop.main.add(blink, forMode: .common)
        cursorTimer = blink
    }

    private func restart() {
        stopAll()
        revealedCount = 0
        cursorVisible = true
        start()
    }

    private func stopAll() {
        timer?.invalidate()
        timer = nil
        cursorTimer?.invalidate()
        cursorTimer = nil
    }
}
