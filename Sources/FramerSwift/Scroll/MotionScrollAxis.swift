import Foundation

// MARK: - MotionScrollAxis

/// The axis along which a scroll-linked timeline measures progress.
///
/// A dedicated type (rather than reusing SwiftUI's `Axis`) keeps the scroll
/// engine usable from non-View contexts such as `MotionScrollProgress` value
/// snapshots and unit tests, and keeps the type `Sendable`.
public enum MotionScrollAxis: Sendable, Equatable {
    case vertical
    case horizontal
}
