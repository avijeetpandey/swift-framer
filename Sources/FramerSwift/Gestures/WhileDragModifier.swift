import SwiftUI

// MARK: - WhileDragModifier

/// Tracks a drag gesture and applies `activeProperties` during the drag,
/// optionally following the translation offset for realistic physics feel.
/// Replicates Framer Motion's `drag` + `whileDrag`.
public struct WhileDragModifier: ViewModifier {

    public enum DragAxis: Sendable {
        case free, horizontal, vertical
    }

    private let activeProperties: [AnimatableProperty]
    private let inactiveProperties: [AnimatableProperty]
    private let transition: MotionTransition
    private let axis: DragAxis
    private let dragConstraint: CGRect?
    private let applyTranslation: Bool
    private let onDragStart: ((CGSize) -> Void)?
    private let onDragChange: ((CGSize, CGSize) -> Void)?
    private let onDragEnd: ((CGSize, CGSize) -> Void)?

    @StateObject private var gestureState = GestureMotionState()
    @Environment(\.motionConfiguration) private var motionConfig
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        activeProperties: [AnimatableProperty] = [],
        inactiveProperties: [AnimatableProperty] = [],
        transition: MotionTransition = MotionTransition(timing: .spring(SpringConfiguration.stiff)),
        axis: DragAxis = .free,
        dragConstraint: CGRect? = nil,
        applyTranslation: Bool = true,
        onDragStart: ((CGSize) -> Void)? = nil,
        onDragChange: ((CGSize, CGSize) -> Void)? = nil,
        onDragEnd: ((CGSize, CGSize) -> Void)? = nil
    ) {
        self.activeProperties = activeProperties
        self.inactiveProperties = inactiveProperties
        self.transition = transition
        self.axis = axis
        self.dragConstraint = dragConstraint
        self.applyTranslation = applyTranslation
        self.onDragStart = onDragStart
        self.onDragChange = onDragChange
        self.onDragEnd = onDragEnd
    }

    public func body(content: Content) -> some View {
        let shouldAnimate = !motionConfig.reducedMotion && !reduceMotion
        let animation: Animation? = shouldAnimate ? transition.timing.swiftUIAnimation : nil

        let baseOffset = applyTranslation ? gestureState.dragOffset : .zero
        let constrainedOffset = constrain(baseOffset)
        let stateProperties = gestureState.isDragging ? activeProperties : inactiveProperties
        let translationProps: [AnimatableProperty] = (applyTranslation && gestureState.isDragging)
            ? [.x(constrainedOffset.width), .y(constrainedOffset.height)]
            : []
        let allProperties = stateProperties + translationProps

        return PropertyApplicator.apply(allProperties, to: content)
            .animation(
                gestureState.isDragging ? nil : animation,
                value: gestureState.isDragging
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !gestureState.isDragging {
                            onDragStart?(value.translation)
                        }
                        gestureState.updateDrag(
                            translation: axisConstrained(value.translation),
                            location: value.location
                        )
                        onDragChange?(value.translation, gestureState.dragVelocity)
                    }
                    .onEnded { value in
                        let velocity = gestureState.dragVelocity
                        onDragEnd?(value.translation, velocity)
                        withAnimation(animation) {
                            gestureState.endDrag()
                        }
                    }
            )
    }

    private func axisConstrained(_ translation: CGSize) -> CGSize {
        switch axis {
        case .free: return translation
        case .horizontal: return CGSize(width: translation.width, height: 0)
        case .vertical: return CGSize(width: 0, height: translation.height)
        }
    }

    private func constrain(_ offset: CGSize) -> CGSize {
        guard let rect = dragConstraint else { return offset }
        return CGSize(
            width: max(rect.minX, min(rect.maxX, offset.width)),
            height: max(rect.minY, min(rect.maxY, offset.height))
        )
    }
}
