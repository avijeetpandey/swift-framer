import Foundation

// MARK: - TextScrambleEngine

/// A pure, deterministic engine that computes intermediate "scrambled" frames as
/// a target string resolves from left to right.
///
/// Separating the logic from the view makes the scramble behavior fully unit
/// testable. Given a `progress` in `0...1`, the engine resolves the leading
/// `floor(progress * count)` characters to their final values and fills the
/// remainder with pseudo-random glyphs drawn from `alphabet`.
public struct TextScrambleEngine: Sendable {

    /// The pool of characters used for unresolved positions.
    public let alphabet: [Character]

    /// A seed enabling deterministic, reproducible scrambling (e.g. in tests).
    private let seed: UInt64

    public init(
        alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%&*",
        seed: UInt64 = 0x9E3779B97F4A7C15
    ) {
        self.alphabet = Array(alphabet)
        self.seed = seed
    }

    /// The number of fully resolved characters at the given progress.
    public func resolvedCount(for target: String, progress: Double) -> Int {
        let clamped = max(0, min(1, progress))
        return Int((Double(target.count) * clamped).rounded(.down))
    }

    /// Computes the scrambled frame for `target` at `progress`.
    ///
    /// - Whitespace is always passed through unscrambled (preserves word shape).
    /// - The first `resolvedCount` characters render their final values.
    /// - Remaining non-space characters render a deterministic random glyph that
    ///   varies with `progress`, producing visible churn between frames.
    public func frame(for target: String, progress: Double) -> String {
        guard !target.isEmpty else { return "" }
        let resolved = resolvedCount(for: target, progress: progress)
        let characters = Array(target)
        let step = UInt64((max(0, min(1, progress)) * 1000).rounded())

        var result = String()
        result.reserveCapacity(characters.count)

        for (index, character) in characters.enumerated() {
            if index < resolved || character == " " || character == "\n" {
                result.append(character)
            } else {
                let glyph = randomGlyph(index: index, step: step)
                result.append(glyph)
            }
        }
        return result
    }

    // MARK: Deterministic RNG

    private func randomGlyph(index: Int, step: UInt64) -> Character {
        // SplitMix64-style hashing for deterministic, well-distributed output.
        var x = seed &+ (UInt64(index) &* 0x100000001B3) &+ (step &* 0xD1B54A32D192ED03)
        x = (x ^ (x >> 30)) &* 0xBF58476D1CE4E5B9
        x = (x ^ (x >> 27)) &* 0x94D049BB133111EB
        x = x ^ (x >> 31)
        let idx = Int(x % UInt64(alphabet.count))
        return alphabet[idx]
    }
}
