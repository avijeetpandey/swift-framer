import CoreGraphics

// MARK: - MotionScrollProgress

/// A snapshot of a scroll-linked timeline at a single moment.
///
/// `offset` is the raw position of the tracked view within the scroll
/// container's coordinate space (its leading edge along the scroll axis).
/// `progress` is that offset normalized into `0...1` across the configured
/// travel window, ready to drive animations.
public struct MotionScrollProgress: Equatable, Sendable {

    /// The raw leading-edge position of the view in the container's coordinate
    /// space along the active axis (in points).
    public let offset: CGFloat

    /// The normalized scroll progress in `0...1` across the configured window.
    public let progress: Double

    /// The axis along which progress was measured.
    public let axis: MotionScrollAxis

    public init(offset: CGFloat, progress: Double, axis: MotionScrollAxis) {
        self.offset = offset
        self.progress = progress
        self.axis = axis
    }

    /// Normalizes a raw scroll `offset` into `0...1` progress across the travel
    /// window `[start, start - distance]`. Guards against a zero-width window.
    ///
    /// Exposed as a pure function so scroll-timeline math is unit testable
    /// independently of SwiftUI's geometry system.
    public static func normalizedProgress(
        offset: CGFloat,
        start: CGFloat,
        distance: CGFloat
    ) -> Double {
        let safeDistance: CGFloat
        if abs(distance) < 0.0001 {
            safeDistance = distance < 0 ? -0.0001 : 0.0001
        } else {
            safeDistance = distance
        }
        let raw = Double(start - offset) / Double(safeDistance)
        return ValueInterpolator.clamp(raw, min: 0, max: 1)
    }
}
