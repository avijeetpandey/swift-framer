import XCTest
import CoreGraphics
@testable import FramerSwift

final class ScrollTimelineTests: XCTestCase {

    func testProgressZeroAtStart() {
        let p = MotionScrollProgress.normalizedProgress(offset: 0, start: 0, distance: 100)
        XCTAssertEqual(p, 0, accuracy: 0.0001)
    }

    func testProgressOneAtEnd() {
        let p = MotionScrollProgress.normalizedProgress(offset: -100, start: 0, distance: 100)
        XCTAssertEqual(p, 1, accuracy: 0.0001)
    }

    func testProgressMidpoint() {
        let p = MotionScrollProgress.normalizedProgress(offset: -50, start: 0, distance: 100)
        XCTAssertEqual(p, 0.5, accuracy: 0.0001)
    }

    func testProgressClampsBelowZero() {
        let p = MotionScrollProgress.normalizedProgress(offset: 50, start: 0, distance: 100)
        XCTAssertEqual(p, 0, accuracy: 0.0001)
    }

    func testProgressClampsAboveOne() {
        let p = MotionScrollProgress.normalizedProgress(offset: -200, start: 0, distance: 100)
        XCTAssertEqual(p, 1, accuracy: 0.0001)
    }

    func testProgressWithNonZeroStart() {
        let p = MotionScrollProgress.normalizedProgress(offset: 100, start: 200, distance: 200)
        XCTAssertEqual(p, 0.5, accuracy: 0.0001)
    }

    func testZeroDistanceDoesNotCrash() {
        let p = MotionScrollProgress.normalizedProgress(offset: -10, start: 0, distance: 0)
        XCTAssertTrue(p >= 0 && p <= 1)
    }

    func testSnapshotEquatable() {
        let a = MotionScrollProgress(offset: 10, progress: 0.5, axis: .vertical)
        let b = MotionScrollProgress(offset: 10, progress: 0.5, axis: .vertical)
        XCTAssertEqual(a, b)
    }

    func testAxisInequality() {
        let a = MotionScrollProgress(offset: 0, progress: 0, axis: .vertical)
        let b = MotionScrollProgress(offset: 0, progress: 0, axis: .horizontal)
        XCTAssertNotEqual(a, b)
    }
}
