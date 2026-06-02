import XCTest
@testable import FramerSwift

final class PropertyApplicatorTests: XCTestCase {

    func testResolveDefaultValues() {
        let resolved = PropertyApplicator.resolve([])
        XCTAssertEqual(resolved.opacity, 1.0)
        XCTAssertEqual(resolved.scaleX, 1.0)
        XCTAssertEqual(resolved.scaleY, 1.0)
        XCTAssertEqual(resolved.rotation, 0.0)
        XCTAssertEqual(Double(resolved.x), 0.0)
        XCTAssertEqual(Double(resolved.y), 0.0)
        XCTAssertEqual(Double(resolved.blur), 0.0)
    }

    func testResolveOpacity() {
        let resolved = PropertyApplicator.resolve([.opacity(0.5)])
        XCTAssertEqual(resolved.opacity, 0.5, accuracy: 0.001)
    }

    func testResolveScaleAppliesToBoth() {
        let resolved = PropertyApplicator.resolve([.scale(2.0)])
        XCTAssertEqual(Double(resolved.scaleX), 2.0, accuracy: 0.001)
        XCTAssertEqual(Double(resolved.scaleY), 2.0, accuracy: 0.001)
    }

    func testResolveScaleXOnly() {
        let resolved = PropertyApplicator.resolve([.scaleX(3.0)])
        XCTAssertEqual(Double(resolved.scaleX), 3.0, accuracy: 0.001)
        XCTAssertEqual(Double(resolved.scaleY), 1.0, accuracy: 0.001)
    }

    func testResolveMultipleProperties() {
        let resolved = PropertyApplicator.resolve([
            .opacity(0.8),
            .x(20),
            .y(-10),
            .rotation(45)
        ])
        XCTAssertEqual(resolved.opacity, 0.8, accuracy: 0.001)
        XCTAssertEqual(Double(resolved.x), 20.0, accuracy: 0.001)
        XCTAssertEqual(Double(resolved.y), -10.0, accuracy: 0.001)
        XCTAssertEqual(resolved.rotation, 45.0, accuracy: 0.001)
    }

    func testResolveLastWriteWins() {
        let resolved = PropertyApplicator.resolve([.opacity(0.1), .opacity(0.9)])
        XCTAssertEqual(resolved.opacity, 0.9, accuracy: 0.001)
    }
}
