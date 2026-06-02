import XCTest
@testable import FramerSwift

final class TextScrambleEngineTests: XCTestCase {

    func testResolvedCountAtZero() {
        let engine = TextScrambleEngine()
        XCTAssertEqual(engine.resolvedCount(for: "HELLO", progress: 0), 0)
    }

    func testResolvedCountAtOne() {
        let engine = TextScrambleEngine()
        XCTAssertEqual(engine.resolvedCount(for: "HELLO", progress: 1), 5)
    }

    func testResolvedCountAtHalf() {
        let engine = TextScrambleEngine()
        XCTAssertEqual(engine.resolvedCount(for: "ABCDEF", progress: 0.5), 3)
    }

    func testFrameFullyResolvedEqualsTarget() {
        let engine = TextScrambleEngine()
        XCTAssertEqual(engine.frame(for: "DECODE", progress: 1), "DECODE")
    }

    func testEmptyStringReturnsEmpty() {
        let engine = TextScrambleEngine()
        XCTAssertEqual(engine.frame(for: "", progress: 0.5), "")
    }

    func testFrameLengthMatchesTarget() {
        let engine = TextScrambleEngine()
        let frame = engine.frame(for: "SCRAMBLE", progress: 0.3)
        XCTAssertEqual(frame.count, "SCRAMBLE".count)
    }

    func testWhitespaceIsPreserved() {
        let engine = TextScrambleEngine()
        let frame = engine.frame(for: "A B", progress: 0)
        let chars = Array(frame)
        XCTAssertEqual(chars[1], " ")
    }

    func testResolvedPrefixMatchesTarget() {
        let engine = TextScrambleEngine()
        let frame = engine.frame(for: "ABCDEF", progress: 0.5)
        XCTAssertTrue(frame.hasPrefix("ABC"))
    }

    func testDeterministicForSameSeed() {
        let a = TextScrambleEngine(seed: 1234)
        let b = TextScrambleEngine(seed: 1234)
        XCTAssertEqual(a.frame(for: "DETERMINISTIC", progress: 0.4),
                       b.frame(for: "DETERMINISTIC", progress: 0.4))
    }

    func testUnresolvedGlyphsFromAlphabet() {
        let engine = TextScrambleEngine(alphabet: "XYZ", seed: 99)
        let frame = engine.frame(for: "....", progress: 0)
        for ch in frame {
            XCTAssertTrue("XYZ".contains(ch))
        }
    }
}
