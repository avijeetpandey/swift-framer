import SwiftUI

// MARK: - CubicBezierEasing

/// Cubic Bézier easing with configurable control points.
public struct CubicBezierEasing: EasingFunction {
    public let x1: Double
    public let y1: Double
    public let x2: Double
    public let y2: Double

    public init(x1: Double, y1: Double, x2: Double, y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

    public func evaluate(at t: Double) -> Double {
        CubicBezierSolver.solve(t: t, x1: x1, y1: y1, x2: x2, y2: y2)
    }

    public var swiftUIAnimation: Animation {
        .timingCurve(x1, y1, x2, y2)
    }

    public var estimatedDuration: Double { 0.3 }
}

// MARK: - Standard Named Curves

public extension EasingFunction where Self == CubicBezierEasing {
    static var easeIn: CubicBezierEasing {
        CubicBezierEasing(x1: 0.42, y1: 0.0, x2: 1.0, y2: 1.0)
    }
    static var easeOut: CubicBezierEasing {
        CubicBezierEasing(x1: 0.0, y1: 0.0, x2: 0.58, y2: 1.0)
    }
    static var easeInOut: CubicBezierEasing {
        CubicBezierEasing(x1: 0.42, y1: 0.0, x2: 0.58, y2: 1.0)
    }
    /// Matches Framer Motion's default "anticipate" feel.
    static var anticipate: CubicBezierEasing {
        CubicBezierEasing(x1: 0.36, y1: -0.01, x2: 0.20, y2: 1.28)
    }
    /// Framer Motion's `circIn`
    static var circIn: CubicBezierEasing {
        CubicBezierEasing(x1: 0.55, y1: 0.0, x2: 1.0, y2: 0.45)
    }
    /// Framer Motion's `circOut`
    static var circOut: CubicBezierEasing {
        CubicBezierEasing(x1: 0.0, y1: 0.55, x2: 0.45, y2: 1.0)
    }
    /// Framer Motion's `backOut` — slight overshoot on exit.
    static var backOut: CubicBezierEasing {
        CubicBezierEasing(x1: 0.34, y1: 1.56, x2: 0.64, y2: 1.0)
    }
    /// Framer Motion's `backIn`
    static var backIn: CubicBezierEasing {
        CubicBezierEasing(x1: 0.36, y1: 0.0, x2: 0.66, y2: -0.56)
    }
}

// MARK: - Cubic Bézier Solver

/// Numerically solves a cubic Bézier curve for a given x-value using
/// Newton-Raphson iteration, matching browser CSS animation precision.
internal enum CubicBezierSolver {
    private static let newtonIterations = 8
    private static let newtonMinSlope: Double = 0.001
    private static let subdivisionPrecision: Double = 1e-7
    private static let subdivisionMaxIterations = 10
    private static let kSplineTableSize = 11
    private static let kSampleStepSize: Double = 1.0 / Double(kSplineTableSize - 1)

    static func solve(t: Double, x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
        if x1 == y1 && x2 == y2 { return t }

        var sampleValues = [Double](repeating: 0, count: kSplineTableSize)
        for i in 0..<kSplineTableSize {
            sampleValues[i] = calcBezier(Double(i) * kSampleStepSize, x1, x2)
        }

        let getTForX: (Double) -> Double = { aX in
            var intervalStart = 0.0
            var currentSample = 1
            let lastSample = kSplineTableSize - 1
            while currentSample != lastSample && sampleValues[currentSample] <= aX {
                intervalStart += kSampleStepSize
                currentSample += 1
            }
            currentSample -= 1

            let dist = (aX - sampleValues[currentSample]) /
                       (sampleValues[currentSample + 1] - sampleValues[currentSample])
            let guessForT = intervalStart + dist * kSampleStepSize

            let initialSlope = getSlope(guessForT, x1, x2)
            if initialSlope >= newtonMinSlope {
                return newtonRaphsonIterate(aX, guessForT, x1, x2)
            } else if initialSlope == 0.0 {
                return guessForT
            } else {
                return binarySubdivide(aX, intervalStart, intervalStart + kSampleStepSize, x1, x2)
            }
        }

        return calcBezier(getTForX(t), y1, y2)
    }

    private static func calcBezier(_ t: Double, _ a1: Double, _ a2: Double) -> Double {
        ((a1 * 3 - a2 * 3 + 1) * t * t + (a2 * 3 - a1 * 6) * t + a1 * 3) * t
    }

    private static func getSlope(_ t: Double, _ a1: Double, _ a2: Double) -> Double {
        3.0 * (a1 * 3 - a2 * 3 + 1) * t * t + 2.0 * (a2 * 3 - a1 * 6) * t + a1 * 3
    }

    private static func newtonRaphsonIterate(
        _ aX: Double, _ aGuessT: Double, _ mX1: Double, _ mX2: Double
    ) -> Double {
        var t = aGuessT
        for _ in 0..<newtonIterations {
            let currentSlope = getSlope(t, mX1, mX2)
            if currentSlope == 0.0 { return t }
            let currentX = calcBezier(t, mX1, mX2) - aX
            t -= currentX / currentSlope
        }
        return t
    }

    private static func binarySubdivide(
        _ aX: Double, _ aA: Double, _ aB: Double, _ mX1: Double, _ mX2: Double
    ) -> Double {
        var a = aA, b = aB, t = 0.0
        for i in 0..<subdivisionMaxIterations {
            t = a + (b - a) / 2.0
            let x = calcBezier(t, mX1, mX2) - aX
            if abs(x) <= subdivisionPrecision || (b - a) / 2.0 < subdivisionPrecision { break }
            if x > 0 { b = t } else { a = t }
            _ = i
        }
        return t
    }
}
