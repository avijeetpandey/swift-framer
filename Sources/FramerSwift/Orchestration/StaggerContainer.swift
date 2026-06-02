import SwiftUI

// MARK: - StaggerContainer

/// Animates a collection of child views with a configurable stagger delay
/// between each element's entry animation, replicating Framer Motion's
/// `staggerChildren` transition option.
///
/// ## Usage
/// ```swift
/// StaggerContainer(staggerDelay: 0.08, delayChildren: 0.1) {
///     ForEach(items) { item in
///         ItemRow(item: item)
///             .motion(
///                 initial: [.opacity(0), .y(16)],
///                 animate: [.opacity(1), .y(0)]
///             )
///     }
/// }
/// ```
public struct StaggerContainer<Content: View>: View {

    private let staggerDelay: Double
    private let delayChildren: Double
    private let content: Content

    public init(
        staggerDelay: Double = 0.05,
        delayChildren: Double = 0.0,
        @ViewBuilder content: () -> Content
    ) {
        self.staggerDelay = staggerDelay
        self.delayChildren = delayChildren
        self.content = content()
    }

    public var body: some View {
        content
            .environment(\.motionStaggerDelay, staggerDelay)
            .environment(\.motionDelayChildren, delayChildren)
    }
}
