import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header

            VStack(spacing: 4) {
                ForEach(TaskSection.primarySections) { section in
                    sidebarButton(for: section)
                }
            }

            VStack(alignment: .leading, spacing: 7) {
                Text("Lists")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .padding(.horizontal, 10)

                VStack(spacing: 4) {
                    ForEach(TaskSection.listSections) { section in
                        sidebarButton(for: section)
                    }
                }
            }

            Spacer(minLength: 16)

            footer
        }
        .padding(.horizontal, 16)
        .padding(.top, 26)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(ThingsTheme.sidebarBackground)
    }

    private var header: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(ThingsTheme.orange)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 28, height: 28)

            Text("Things")
                .font(.system(size: 24, weight: .bold))
        }
        .padding(.horizontal, 8)
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(appState.activeTasks.count) open")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)

            if !appState.doneTasks.isEmpty {
                Text("\(appState.doneTasks.count) completed")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 10)
    }

    private func sidebarButton(for section: TaskSection) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.16)) {
                appState.selectedSection = section
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: section.icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(section.accentColor)
                    .frame(width: 20)

                Text(section.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer(minLength: 8)

                let count = appState.count(for: section)
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.055))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(appState.selectedSection == section ? ThingsTheme.rowSelected : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}
