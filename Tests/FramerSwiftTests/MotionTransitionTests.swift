import XCTest
@testable import FramerSwift

final class MotionTransitionTests: XCTestCase {

    func testDefaultTransitionHasZeroDelay() {
        XCTAssertEqual(MotionTransition.default.delay, 0)
    }

    func testDelayedAddsDelay() {
        let t = MotionTransition.default.delayed(by: 0.5)
        XCTAssertEqual(t.delay, 0.5, accuracy: 0.001)
    }

    func testStaggerSetsChildren() {
        let t = MotionTransition.default.stagger(children: 0.1, delay: 0.2)
        XCTAssertEqual(t.staggerChildren, 0.1, accuracy: 0.001)
        XCTAssertEqual(t.delayChildren, 0.2, accuracy: 0.001)
    }

    func testSpringConvenienceCreatesSpringTiming() {
        let t = MotionTransition.spring(.default)
        if case .spring = t.timing { } else {
            XCTFail("Expected spring timing")
        }
    }

    func testTweenConvenienceCreatesTweenTiming() {
        let t = MotionTransition.tween(duration: 0.4)
        if case .tween(let d, _) = t.timing {
            XCTAssertEqual(d, 0.4, accuracy: 0.001)
        } else {
            XCTFail("Expected tween timing")
        }
    }
}
