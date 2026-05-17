import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 248, max: 292)
        } detail: {
            TaskListView(section: appState.selectedSection)
                .id(appState.selectedSection)
        }
        .navigationTitle("")
        .frame(minWidth: 920, minHeight: 620)
        .background(ThingsTheme.contentBackground)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        appState.selectedSection = .today
                    }
                } label: {
                    Label("Today", systemImage: "sun.max")
                }
                .help("Jump to Today")
            }
        }
    }
}
