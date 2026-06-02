import SwiftUI

// MARK: - View Extensions for Gesture Modifiers

public extension View {

    /// Applies `properties` while a tap/press gesture is active.
    func whileTap(
        _ properties: [AnimatableProperty],
        inactive: [AnimatableProperty] = [],
        transition: MotionTransition = MotionTransition(timing: .spring(SpringConfiguration.stiff)),
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(WhileTapModifier(
            activeProperties: properties,
            inactiveProperties: inactive,
            transition: transition,
            onTap: action
        ))
    }

    /// Applies `properties` while the pointer hovers over this view.
    func whileHover(
        _ properties: [AnimatableProperty],
        inactive: [AnimatableProperty] = [],
        transition: MotionTransition = MotionTransition(timing: .tween(duration: 0.15))
    ) -> some View {
        modifier(WhileHoverModifier(
            activeProperties: properties,
            inactiveProperties: inactive,
            transition: transition
        ))
    }

    /// Enables drag interaction with optional motion properties during drag.
    func whileDrag(
        _ properties: [AnimatableProperty] = [],
        inactive: [AnimatableProperty] = [],
        axis: WhileDragModifier.DragAxis = .free,
        transition: MotionTransition = MotionTransition(timing: .spring(SpringConfiguration.stiff)),
        dragConstraint: CGRect? = nil,
        applyTranslation: Bool = true,
        onDragStart: ((CGSize) -> Void)? = nil,
        onDragChange: ((CGSize, CGSize) -> Void)? = nil,
        onDragEnd: ((CGSize, CGSize) -> Void)? = nil
    ) -> some View {
        modifier(WhileDragModifier(
            activeProperties: properties,
            inactiveProperties: inactive,
            transition: transition,
            axis: axis,
            dragConstraint: dragConstraint,
            applyTranslation: applyTranslation,
            onDragStart: onDragStart,
            onDragChange: onDragChange,
            onDragEnd: onDragEnd
        ))
    }

    /// Applies `properties` when a long press is recognized.
    func whileLongPress(
        _ properties: [AnimatableProperty],
        inactive: [AnimatableProperty] = [],
        minimumDuration: Double = 0.5,
        transition: MotionTransition = .default,
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(LongPressMotionModifier(
            activeProperties: properties,
            inactiveProperties: inactive,
            minimumDuration: minimumDuration,
            transition: transition,
            onLongPress: action
        ))
    }
}
