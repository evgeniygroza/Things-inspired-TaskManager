import SwiftUI

@main
struct ThingsApp: App {

    @StateObject private var appState = AppState()

    var body: some Scene {

        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .tint(ThingsTheme.orange)
        }
        .windowStyle(.titleBar)
    }
}
