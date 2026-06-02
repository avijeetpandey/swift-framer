import XCTest
@testable import FramerSwift

final class VariantSetTests: XCTestCase {

    private func makeVariantSet() -> VariantSet {
        VariantSet(variants: [
            MotionVariantState(
                phase: .initial,
                properties: [.opacity(0), .scale(0.9)],
                transition: .default
            ),
            MotionVariantState(
                phase: .animate,
                properties: [.opacity(1), .scale(1)],
                transition: MotionTransition(timing: .spring(.bouncy))
            )
        ])
    }

    func testLookupByPhase() {
        let vs = makeVariantSet()
        let variant = vs[.initial]
        XCTAssertNotNil(variant)
        XCTAssertEqual(variant?.properties.count, 2)
    }

    func testPropertiesForPhase() {
        let vs = makeVariantSet()
        let props = vs.properties(for: .animate)
        XCTAssertEqual(props.count, 2)
    }

    func testMissingPhaseReturnsEmpty() {
        let vs = makeVariantSet()
        let props = vs.properties(for: .exit)
        XCTAssertTrue(props.isEmpty)
    }

    func testTransitionForPhase() {
        let vs = makeVariantSet()
        let transition = vs.transition(for: .animate)
        if case .spring(let config) = transition.timing {
            XCTAssertEqual(config.stiffness, SpringConfiguration.bouncy.stiffness)
        } else {
            XCTFail("Expected spring timing")
        }
    }
}
