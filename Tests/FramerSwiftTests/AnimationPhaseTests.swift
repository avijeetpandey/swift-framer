import XCTest
@testable import FramerSwift

final class AnimationPhaseTests: XCTestCase {

    func testPhaseEquality() {
        XCTAssertEqual(AnimationPhase.initial, AnimationPhase.initial)
        XCTAssertEqual(AnimationPhase.animate, AnimationPhase.animate)
        XCTAssertEqual(AnimationPhase.exit, AnimationPhase.exit)
        XCTAssertEqual(AnimationPhase.custom("open"), AnimationPhase.custom("open"))
    }

    func testPhaseInequality() {
        XCTAssertNotEqual(AnimationPhase.initial, AnimationPhase.animate)
        XCTAssertNotEqual(AnimationPhase.custom("open"), AnimationPhase.custom("closed"))
        XCTAssertNotEqual(AnimationPhase.exit, AnimationPhase.initial)
    }
}
