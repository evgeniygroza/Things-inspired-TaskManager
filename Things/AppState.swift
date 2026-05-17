import SwiftUI
import Combine

final class AppState: ObservableObject {

    @Published var selectedSection: TaskSection = .inbox

    @Published var tasks: [TaskItem] = [] {
        didSet {
            save()
        }
    }

    init() {
        load()
    }

    // MARK: - FILTER + SORT

    func tasks(for section: TaskSection) -> [TaskItem] {
        switch section {
        case .today:
            activeTasks
                .filter { $0.section == .today || isDueTodayOrEarlier($0.dueDate) }
                .sorted(by: activeSort)

        case .upcoming:
            activeTasks
                .filter { task in
                    if let dueDate = task.dueDate {
                        return isFutureDate(dueDate)
                    }

                    return task.section == .upcoming
                }
                .sorted { first, second in
                    let lhs = first.dueDate ?? Date.distantFuture
                    let rhs = second.dueDate ?? Date.distantFuture

                    if !Calendar.current.isDate(lhs, inSameDayAs: rhs) {
                        return lhs < rhs
                    }

                    return activeSort(first, second)
                }

        case .logbook:
            doneTasks

        default:
            activeTasks
                .filter { $0.section == section }
                .sorted(by: activeSort)
        }
    }

    var activeTasks: [TaskItem] {
        tasks.filter { !$0.isCompleted }
    }

    var doneTasks: [TaskItem] {
        tasks
            .filter { $0.isCompleted }
            .sorted {
                ($0.completedAt ?? $0.createdAt) > ($1.completedAt ?? $1.createdAt)
            }
    }

    func count(for section: TaskSection) -> Int {
        tasks(for: section).count
    }

    func destinationForNewTask(from section: TaskSection? = nil) -> TaskSection {
        let current = section ?? selectedSection
        return current == .logbook ? .inbox : current
    }

    func defaultDueDate(for section: TaskSection) -> Date? {
        switch section {
        case .today:
            Date()
        case .upcoming:
            Calendar.current.date(byAdding: .day, value: 1, to: Date())
        default:
            nil
        }
    }

    // MARK: - ACTIONS

    func addTask(
        title: String,
        notes: String = "",
        section: TaskSection,
        dueDate: Date? = nil,
        isImportant: Bool = false
    ) {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTitle.isEmpty else { return }

        tasks.insert(
            TaskItem(
                title: cleanTitle,
                notes: cleanNotes,
                isImportant: isImportant,
                section: section,
                dueDate: dueDate
            ),
            at: 0
        )
    }

    func toggleDone(_ task: TaskItem) {

        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            tasks[index].isCompleted.toggle()
            tasks[index].completedAt = tasks[index].isCompleted ? Date() : nil
        }
    }

    func toggleImportant(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isImportant.toggle()
    }

    func move(_ task: TaskItem, to section: TaskSection) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        withAnimation(.easeInOut(duration: 0.18)) {
            tasks[index].section = section

            if section == .today {
                tasks[index].dueDate = Date()
            } else if section == .upcoming, tasks[index].dueDate == nil {
                tasks[index].dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            }
        }
    }

    func setDueDate(_ task: TaskItem, dueDate: Date?) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].dueDate = dueDate
    }

    func delete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }

    func clearCompleted() {
        withAnimation(.easeInOut(duration: 0.2)) {
            tasks.removeAll { $0.isCompleted }
        }
    }

    // MARK: - PERSISTENCE

    private let key = "tasks_storage"

    private func save() {

        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {

        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([TaskItem].self, from: data)
        else {
            return
        }

        self.tasks = decoded
    }

    private func activeSort(_ first: TaskItem, _ second: TaskItem) -> Bool {
        if first.isImportant != second.isImportant {
            return first.isImportant && !second.isImportant
        }

        switch (first.dueDate, second.dueDate) {
        case let (lhs?, rhs?):
            if !Calendar.current.isDate(lhs, inSameDayAs: rhs) {
                return lhs < rhs
            }
        case (_?, nil):
            return true
        case (nil, _?):
            return false
        case (nil, nil):
            break
        }

        return first.createdAt > second.createdAt
    }

    private func isDueTodayOrEarlier(_ date: Date?) -> Bool {
        guard let date else { return false }
        let calendar = Calendar.current
        return calendar.startOfDay(for: date) <= calendar.startOfDay(for: Date())
    }

    private func isFutureDate(_ date: Date?) -> Bool {
        guard let date else { return false }
        let calendar = Calendar.current
        return calendar.startOfDay(for: date) > calendar.startOfDay(for: Date())
    }
}
