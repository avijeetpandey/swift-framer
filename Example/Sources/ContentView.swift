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
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                ScrollView {
                    switch selectedTab {
                    case .list:  StaggerListDemo()
                    case .cards: DraggableCardsDemo()
                    case .modal: ModalDemo(showModal: $showModal)
                    case .loops: LoopingAnimationsDemo()
                    }
                }
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
