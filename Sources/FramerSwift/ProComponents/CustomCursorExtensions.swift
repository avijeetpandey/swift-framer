import SwiftUI

// MARK: - Custom Cursor View Extensions

public extension View {

    /// Applies a magnetic custom-cursor effect on pointer-capable devices.
    ///
    /// ```swift
    /// Button("Open") { }
    ///     .customCursor(magneticScale: 1.1) { state in
    ///         // react to .idle / .active / .magnetic
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - magneticScale: Scale applied while the pointer engages. Defaults to `1.08`.
    ///   - lift: Upward offset while magnetic. Defaults to `4`.
    ///   - hoverEffect: The native pointer effect. Defaults to `.automatic`.
    ///   - transition: The transition driving state changes.
    ///   - onStateChange: Optional callback for cursor-state transitions.
    func customCursor(
        magneticScale: CGFloat = 1.08,
        lift: CGFloat = 4,
        hoverEffect: CustomCursorModifier.HoverEffect = .automatic,
        transition: MotionTransition = MotionTransition(timing: .spring(.gentle)),
        onStateChange: ((CursorState) -> Void)? = nil
    ) -> some View {
        modifier(
            CustomCursorModifier(
                magneticScale: magneticScale,
                lift: lift,
                hoverEffect: hoverEffect,
                transition: transition,
                onStateChange: onStateChange
            )
        )
    }
}
