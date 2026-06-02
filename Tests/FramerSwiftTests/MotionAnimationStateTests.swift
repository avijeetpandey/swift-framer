import XCTest
@testable import FramerSwift

final class MotionAnimationStateTests: XCTestCase {

    func testInitialPhaseIsCorrect() {
        let state = MotionAnimationState(initialPhase: .initial)
        XCTAssertEqual(state.phase, .initial)
    }

    func testTransitionChangesPhase() {
        let state = MotionAnimationState()
        state.transition(to: .animate)
        XCTAssertEqual(state.phase, .animate)
    }

    func testTransitionToSamePhaseIsNoop() {
        let state = MotionAnimationState()
        state.transition(to: .animate)
        state.transition(to: .animate)
        XCTAssertEqual(state.phase, .animate)
    }

    func testResetRestoresInitial() {
        let state = MotionAnimationState()
        state.transition(to: .animate)
        state.reset()
        XCTAssertEqual(state.phase, .initial)
    }

    func testIsAnimatingOnlyInAnimatePhase() {
        let state = MotionAnimationState()
        XCTAssertFalse(state.isAnimating)
        state.transition(to: .animate)
        XCTAssertTrue(state.isAnimating)
        state.transition(to: .exit)
        XCTAssertFalse(state.isAnimating)
    }
}
