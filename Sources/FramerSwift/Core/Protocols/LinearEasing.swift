import SwiftUI

// MARK: - LinearEasing

/// Linear interpolation — constant rate of change.
public struct LinearEasing: EasingFunction {
    public init() {}

    public func evaluate(at t: Double) -> Double { t }

    public var swiftUIAnimation: Animation { .linear }
    public var estimatedDuration: Double { 0.3 }
}
