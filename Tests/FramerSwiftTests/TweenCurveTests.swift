import XCTest
@testable import FramerSwift

final class TweenCurveTests: XCTestCase {

    func testLinearEasingMidpoint() {
        let easing = LinearEasing()
        XCTAssertEqual(easing.evaluate(at: 0.5), 0.5, accuracy: 0.001)
    }

    func testLinearEasingBounds() {
        let easing = LinearEasing()
        XCTAssertEqual(easing.evaluate(at: 0), 0, accuracy: 0.001)
        XCTAssertEqual(easing.evaluate(at: 1), 1, accuracy: 0.001)
    }

    func testCubicBezierEaseInOutIsSymmetric() {
        let easing = CubicBezierEasing.easeInOut
        let low = easing.evaluate(at: 0.25)
        let high = easing.evaluate(at: 0.75)
        XCTAssertEqual(low, 1.0 - high, accuracy: 0.01, "easeInOut should be symmetric around 0.5")
    }

    func testCubicBezierBounds() {
        let easing = CubicBezierEasing.easeIn
        XCTAssertEqual(easing.evaluate(at: 0), 0.0, accuracy: 0.01)
        XCTAssertEqual(easing.evaluate(at: 1), 1.0, accuracy: 0.01)
    }

    func testBackOutOvershoot() {
        let easing = CubicBezierEasing.backOut
        var maxValue = 0.0
        for i in stride(from: 0.0, to: 1.0, by: 0.01) {
            maxValue = max(maxValue, easing.evaluate(at: i))
        }
        XCTAssertGreaterThan(maxValue, 1.0, "backOut should overshoot")
    }

    // MARK: TweenInterpolator

    func testTweenInterpolatorMidpointLinear() {
        let config = TweenConfiguration(duration: 1.0, easing: LinearEasing())
        let interp = TweenInterpolator(config: config)
        XCTAssertEqual(interp.value(at: 0.5, from: 0, to: 100), 50.0, accuracy: 0.1)
    }

    func testTweenInterpolatorAtZero() {
        let config = TweenConfiguration(duration: 1.0, easing: LinearEasing())
        let interp = TweenInterpolator(config: config)
        XCTAssertEqual(interp.value(at: 0, from: 0, to: 100), 0.0, accuracy: 0.1)
    }

    func testTweenInterpolatorAtOne() {
        let config = TweenConfiguration(duration: 1.0, easing: LinearEasing())
        let interp = TweenInterpolator(config: config)
        XCTAssertEqual(interp.value(at: 1, from: 0, to: 100), 100.0, accuracy: 0.1)
    }

    func testTweenInterpolatorClampsT() {
        let config = TweenConfiguration(duration: 1.0, easing: LinearEasing())
        let interp = TweenInterpolator(config: config)
        XCTAssertEqual(interp.value(at: 1.5, from: 0, to: 100), 100.0, accuracy: 0.1)
        XCTAssertEqual(interp.value(at: -0.5, from: 0, to: 100), 0.0, accuracy: 0.1)
    }

    // MARK: ValueInterpolator

    func testLerpBetweenValues() {
        XCTAssertEqual(ValueInterpolator.lerp(0, 100, t: 0.3), 30.0, accuracy: 0.001)
    }

    func testClamp() {
        XCTAssertEqual(ValueInterpolator.clamp(150, min: 0, max: 100), 100)
        XCTAssertEqual(ValueInterpolator.clamp(-10, min: 0, max: 100), 0)
        XCTAssertEqual(ValueInterpolator.clamp(50, min: 0, max: 100), 50)
    }

    func testNormalize() {
        XCTAssertEqual(ValueInterpolator.normalize(50, low: 0, high: 100), 0.5, accuracy: 0.001)
        XCTAssertEqual(ValueInterpolator.normalize(0, low: 0, high: 100), 0.0, accuracy: 0.001)
        XCTAssertEqual(ValueInterpolator.normalize(100, low: 0, high: 100), 1.0, accuracy: 0.001)
    }

    func testNormalizeSameRange() {
        XCTAssertEqual(ValueInterpolator.normalize(50, low: 50, high: 50), 0.0)
    }

    func testMapRange() {
        let result = ValueInterpolator.mapRange(0.5, inLow: 0, inHigh: 1, outLow: 0, outHigh: 200)
        XCTAssertEqual(result, 100.0, accuracy: 0.001)
    }

    func testMapRangeWithClamp() {
        let result = ValueInterpolator.mapRange(2.0, inLow: 0, inHigh: 1, outLow: 0, outHigh: 100, clamp: true)
        XCTAssertEqual(result, 100.0, accuracy: 0.001)
    }
}
