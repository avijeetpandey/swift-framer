import SwiftUI

// MARK: - AnyShape

/// Type-erased `Shape` for use with `.clipShape`.
public struct AnyShape: Shape {
    private let _path: @Sendable (CGRect) -> Path

    public init<S: Shape>(_ shape: S) {
        self._path = { rect in shape.path(in: rect) }
    }

    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
