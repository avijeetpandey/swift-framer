import SwiftUI

// MARK: - PropertyApplicator

/// Applies a set of `AnimatableProperty` values to a SwiftUI `View`,
/// producing a fully decorated `AnyView`. This is the rendering bridge
/// between the animation engine and SwiftUI's layout system.
public struct PropertyApplicator {

    /// Applies all `properties` to `view` and returns the decorated view.
    @ViewBuilder
    public static func apply(
        _ properties: [AnimatableProperty],
        to view: some View
    ) -> some View {
        let resolved = resolve(properties)
        view
            .opacity(resolved.opacity)
            .scaleEffect(
                x: resolved.scaleX,
                y: resolved.scaleY
            )
            .rotationEffect(.degrees(resolved.rotation))
            .rotation3DEffect(
                .degrees(resolved.rotationX),
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(resolved.rotationY),
                axis: (x: 0, y: 1, z: 0)
            )
            .offset(x: resolved.x, y: resolved.y)
            .blur(radius: resolved.blur)
            .brightness(resolved.brightness)
            .saturation(resolved.saturation)
            .clipShape(resolved.cornerRadius > 0
                ? AnyShape(RoundedRectangle(cornerRadius: resolved.cornerRadius))
                : AnyShape(Rectangle())
            )
    }

    // MARK: - Resolved Values

    /// Resolved, flat representation of all animated properties.
    public struct ResolvedValues {
        public var opacity: Double = 1.0
        public var scaleX: CGFloat = 1.0
        public var scaleY: CGFloat = 1.0
        public var rotation: Double = 0.0
        public var rotationX: Double = 0.0
        public var rotationY: Double = 0.0
        public var x: CGFloat = 0.0
        public var y: CGFloat = 0.0
        public var width: CGFloat? = nil
        public var height: CGFloat? = nil
        public var blur: CGFloat = 0.0
        public var brightness: Double = 0.0
        public var saturation: Double = 1.0
        public var cornerRadius: CGFloat = 0.0
    }

    /// Resolves an array of `AnimatableProperty` into a flat `ResolvedValues` struct.
    public static func resolve(_ properties: [AnimatableProperty]) -> ResolvedValues {
        var resolved = ResolvedValues()
        for property in properties {
            switch property {
            case .opacity(let v): resolved.opacity = v
            case .scale(let v): resolved.scaleX = v; resolved.scaleY = v
            case .scaleX(let v): resolved.scaleX = v
            case .scaleY(let v): resolved.scaleY = v
            case .rotation(let v): resolved.rotation = v
            case .rotationX(let v): resolved.rotationX = v
            case .rotationY(let v): resolved.rotationY = v
            case .x(let v): resolved.x = v
            case .y(let v): resolved.y = v
            case .width(let v): resolved.width = v
            case .height(let v): resolved.height = v
            case .blur(let v): resolved.blur = v
            case .brightness(let v): resolved.brightness = v
            case .saturation(let v): resolved.saturation = v
            case .cornerRadius(let v): resolved.cornerRadius = v
            }
        }
        return resolved
    }
}


