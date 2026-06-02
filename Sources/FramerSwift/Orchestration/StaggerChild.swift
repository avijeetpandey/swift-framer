import SwiftUI

// MARK: - StaggerChild

/// Wraps a single child within a `StaggerContainer`, applying its calculated
/// stagger delay via the environment.
///
/// ## Usage
/// ```swift
/// StaggerContainer(staggerDelay: 0.06) {
///     ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
///         StaggerChild(index: index) {
///             ItemRow(item: item)
///                 .motion(initial: [.opacity(0)], animate: [.opacity(1)])
///         }
///     }
/// }
/// ```
public struct StaggerChild<Content: View>: View {
    private let index: Int
    private let content: Content

    @Environment(\.motionStaggerDelay) private var staggerDelay
    @Environment(\.motionDelayChildren) private var delayChildren

    public init(index: Int, @ViewBuilder content: () -> Content) {
        self.index = index
        self.content = content()
    }

    public var body: some View {
        content
            .environment(\.motionStaggerIndex, index)
            .environment(\.motionExtraDelay, delayChildren + Double(index) * staggerDelay)
    }
}
