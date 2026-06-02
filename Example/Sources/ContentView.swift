import SwiftUI
import FramerSwift

// MARK: - ContentView

struct ContentView: View {
    @State private var showModal = false
    @State private var selectedTab: Tab = .list

    enum Tab: String, CaseIterable {
        case list    = "List"
        case cards   = "Cards"
        case modal   = "Modal"
        case loops   = "Loops"
        case scroll  = "Scroll"
        case text    = "Text"
        case carousel = "Carousel"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            TabChip(
                                title: tab.rawValue,
                                isSelected: selectedTab == tab
                            ) {
                                selectedTab = tab
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }

                ScrollView {
                    switch selectedTab {
                    case .list:     StaggerListDemo()
                    case .cards:    DraggableCardsDemo()
                    case .modal:    ModalDemo(showModal: $showModal)
                    case .loops:    LoopingAnimationsDemo()
                    case .scroll:   ScrollLayoutDemo()
                    case .text:     TextEffectsDemo()
                    case .carousel: CarouselTickerDemo()
                    }
                }
                .coordinateSpace(name: "appScroll")
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
            .navigationTitle("framer-swift")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
        .overlay(alignment: .bottom) {
            AnimatePresence(isPresent: showModal) {
                ModalOverlay(isPresented: $showModal)
            }
        }
    }
}

// MARK: - TabChip

struct TabChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.15))
            )
            .contentShape(Capsule())
            .whileTap([.scale(0.94)], inactive: [.scale(1)], action: action)
    }
}

// MARK: - Shared Components

struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3.bold())
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .motion(
            initial: [.opacity(0), .y(-8)],
            animate: [.opacity(1), .y(0)],
            transition: .spring(.gentle)
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
