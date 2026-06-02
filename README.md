# swift-framer

> **Framer Motion for SwiftUI** — declarative, physics-based animations with a minimal API.

`swift-framer` brings the declarative simplicity and fluid feel of [Framer Motion](https://www.framer.com/motion/) to native SwiftUI. Springs, keyframes, gesture states, `AnimatePresence` exit animations and staggered orchestration — all with a single `.motion()` modifier.

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS 15.0+](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

---

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/avijeetpandey/swift-framer.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** and enter the repository URL.

---

## Quick Start

```swift
import SwiftUI
import FramerSwift

struct ContentView: View {
    var body: some View {
        Text("Hello, swift-framer!")
            .motion(
                initial: [.opacity(0), .y(20)],
                animate: [.opacity(1), .y(0)],
                transition: .spring(.bouncy)
            )
    }
}
```

---

## Core Concepts

### AnimatableProperty

Every visual property you can animate:

```swift
.opacity(Double)
.scale(Double)          // uniform scale
.scaleX(Double)
.scaleY(Double)
.x(Double)              // horizontal translation (pts)
.y(Double)              // vertical translation (pts)
.rotation(Double)       // degrees, around Z
.rotationX(Double)
.rotationY(Double)
.blur(Double)           // radius in pts
.brightness(Double)     // -1 to 1
.saturation(Double)
.width(Double)
.height(Double)
.cornerRadius(Double)
.foregroundColor(Color)
.clipShape(AnyShape)
```

### MotionTiming

Choose your timing curve:

```swift
.spring(.bouncy)                          // SpringConfiguration preset
.spring(.gentle)
.spring(.stiff)
.spring(mass: 1, stiffness: 200, damping: 15)
.tween(duration: 0.4)
.tween(duration: 0.3, easing: .easeInOut)
.tween(duration: 0.5, easing: .backOut)
.keyframes([...])
```

### MotionTransition

```swift
MotionTransition(
    timing: .spring(.bouncy),
    delay: 0.1,
    repeatCount: .finite(3),
    repeatDelay: 0.2
)
```

---

## .motion() Modifier

The primary API. Attach to any SwiftUI view:

```swift
// Animate on appear
myView.motion(
    initial: [.opacity(0), .scale(0.9)],
    animate: [.opacity(1), .scale(1)],
    transition: .spring(.gentle)
)

// With exit animation
myView.motion(
    initial: [.opacity(0), .y(40)],
    animate: [.opacity(1), .y(0)],
    exit:    [.opacity(0), .y(-40)],
    transition: .spring(SpringConfiguration(response: 0.4, dampingFraction: 0.8))
)

// Trigger on value change
myView.motion(
    animate: [.scale(isHighlighted ? 1.1 : 1.0)],
    transition: .spring(.stiff)
)
```

---

## AnimatePresence

Animate views *out* before they are removed from the hierarchy:

```swift
@State private var showBanner = false

AnimatePresence(isPresent: showBanner) {
    BannerView()
        .motion(
            initial: [.opacity(0), .y(-20)],
            animate: [.opacity(1), .y(0)],
            exit:    [.opacity(0), .y(-20)],
            transition: .spring(.gentle)
        )
}
```

---

## Stagger Animations

Orchestrate list entries with incremental delays:

```swift
StaggerContainer(stagger: 0.06) {
    ForEach(items) { item in
        StaggerChild {
            RowView(item: item)
                .motion(
                    initial: [.opacity(0), .x(-24)],
                    animate: [.opacity(1), .x(0)],
                    transition: .spring(.gentle)
                )
        }
    }
}
```

---

## Gesture States

### whileTap

```swift
button.whileTap([.scale(0.95), .opacity(0.8)]) {
    handleTap()
}
```

### whileHover (iPadOS pointer / macOS)

```swift
card.whileHover([.scale(1.04), .brightness(0.05)])
```

### whileDrag

```swift
card.whileDrag(
    [.scale(1.02)],
    inactive: [.scale(1.0)],
    axis: .horizontal,
    onDragEnd: { offset, velocity in
        snapBack(velocity: velocity)
    }
)
```

### whileLongPress

```swift
view.whileLongPress([.scale(0.9)], minimumDuration: 0.5) {
    handleLongPress()
}
```

---

## Loop Animations

```swift
// Infinite mirror (ping-pong)
dot.motion(animate: [.x(100)], transition: .spring(.gentle))
   .motionLoop(count: .infinite, mode: .mirror)

// Finite forward loop
icon.motion(animate: [.rotation(360)], transition: .tween(duration: 1.0))
    .motionLoop(count: .finite(3), mode: .loop)
```

---

## Variants (Named Phases)

```swift
let card = variants {
    MotionVariantState(name: "hidden",  properties: [.opacity(0), .scale(0.9), .y(20)])
    MotionVariantState(name: "visible", properties: [.opacity(1), .scale(1.0), .y(0)])
    MotionVariantState(name: "exit",    properties: [.opacity(0), .scale(0.95), .y(-20)])
}

MotionView(variantSet: card, current: "visible") {
    CardContent()
}
```

---

## Property Presets

```swift
// Built-in preset arrays
[AnimatableProperty].fadeIn       // [.opacity(0)] → [.opacity(1)]
[AnimatableProperty].slideInFromLeft
[AnimatableProperty].slideInFromRight
[AnimatableProperty].slideInFromTop
[AnimatableProperty].slideInFromBottom
[AnimatableProperty].popIn        // scale(0.8) + opacity(0) entry
```

---

## Spring Configuration

```swift
// Presets
SpringConfiguration.default    // balanced
SpringConfiguration.gentle     // slow, smooth
SpringConfiguration.stiff      // fast, tight
SpringConfiguration.wobbly     // bouncy overshoot
SpringConfiguration.slow       // overdamped
SpringConfiguration.bouncy     // strong underdamped

// Custom (using response/dampingFraction)
SpringConfiguration(response: 0.5, dampingFraction: 0.7)

// Custom (physics parameters)
SpringConfiguration(mass: 1.0, stiffness: 180, damping: 12)
```

---

## Reduced Motion

`swift-framer` automatically respects the system accessibility setting:

```swift
// Global override
.motionConfiguration(MotionConfiguration(reducedMotion: true))

// Or it reads `@Environment(\.accessibilityReduceMotion)` automatically
```

---

## Architecture

```
Sources/FramerSwift/
├── Core/
│   ├── Protocols/   — AnimationPhase, AnimatableProperty, EasingFunction, MotionVariant …
│   └── Math/        — SpringSimulator, TweenInterpolator, KeyframeSequence, ValueInterpolator
├── Engine/          — MotionViewModel, PropertyApplicator, AnyShape
├── Modifiers/       — MotionModifier, MotionStateModifier, AnimationTriggerModifier
├── Extensions/      — MotionView, MotionVariantBuilder, .motion() View extension
├── Gestures/        — WhileTapModifier, WhileDragModifier, WhileHoverModifier, LongPressMotionModifier
└── Orchestration/   — AnimatePresence, StaggerContainer, LoopModifier, MotionSequenceStep
```

---

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.9+
- Xcode 15.0+

---

## License

swift-framer is available under the MIT license.
