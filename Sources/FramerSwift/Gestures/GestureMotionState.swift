import SwiftUI

// MARK: - GestureMotionState

/// Observable state object tracking which gesture states are currently active.
@MainActor
public final class GestureMotionState: ObservableObject {
    @Published public var isTapped: Bool = false
    @Published public var isHovered: Bool = false
    @Published public var isDragging: Bool = false
    @Published public var dragOffset: CGSize = .zero
    @Published public var dragVelocity: CGSize = .zero

    private var lastDragLocation: CGPoint = .zero
    private var lastDragTime: Date = Date()

    func updateDrag(translation: CGSize, location: CGPoint) {
        let now = Date()
        let dt = now.timeIntervalSince(lastDragTime)
        if dt > 0 {
            let vx = (location.x - lastDragLocation.x) / dt
            let vy = (location.y - lastDragLocation.y) / dt
            dragVelocity = CGSize(width: vx, height: vy)
        }
        dragOffset = translation
        lastDragLocation = location
        lastDragTime = now
        isDragging = true
    }

    func endDrag() {
        isDragging = false
        dragOffset = .zero
        dragVelocity = .zero
    }
}
