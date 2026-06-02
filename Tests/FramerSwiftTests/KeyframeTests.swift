import XCTest
@testable import FramerSwift

final class KeyframeTests: XCTestCase {

    private func makeSequence() -> KeyframeSequence {
        KeyframeSequence(entries: [
            KeyframeEntry(time: 0, properties: [.opacity(0)]),
            KeyframeEntry(time: 0.5, properties: [.opacity(0.5)]),
            KeyframeEntry(time: 1.0, properties: [.opacity(1)])
        ], defaultEasing: LinearEasing())
    }

    func testKeyframeAtStart() {
        let seq = makeSequence()
        let props = seq.evaluate(at: 0)
        let opacity = props.first(where: { $0.key == "opacity" })
        XCTAssertNotNil(opacity)
        XCTAssertEqual(opacity!.doubleValue, 0.0, accuracy: 0.01)
    }

    func testKeyframeAtEnd() {
        let seq = makeSequence()
        let props = seq.evaluate(at: 1.0)
        let opacity = props.first(where: { $0.key == "opacity" })
        XCTAssertNotNil(opacity)
        XCTAssertEqual(opacity!.doubleValue, 1.0, accuracy: 0.01)
    }

    func testKeyframeAtMidpoint() {
        let seq = makeSequence()
        let props = seq.evaluate(at: 0.5)
        let opacity = props.first(where: { $0.key == "opacity" })
        XCTAssertNotNil(opacity)
        XCTAssertEqual(opacity!.doubleValue, 0.5, accuracy: 0.05)
    }

    func testKeyframeInterpolationQuarter() {
        let seq = makeSequence()
        let props = seq.evaluate(at: 0.25)
        let opacity = props.first(where: { $0.key == "opacity" })
        XCTAssertNotNil(opacity)
        XCTAssertEqual(opacity!.doubleValue, 0.25, accuracy: 0.05)
    }

    func testKeyframeClampsAboveOne() {
        let seq = makeSequence()
        let props = seq.evaluate(at: 2.0)
        let opacity = props.first(where: { $0.key == "opacity" })
        XCTAssertEqual(opacity?.doubleValue ?? 0, 1.0, accuracy: 0.01)
    }

    func testKeyframeClampsBelow() {
        let seq = makeSequence()
        let props = seq.evaluate(at: -0.5)
        let opacity = props.first(where: { $0.key == "opacity" })
        XCTAssertEqual(opacity?.doubleValue ?? 1, 0.0, accuracy: 0.01)
    }
}
