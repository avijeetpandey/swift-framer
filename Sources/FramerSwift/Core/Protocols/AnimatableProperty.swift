import SwiftUI

// MARK: - AnimatableProperty

/// Represents a single animatable property value for a view.
public enum AnimatableProperty: Hashable, Sendable {
    case opacity(Double)
    case scale(CGFloat)
    case scaleX(CGFloat)
    case scaleY(CGFloat)
    case rotation(Double)         // degrees
    case rotationX(Double)        // degrees, 3D
    case rotationY(Double)        // degrees, 3D
    case x(CGFloat)               // horizontal offset
    case y(CGFloat)               // vertical offset
    case width(CGFloat)
    case height(CGFloat)
    case blur(CGFloat)
    case brightness(Double)
    case saturation(Double)
    case cornerRadius(CGFloat)

    /// The string key used to match properties across variant states.
    public var key: String {
        switch self {
        case .opacity: return "opacity"
        case .scale: return "scale"
        case .scaleX: return "scaleX"
        case .scaleY: return "scaleY"
        case .rotation: return "rotation"
        case .rotationX: return "rotationX"
        case .rotationY: return "rotationY"
        case .x: return "x"
        case .y: return "y"
        case .width: return "width"
        case .height: return "height"
        case .blur: return "blur"
        case .brightness: return "brightness"
        case .saturation: return "saturation"
        case .cornerRadius: return "cornerRadius"
        }
    }

    /// Extracts the underlying Double value for interpolation purposes.
    public var doubleValue: Double {
        switch self {
        case .opacity(let v): return v
        case .scale(let v): return Double(v)
        case .scaleX(let v): return Double(v)
        case .scaleY(let v): return Double(v)
        case .rotation(let v): return v
        case .rotationX(let v): return v
        case .rotationY(let v): return v
        case .x(let v): return Double(v)
        case .y(let v): return Double(v)
        case .width(let v): return Double(v)
        case .height(let v): return Double(v)
        case .blur(let v): return Double(v)
        case .brightness(let v): return v
        case .saturation(let v): return v
        case .cornerRadius(let v): return Double(v)
        }
    }

    /// Creates a new property of the same type with the given interpolated value.
    public func withValue(_ value: Double) -> AnimatableProperty {
        switch self {
        case .opacity: return .opacity(value)
        case .scale: return .scale(CGFloat(value))
        case .scaleX: return .scaleX(CGFloat(value))
        case .scaleY: return .scaleY(CGFloat(value))
        case .rotation: return .rotation(value)
        case .rotationX: return .rotationX(value)
        case .rotationY: return .rotationY(value)
        case .x: return .x(CGFloat(value))
        case .y: return .y(CGFloat(value))
        case .width: return .width(CGFloat(value))
        case .height: return .height(CGFloat(value))
        case .blur: return .blur(CGFloat(value))
        case .brightness: return .brightness(value)
        case .saturation: return .saturation(value)
        case .cornerRadius: return .cornerRadius(CGFloat(value))
        }
    }
}
