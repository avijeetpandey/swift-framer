import SwiftUI

// MARK: - MotionBuilder (Result Builder DSL)

/// A result builder for constructing `MotionVariantState` arrays declaratively.
@resultBuilder
public struct MotionVariantBuilder {
    public static func buildBlock(_ components: MotionVariantState...) -> [MotionVariantState] {
        components
    }

    public static func buildOptional(_ component: [MotionVariantState]?) -> [MotionVariantState] {
        component ?? []
    }

    public static func buildEither(first component: [MotionVariantState]) -> [MotionVariantState] {
        component
    }

    public static func buildEither(second component: [MotionVariantState]) -> [MotionVariantState] {
        component
    }
}

/// Creates a `VariantSet` using the `@MotionVariantBuilder` DSL.
public func variants(
    @MotionVariantBuilder builder: () -> [MotionVariantState]
) -> VariantSet {
    VariantSet(variants: builder())
}
