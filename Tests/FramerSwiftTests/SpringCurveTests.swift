import XCTest
@testable import FramerSwift

final class SpringCurveTests: XCTestCase {

    // MARK: SpringConfiguration

    func testDefaultSpringDampingRatio() {
        let spring = SpringConfiguration.default
        let ratio = spring.dampingRatio
        // damping / (2 * sqrt(stiffness * mass)) = 10 / (2 * sqrt(100)) = 10/20 = 0.5
        XCTAssertEqual(ratio, 0.5, accuracy: 0.001)
    }

    func testStiffSpringIsUnderdamped() {
        XCTAssertTrue(SpringConfiguration.stiff.isUnderdamped)
    }

    func testSlowSpringIsOverdamped() {
        let slow = SpringConfiguration.slow
        XCTAssertTrue(slow.isOverdamped)
    }

    func testAngularFrequency() {
        let spring = SpringConfiguration(mass: 1, stiffness: 100, damping: 10)
        // ω₀ = sqrt(100 / 1) = 10
        XCTAssertEqual(spring.angularFrequency, 10.0, accuracy: 0.001)
    }

    func testEstimatedSettlingDurationIsPositive() {
        let spring = SpringConfiguration.default
        XCTAssertGreaterThan(spring.estimatedSettlingDuration, 0)
    }

    func testBouncySpringIsUnderdamped() {
        XCTAssertTrue(SpringConfiguration.bouncy.isUnderdamped)
    }

    // MARK: SpringSimulator

    func testSpringSimulatorAtTimeZeroEqualsFrom() {
        let sim = SpringSimulator(config: .default)
        let value = sim.value(at: 0, from: 0, to: 1)
        XCTAssertEqual(value, 0.0, accuracy: 0.001)
    }

    func testSpringSimulatorSettlesNearTarget() {
        let sim = SpringSimulator(config: .default)
        let settlingTime = sim.settlingTime()
        let value = sim.value(at: settlingTime, from: 0, to: 1)
        XCTAssertEqual(value, 1.0, accuracy: 0.01)
    }

    func testSpringSimulatorWithCustomRange() {
        let sim = SpringSimulator(config: .default)
        let value = sim.value(at: 10, from: 100, to: 200)
        XCTAssertEqual(value, 200.0, accuracy: 1.0)
    }

    func testSpringSimulatorUnderdampedOvershoot() {
        let wobbly = SpringConfiguration.wobbly
        let sim = SpringSimulator(config: wobbly)
        var maxValue = 0.0
        for i in stride(from: 0.0, to: 1.0, by: 0.05) {
            maxValue = max(maxValue, sim.value(at: i, from: 0, to: 1))
        }
        XCTAssertGreaterThan(maxValue, 1.0, "Wobbly spring should overshoot")
    }

    func testSettlingTimeIsFinite() {
        let sim = SpringSimulator(config: .default)
        let t = sim.settlingTime()
        XCTAssertFalse(t.isNaN)
        XCTAssertFalse(t.isInfinite)
        XCTAssertLessThan(t, 30.0)
    }

    func testOverdampedSpringDoesNotOvershoot() {
        let slow = SpringConfiguration.slow
        let sim = SpringSimulator(config: slow)
        for i in stride(from: 0.0, to: 3.0, by: 0.1) {
            let v = sim.value(at: i, from: 0, to: 1)
            XCTAssertLessThanOrEqual(v, 1.001, "Overdamped spring should not overshoot at t=\(i)")
        }
    }

    // MARK: SpringEasing

    func testSpringEasingAtZeroIsZero() {
        let easing = SpringEasing(config: .default)
        XCTAssertEqual(easing.evaluate(at: 0), 0.0, accuracy: 0.05)
    }

    func testSpringEasingAtOneIsNearOne() {
        let easing = SpringEasing(config: .default)
        XCTAssertEqual(easing.evaluate(at: 1.0), 1.0, accuracy: 0.05)
    }
}
