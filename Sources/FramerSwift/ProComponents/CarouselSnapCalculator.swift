import CoreGraphics

// MARK: - CarouselSnapCalculator

/// Pure, deterministic snapping math for `MotionCarousel`, extracted so paging
/// behavior is fully unit testable without instantiating SwiftUI views.
///
/// Given the current page, a drag translation, the release velocity, and the
/// per-page step, it computes the destination page — flicking to a neighbor when
/// velocity exceeds the threshold, otherwise snapping to the nearest page —
/// always clamped to valid bounds.
public struct CarouselSnapCalculator: Sendable {

    public let velocityThreshold: CGFloat

    public init(velocityThreshold: CGFloat = 300) {
        self.velocityThreshold = velocityThreshold
    }

    /// Computes the destination page index.
    ///
    /// - Parameters:
    ///   - currentIndex: The page index at drag start.
    ///   - translation: Horizontal drag translation (negative = leftward).
    ///   - velocity: Release velocity in points/second (negative = leftward).
    ///   - step: The width of one page plus inter-page spacing.
    ///   - count: Total number of pages.
    /// - Returns: The clamped destination index in `0..<count`.
    public func destinationIndex(
        currentIndex: Int,
        translation: CGFloat,
        velocity: CGFloat,
        step: CGFloat,
        count: Int
    ) -> Int {
        guard count > 0 else { return 0 }

        var newIndex = currentIndex
        if abs(velocity) > velocityThreshold {
            newIndex += velocity < 0 ? 1 : -1
        } else if step > 0 {
            let movedPages = (-translation / step).rounded()
            newIndex += Int(movedPages)
        }

        return min(max(0, newIndex), count - 1)
    }
}
