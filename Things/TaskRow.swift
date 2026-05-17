import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var appState: AppState
    let task: TaskItem

    @State private var isHovering = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                appState.toggleDone(task)
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(task.isCompleted ? Color.green : Color.secondary.opacity(0.55), lineWidth: 2)
                        .frame(width: 20, height: 20)

                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.green)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
            .help(task.isCompleted ? "Restore task" : "Mark complete")

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 7) {
                    Text(task.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(task.isCompleted ? .secondary : .primary)
                        .strikethrough(task.isCompleted)
                        .lineLimit(2)

                    if task.isImportant && !task.isCompleted {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.red)
                    }
                }

                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                metadata
            }

            Spacer(minLength: 16)

            HStack(spacing: 4) {
                Button {
                    appState.toggleImportant(task)
                } label: {
                    Image(systemName: task.isImportant ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(task.isImportant ? Color.red : Color.secondary.opacity(0.7))
                }
                .buttonStyle(.plain)
                .opacity(isHovering || task.isImportant ? 1 : 0)
                .help("Toggle important")

                Menu {
                    taskMenu
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 20, height: 20)
                }
                .menuStyle(.borderlessButton)
                .opacity(isHovering ? 1 : 0)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovering ? ThingsTheme.rowHover : Color.clear)
        )
        .opacity(task.isCompleted ? 0.66 : 1.0)
        .onHover { isHovering = $0 }
        .animation(.easeInOut(duration: 0.16), value: task.isCompleted)
        .animation(.easeInOut(duration: 0.12), value: isHovering)
    }

    @ViewBuilder
    private var metadata: some View {
        HStack(spacing: 6) {
            if let dueDate = task.dueDate {
                CapsuleChip(dateTitle(for: dueDate), icon: "calendar", color: dueColor(for: dueDate))
            }

            if task.isCompleted {
                CapsuleChip(task.section.title, icon: task.section.icon, color: task.section.accentColor)

                if let completedAt = task.completedAt {
                    CapsuleChip("Done \(dateTitle(for: completedAt))", icon: "checkmark", color: .green)
                }
            } else if task.section != appState.selectedSection {
                CapsuleChip(task.section.title, icon: task.section.icon, color: task.section.accentColor)
            }
        }
    }

    @ViewBuilder
    private var taskMenu: some View {
        Button(task.isCompleted ? "Restore" : "Mark Complete") {
            appState.toggleDone(task)
        }

        Button(task.isImportant ? "Clear Important" : "Mark Important") {
            appState.toggleImportant(task)
        }

        Menu("Move To") {
            ForEach(TaskSection.taskDestinations) { section in
                Button(section.title) {
                    appState.move(task, to: section)
                }
            }
        }

        Divider()

        Button(role: .destructive) {
            appState.delete(task)
        } label: {
            Text("Delete")
        }
    }

    private func dateTitle(for date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Today"
        }

        if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }

        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        return date.formatted(.dateTime.month(.abbreviated).day())
    }

    private func dueColor(for date: Date) -> Color {
        let calendar = Calendar.current

        if calendar.startOfDay(for: date) < calendar.startOfDay(for: Date()) {
            return .red
        }

        if calendar.isDateInToday(date) {
            return ThingsTheme.orange
        }

        return .secondary
    }
}
