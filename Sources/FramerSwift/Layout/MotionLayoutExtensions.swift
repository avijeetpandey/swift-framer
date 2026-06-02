import SwiftUI

// MARK: - Layout Animation View Extensions

public extension View {

    /// Animates this view fluidly between layout states using a shared identity.
    ///
    /// Tag matching views across two layout configurations with the same `id`
    /// and `namespace`; SwiftUI interpolates the frame when the layout changes:
    ///
    /// ```swift
    /// @Namespace private var ns
    /// // ...
    /// if expanded {
    ///     Card().motionLayout(id: "card", in: ns)
    /// } else {
    ///     Card().frame(width: 80).motionLayout(id: "card", in: ns)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - id: A stable identity shared across layout states.
    ///   - namespace: The `Namespace.ID` linking matched views.
    ///   - properties: Which geometry properties to match. Defaults to `.frame`.
    ///   - anchor: The interpolation anchor. Defaults to `.center`.
    ///   - isSource: Whether this view is the geometry source. Defaults to `true`.
    ///   - transition: The motion transition driving the animation.
    func motionLayout(
        id: AnyHashable,
        in namespace: Namespace.ID,
        properties: MatchedGeometryProperties = .frame,
        anchor: UnitPoint = .center,
        isSource: Bool = true,
        transition: MotionTransition = MotionTransition(timing: .spring(.gentle))
    ) -> some View {
        modifier(
            MotionLayoutModifier(
                id: id,
                namespace: namespace,
                properties: properties,
                anchor: anchor,
                isSource: isSource,
                transition: transition
            )
        )
    }
}
