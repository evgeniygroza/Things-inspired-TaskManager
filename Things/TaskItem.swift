import Foundation

struct TaskItem: Identifiable, Equatable, Codable {

    let id: UUID
    var title: String
    var section: String

    var isImportant: Bool
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?

    init(
        title: String,
        isImportant: Bool = false,
        section: String,
        dueDate: Date? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.section = section
        self.isImportant = isImportant
        self.isCompleted = false
        self.createdAt = Date()
        self.dueDate = dueDate
    }
}
