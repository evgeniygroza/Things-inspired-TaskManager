import SwiftUI
import Combine

final class AppState: ObservableObject {

    @Published var selectedSection = "Inbox"

    @Published var tasks: [TaskItem] = [] {
        didSet {
            save()
        }
    }

    init() {
        load()
    }

    // MARK: - FILTER + SORT

    func tasks(for section: String) -> [TaskItem] {

        tasks
            .filter { $0.section == section && !$0.isCompleted }
            .sorted { a, b in

                if a.isImportant != b.isImportant {
                    return a.isImportant && !b.isImportant
                }

                return a.createdAt > b.createdAt
            }
    }

    var doneTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }
    }

    // MARK: - ACTIONS

    func addTask(title: String, section: String, isImportant: Bool = false) {

        tasks.insert(
            TaskItem(
                title: title,
                isImportant: isImportant,
                section: section
            ),
            at: 0
        )
    }

    func toggleDone(_ task: TaskItem) {

        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            tasks[index].isCompleted.toggle()
        }
    }

    func delete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
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
}
