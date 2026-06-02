import SwiftUI

// MARK: - ScrollOffsetPreferenceKey

/// A `PreferenceKey` used to propagate a scroll offset value up the view tree
/// from a `GeometryReader` background placed on scroll-linked content.
///
/// The reduce strategy keeps the most recently reported value, which is correct
/// because a single `ScrollTimelineModifier` emits exactly one offset per frame.
public struct ScrollOffsetPreferenceKey: PreferenceKey {

    public static let defaultValue: CGFloat = 0

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
