import XCTest
@testable import FramerSwift

final class AnimatablePropertyTests: XCTestCase {

    func testOpacityKey() {
        XCTAssertEqual(AnimatableProperty.opacity(1.0).key, "opacity")
    }

    func testScaleDoubleValue() {
        XCTAssertEqual(AnimatableProperty.scale(2.0).doubleValue, 2.0, accuracy: 0.001)
    }

    func testWithValuePreservesType() {
        let original = AnimatableProperty.opacity(0.5)
        let modified = original.withValue(0.9)
        if case .opacity(let v) = modified {
            XCTAssertEqual(v, 0.9, accuracy: 0.001)
        } else {
            XCTFail("withValue should preserve the property type")
        }
    }

    func testRotationKey() {
        XCTAssertEqual(AnimatableProperty.rotation(45).key, "rotation")
    }

    func testXKey() {
        XCTAssertEqual(AnimatableProperty.x(10).key, "x")
    }

    func testAllKeysAreUnique() {
        let properties: [AnimatableProperty] = [
            .opacity(1), .scale(1), .scaleX(1), .scaleY(1),
            .rotation(0), .rotationX(0), .rotationY(0),
            .x(0), .y(0), .width(0), .height(0),
            .blur(0), .brightness(0), .saturation(1), .cornerRadius(0)
        ]
        let keys = properties.map { $0.key }
        let uniqueKeys = Set(keys)
        XCTAssertEqual(keys.count, uniqueKeys.count, "All AnimatableProperty keys must be unique")
    }

    func testWithValueForScale() {
        let prop = AnimatableProperty.scale(1.0).withValue(2.5)
        XCTAssertEqual(prop.doubleValue, 2.5, accuracy: 0.001)
    }

    func testWithValueForX() {
        let prop = AnimatableProperty.x(0).withValue(100)
        if case .x(let v) = prop {
            XCTAssertEqual(Double(v), 100.0, accuracy: 0.001)
        } else {
            XCTFail("Type should be preserved")
        }
    }
}
