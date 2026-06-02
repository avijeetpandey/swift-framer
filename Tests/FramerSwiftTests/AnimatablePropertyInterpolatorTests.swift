import XCTest
@testable import FramerSwift

final class AnimatablePropertyInterpolatorTests: XCTestCase {

    func testInterpolateOpacityHalfway() {
        let from = AnimatableProperty.opacity(0)
        let to = AnimatableProperty.opacity(1)
        let result = AnimatablePropertyInterpolator.interpolate(
            from: from, to: to, t: 0.5, easing: LinearEasing()
        )
        XCTAssertEqual(result.doubleValue, 0.5, accuracy: 0.01)
    }

    func testInterpolateMismatchedTypesReturnFrom() {
        let from = AnimatableProperty.opacity(0)
        let to = AnimatableProperty.scale(2)
        let result = AnimatablePropertyInterpolator.interpolate(from: from, to: to, t: 0.5)
        XCTAssertEqual(result.key, "opacity")
    }

    func testInterpolateAllMatchesCount() {
        let from: [AnimatableProperty] = [.opacity(0), .scale(0.8)]
        let to: [AnimatableProperty] = [.opacity(1), .scale(1.0)]
        let result = AnimatablePropertyInterpolator.interpolateAll(
            from: from, to: to, t: 0.5, easing: LinearEasing()
        )
        XCTAssertEqual(result.count, 2)
    }

    func testInterpolateAllAtZeroMatchesFrom() {
        let from: [AnimatableProperty] = [.opacity(0.2), .x(50)]
        let to: [AnimatableProperty] = [.opacity(0.8), .x(100)]
        let result = AnimatablePropertyInterpolator.interpolateAll(
            from: from, to: to, t: 0, easing: LinearEasing()
        )
        XCTAssertEqual(result[0].doubleValue, 0.2, accuracy: 0.01)
        XCTAssertEqual(result[1].doubleValue, 50.0, accuracy: 0.01)
    }
}
