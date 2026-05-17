import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var appState: AppState

    let section: TaskSection

    @State private var draftTitle = ""
    @State private var draftNotes = ""
    @State private var draftDestination: TaskSection = .inbox
    @State private var draftDueDate = Date()
    @State private var draftUsesDueDate = false
    @State private var draftIsImportant = false

    private var visibleTasks: [TaskItem] {
        appState.tasks(for: section)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    if section.allowsQuickEntry {
                        QuickEntryView(
                            title: $draftTitle,
                            notes: $draftNotes,
                            destination: $draftDestination,
                            dueDate: $draftDueDate,
                            usesDueDate: $draftUsesDueDate,
                            isImportant: $draftIsImportant,
                            onSubmit: addDraft
                        )
                    }

                    if visibleTasks.isEmpty {
                        EmptyStateView(section: section)
                    } else {
                        taskContent
                    }
                }
                .padding(.horizontal, 34)
                .padding(.bottom, 34)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(ThingsTheme.contentBackground)
        .onAppear {
            resetDraft(for: section)
        }
        .onChange(of: section) { _, newSection in
            resetDraft(for: newSection)
        }
        .onChange(of: draftDestination) { _, newDestination in
            applyDefaultDate(for: newDestination)
        }
    }

    private var header: some View {
        HStack(alignment: .bottom, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Image(systemName: section.icon)
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundStyle(section.accentColor)

                    Text(section.title)
                        .font(.system(size: 34, weight: .bold))
                        .tracking(0)
                }

                Text(headerSubtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if section == .logbook, !appState.doneTasks.isEmpty {
                Button(role: .destructive) {
                    appState.clearCompleted()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(.horizontal, 34)
        .padding(.top, 30)
        .padding(.bottom, 20)
    }

    @ViewBuilder
    private var taskContent: some View {
        if section == .upcoming {
            groupedTaskContent(using: upcomingGroups)
        } else if section == .logbook {
            groupedTaskContent(using: logbookGroups)
        } else {
            VStack(alignment: .leading, spacing: 3) {
                ForEach(visibleTasks) { task in
                    TaskRow(task: task)
                }
            }
        }
    }

    private func groupedTaskContent(using groups: [(Date, [TaskItem])]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(groups, id: \.0) { group in
                VStack(alignment: .leading, spacing: 5) {
                    Text(sectionTitle(for: group.0))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .padding(.horizontal, 12)

                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(group.1) { task in
                            TaskRow(task: task)
                        }
                    }
                }
            }
        }
    }

    private var headerSubtitle: String {
        let count = visibleTasks.count

        if section == .logbook {
            return count == 1 ? "1 completed task" : "\(count) completed tasks"
        }

        let date = Date().formatted(.dateTime.weekday(.wide).month(.wide).day())
        let taskWord = count == 1 ? "task" : "tasks"
        return "\(date) - \(count) open \(taskWord)"
    }

    private var upcomingGroups: [(Date, [TaskItem])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: visibleTasks) { task in
            guard let dueDate = task.dueDate else {
                return Date.distantFuture
            }

            return calendar.startOfDay(for: dueDate)
        }

        return grouped.sorted { $0.key < $1.key }
    }

    private var logbookGroups: [(Date, [TaskItem])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: visibleTasks) { task in
            calendar.startOfDay(for: task.completedAt ?? task.createdAt)
        }

        return grouped.sorted { $0.key > $1.key }
    }

    private func addDraft() {
        let dueDate = draftUsesDueDate ? draftDueDate : appState.defaultDueDate(for: draftDestination)

        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            appState.addTask(
                title: draftTitle,
                notes: draftNotes,
                section: draftDestination,
                dueDate: dueDate,
                isImportant: draftIsImportant
            )
        }

        draftTitle = ""
        draftNotes = ""
        draftIsImportant = false
    }

    private func resetDraft(for section: TaskSection) {
        draftDestination = appState.destinationForNewTask(from: section)
        draftIsImportant = false
        draftTitle = ""
        draftNotes = ""
        applyDefaultDate(for: draftDestination)
    }

    private func applyDefaultDate(for section: TaskSection) {
        if let defaultDate = appState.defaultDueDate(for: section) {
            draftDueDate = defaultDate
            draftUsesDueDate = true
        } else if !draftUsesDueDate {
            draftDueDate = Date()
        }
    }

    private func sectionTitle(for date: Date) -> String {
        let calendar = Calendar.current

        if date == Date.distantFuture {
            return "No Date"
        }

        if calendar.isDateInToday(date) {
            return "Today"
        }

        if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }

        return date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    }
}
