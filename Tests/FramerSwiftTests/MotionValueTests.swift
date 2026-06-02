import XCTest
@testable import FramerSwift

@MainActor
final class MotionValueTests: XCTestCase {

    func testInitialValue() {
        let value = MotionValue<Double>(5)
        XCTAssertEqual(value.value, 5)
    }

    func testSetUpdatesValue() {
        let value = MotionValue<Double>(0)
        value.set(42)
        XCTAssertEqual(value.value, 42)
    }

    func testOnChangeFires() {
        let value = MotionValue<Double>(0)
        var received: Double = -1
        let sub = value.onChange { received = $0 }
        value.set(10)
        XCTAssertEqual(received, 10)
        sub.cancel()
    }

    func testOnChangeStopsAfterCancel() {
        let value = MotionValue<Double>(0)
        var callCount = 0
        let sub = value.onChange { _ in callCount += 1 }
        value.set(1)
        sub.cancel()
        value.set(2)
        XCTAssertEqual(callCount, 1)
    }

    func testUpdateMutatesInPlace() {
        let value = MotionValue<Int>(3)
        value.update { $0 += 7 }
        XCTAssertEqual(value.value, 10)
    }

    func testMapDerivesValue() {
        let source = MotionValue<Double>(2)
        let derived = source.map { $0 * 3 }
        XCTAssertEqual(derived.value, 6)
        source.set(4)
        XCTAssertEqual(derived.value, 12)
    }

    func testMapChainStaysAliveWithoutExternalRetain() {
        let source = MotionValue<Double>(1)
        let derived = source.map { $0 + 1 }
        // No explicit retention of the internal subscription required.
        source.set(9)
        XCTAssertEqual(derived.value, 10)
    }

    func testTransformRemapsRange() {
        let source = MotionValue<Double>(0)
        let mapped = source.transform(inputRange: 0...100, outputRange: 0...1)
        source.set(50)
        XCTAssertEqual(mapped.value, 0.5, accuracy: 0.0001)
    }

    func testTransformClampsByDefault() {
        let source = MotionValue<Double>(0)
        let mapped = source.transform(inputRange: 0...100, outputRange: 0...1)
        source.set(200)
        XCTAssertEqual(mapped.value, 1.0, accuracy: 0.0001)
    }

    func testMultipleObservers() {
        let value = MotionValue<Double>(0)
        var a = 0.0, b = 0.0
        let s1 = value.onChange { a = $0 }
        let s2 = value.onChange { b = $0 }
        value.set(7)
        XCTAssertEqual(a, 7)
        XCTAssertEqual(b, 7)
        s1.cancel(); s2.cancel()
    }
}
