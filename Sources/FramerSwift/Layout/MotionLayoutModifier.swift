import SwiftUI

// MARK: - MotionLayoutModifier

/// A `ViewModifier` that provides automatic, fluid animation when a view moves
/// between two different layout positions or sizes — the SwiftUI equivalent of
/// Framer Motion's `layout` prop.
///
/// It builds on SwiftUI's `matchedGeometryEffect`: by tagging a view with a
/// stable `id` inside a shared `Namespace`, SwiftUI interpolates the view's
/// frame whenever its layout changes (reordering, insertion/removal of siblings,
/// container resizing, alignment changes). The supplied `transition` controls
/// the spring/tween feel of that interpolation.
///
/// Because it cooperates with SwiftUI's native geometry system rather than
/// fighting it, layout animations remain correct under Dynamic Type, rotation,
/// and safe-area changes.
public struct MotionLayoutModifier: ViewModifier {

    private let id: AnyHashable
    private let namespace: Namespace.ID
    private let properties: MatchedGeometryProperties
    private let anchor: UnitPoint
    private let isSource: Bool
    private let transition: MotionTransition

    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Creates a layout-animation modifier.
    ///
    /// - Parameters:
    ///   - id: A stable identity shared across layout states.
    ///   - namespace: The `Namespace.ID` linking matched views.
    ///   - properties: Which geometry properties to match. Defaults to `.frame`.
    ///   - anchor: The anchor used for interpolation. Defaults to `.center`.
    ///   - isSource: Whether this view is the geometry source. Defaults to `true`.
    ///   - transition: The motion transition driving the animation.
    public init(
        id: AnyHashable,
        namespace: Namespace.ID,
        properties: MatchedGeometryProperties = .frame,
        anchor: UnitPoint = .center,
        isSource: Bool = true,
        transition: MotionTransition = MotionTransition(timing: .spring(.gentle))
    ) {
        self.id = id
        self.namespace = namespace
        self.properties = properties
        self.anchor = anchor
        self.isSource = isSource
        self.transition = transition
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation: Animation? = shouldAnimate ? transition.timing.swiftUIAnimation : nil

        return content
            .matchedGeometryEffect(
                id: id,
                in: namespace,
                properties: properties,
                anchor: anchor,
                isSource: isSource
            )
            .animation(animation, value: AnyHashableLayoutKey(id))
    }
}

// MARK: - AnyHashableLayoutKey

/// A lightweight `Equatable` wrapper so `.animation(_:value:)` can key off the
/// matched-geometry identity without requiring the caller's id to be `Equatable`
/// at the call site (it already is via `AnyHashable`).
private struct AnyHashableLayoutKey: Equatable {
    let id: AnyHashable
    init(_ id: AnyHashable) { self.id = id }
}
