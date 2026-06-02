import SwiftUI
import FramerSwift

@main
struct FramerSwiftExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Ensure UIWindow background fills the full screen including safe areas
                    UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .flatMap { $0.windows }
                        .forEach { $0.backgroundColor = UIColor.systemBackground }
                }
        }
    }
}
