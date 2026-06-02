import XCTest
import CoreGraphics
@testable import FramerSwift

final class CarouselSnapCalculatorTests: XCTestCase {

    private let calc = CarouselSnapCalculator(velocityThreshold: 300)

    func testStaysOnPageWithSmallDrag() {
        let i = calc.destinationIndex(currentIndex: 1, translation: -10, velocity: 0, step: 300, count: 5)
        XCTAssertEqual(i, 1)
    }

    func testAdvancesWhenDraggedPastHalf() {
        let i = calc.destinationIndex(currentIndex: 1, translation: -200, velocity: 0, step: 300, count: 5)
        XCTAssertEqual(i, 2)
    }

    func testGoesBackWhenDraggedRight() {
        let i = calc.destinationIndex(currentIndex: 2, translation: 200, velocity: 0, step: 300, count: 5)
        XCTAssertEqual(i, 1)
    }

    func testFlickForwardOnHighVelocity() {
        let i = calc.destinationIndex(currentIndex: 0, translation: -20, velocity: -500, step: 300, count: 5)
        XCTAssertEqual(i, 1)
    }

    func testFlickBackwardOnHighVelocity() {
        let i = calc.destinationIndex(currentIndex: 3, translation: 20, velocity: 500, step: 300, count: 5)
        XCTAssertEqual(i, 2)
    }

    func testClampsAtStart() {
        let i = calc.destinationIndex(currentIndex: 0, translation: 400, velocity: 600, step: 300, count: 5)
        XCTAssertEqual(i, 0)
    }

    func testClampsAtEnd() {
        let i = calc.destinationIndex(currentIndex: 4, translation: -400, velocity: -600, step: 300, count: 5)
        XCTAssertEqual(i, 4)
    }

    func testEmptyReturnsZero() {
        let i = calc.destinationIndex(currentIndex: 0, translation: -100, velocity: 0, step: 300, count: 0)
        XCTAssertEqual(i, 0)
    }

    func testLowVelocityDoesNotFlick() {
        let i = calc.destinationIndex(currentIndex: 1, translation: -10, velocity: 100, step: 300, count: 5)
        XCTAssertEqual(i, 1)
    }

    func testZeroStepDoesNotCrash() {
        let i = calc.destinationIndex(currentIndex: 1, translation: -100, velocity: 0, step: 0, count: 5)
        XCTAssertEqual(i, 1)
    }
}
