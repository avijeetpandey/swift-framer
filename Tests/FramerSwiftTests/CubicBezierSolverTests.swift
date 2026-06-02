import XCTest
@testable import FramerSwift

final class CubicBezierSolverTests: XCTestCase {

    func testLinearBezier() {
        // x1=0, y1=0, x2=1, y2=1 should behave as linear
        let easing = CubicBezierEasing(x1: 0, y1: 0, x2: 1, y2: 1)
        XCTAssertEqual(easing.evaluate(at: 0.5), 0.5, accuracy: 0.01)
    }

    func testEaseInOutSymmetry() {
        let easing = CubicBezierEasing.easeInOut
        let low = easing.evaluate(at: 0.25)
        let high = easing.evaluate(at: 0.75)
        XCTAssertEqual(low + high, 1.0, accuracy: 0.02)
    }

    func testEaseOutFasterAtStart() {
        let easeOut = CubicBezierEasing.easeOut
        let easeIn = CubicBezierEasing.easeIn
        // easeOut should progress faster early
        XCTAssertGreaterThan(easeOut.evaluate(at: 0.2), easeIn.evaluate(at: 0.2))
    }

    func testBezierAtZeroIsZero() {
        let easing = CubicBezierEasing.easeInOut
        XCTAssertEqual(easing.evaluate(at: 0), 0.0, accuracy: 0.001)
    }

    func testBezierAtOneIsOne() {
        let easing = CubicBezierEasing.easeInOut
        XCTAssertEqual(easing.evaluate(at: 1), 1.0, accuracy: 0.001)
    }
}
