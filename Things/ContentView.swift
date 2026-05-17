import SwiftUI

struct ContentView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {

        NavigationView {

            HStack(spacing: 0) {

                sidebar

                Divider()

                mainContent
            }
        }
    }

    // MARK: - SIDEBAR

    var sidebar: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Things")
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 10)

            ForEach([
                ("Inbox", "tray"),
                ("Today", "sun.max"),
                ("Upcoming", "calendar"),
                ("Done", "checkmark.circle")
            ], id: \.0) { item in

                Button {

                    withAnimation(.easeInOut(duration: 0.15)) {
                        appState.selectedSection = item.0
                    }

                } label: {

                    HStack(spacing: 8) {

                        Image(systemName: item.1)
                            .frame(width: 14)

                        Text(item.0)
                            .font(.system(size: 13, weight: .medium))

                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(
                        appState.selectedSection == item.0
                        ? Color.blue.opacity(0.12)
                        : Color.clear
                    )
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding()
        .frame(width: 200)
        .background(Color(NSColor.controlBackgroundColor))
    }

    // MARK: - MAIN CONTENT

    @ViewBuilder
    var mainContent: some View {

        switch appState.selectedSection {

        case "Inbox":
            InboxView()

        case "Today":
            TodayView()

        case "Upcoming":
            UpcomingView()

        case "Done":
            DoneView()

        default:
            InboxView()
        }
    }
}
