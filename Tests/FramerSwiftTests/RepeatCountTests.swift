import XCTest
@testable import FramerSwift

final class RepeatCountTests: XCTestCase {

    func testNoneIsNotInfinite() {
        XCTAssertFalse(RepeatCount.none.isInfinite)
    }

    func testInfinityIsInfinite() {
        XCTAssertTrue(RepeatCount.infinity.isInfinite)
    }

    func testTimesIsNotInfinite() {
        XCTAssertFalse(RepeatCount.times(3).isInfinite)
    }

    func testNoneSwiftUICount() {
        XCTAssertNil(RepeatCount.none.swiftUIRepeatCount)
    }

    func testTimesSwiftUICount() {
        XCTAssertEqual(RepeatCount.times(5).swiftUIRepeatCount, 5)
    }
}
