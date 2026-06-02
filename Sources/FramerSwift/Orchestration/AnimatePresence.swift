import SwiftUI
import Combine

// MARK: - AnimatePresence

/// Replicates Framer Motion's `AnimatePresence` component: gracefully animates
/// child views out of the hierarchy rather than removing them instantly.
///
/// Wrap any conditionally-shown content in `AnimatePresence` and give the
/// inner view an `exit` state. FramerSwift will hold the view in the hierarchy,
/// play its exit animation, then remove it.
///
/// ## Usage
/// ```swift
/// AnimatePresence(isPresent: showCard) {
///     CardView()
///         .motion(
///             initial: [.opacity(0), .y(20)],
///             animate: [.opacity(1), .y(0)],
///             exit:    [.opacity(0), .y(-20)]
///         )
/// }
/// ```
public struct AnimatePresence<Content: View>: View {

    // MARK: Public API

    /// Controls whether the content is present. Setting to `false` triggers
    /// the exit animation before removal.
    public let isPresent: Bool

    /// Optional mode controlling how multiple children coexist during transitions.
    public let mode: AnimatePresenceMode

    private let content: () -> Content

    // MARK: Internal State

    @StateObject private var coordinator = AnimatePresenceCoordinator()
    @Environment(\.motionConfiguration) private var motionConfig

    public init(
        isPresent: Bool,
        mode: AnimatePresenceMode = .sync,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isPresent = isPresent
        self.mode = mode
        self.content = content
    }

    public var body: some View {
        Group {
            if coordinator.isVisible {
                content()
                    .environment(\.motionPresenceCoordinator, coordinator)
                    .onAppear {
                        coordinator.didAppear()
                    }
            }
        }
        .onChange(of: isPresent) { newValue in
            if newValue {
                coordinator.show(motionConfig: motionConfig)
            } else {
                coordinator.hide(motionConfig: motionConfig)
            }
        }
        .onAppear {
            if isPresent {
                coordinator.show(motionConfig: motionConfig)
            }
        }
    }
}

// MARK: - AnimatePresenceCoordinator

/// Internal observable that manages the presence lifecycle for a single
/// `AnimatePresence` child. Coordinates the "hold in hierarchy → animate out → remove" flow.
public final class AnimatePresenceCoordinator: ObservableObject {

    @Published public private(set) var isVisible: Bool = false
    @Published public private(set) var exitPhase: Bool = false

    /// Callback triggered when exit animation completes so the view can be removed.
    var onExitComplete: (() -> Void)?

    private var exitWorkItem: DispatchWorkItem?

    func show(motionConfig: MotionConfiguration) {
        exitWorkItem?.cancel()
        exitPhase = false
        isVisible = true
    }

    func hide(motionConfig: MotionConfiguration) {
        guard isVisible else { return }

        if motionConfig.reducedMotion {
            isVisible = false
            return
        }

        exitPhase = true

        // Schedule removal after expected exit duration.
        // The actual duration is provided via `notifyExitDuration(_:)`.
        scheduleRemoval(after: 0.5)
    }

    func notifyExitDuration(_ duration: Double) {
        exitWorkItem?.cancel()
        scheduleRemoval(after: duration + 0.05)
    }

    func didAppear() {
        exitPhase = false
    }

    private func scheduleRemoval(after delay: Double) {
        exitWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.isVisible = false
            self?.exitPhase = false
            self?.onExitComplete?()
        }
        exitWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }
}
