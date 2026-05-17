import Foundation

struct TaskItem: Identifiable, Equatable, Codable {

    let id: UUID
    var title: String
    var notes: String
    var section: TaskSection

    var isImportant: Bool
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        isImportant: Bool = false,
        section: TaskSection,
        dueDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.section = section
        self.isImportant = isImportant
        self.isCompleted = false
        self.createdAt = Date()
        self.dueDate = dueDate
        self.completedAt = nil
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case notes
        case section
        case isImportant
        case isCompleted
        case createdAt
        case dueDate
        case completedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        section = try container.decodeIfPresent(TaskSection.self, forKey: .section) ?? .inbox
        isImportant = try container.decodeIfPresent(Bool.self, forKey: .isImportant) ?? false
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(notes, forKey: .notes)
        try container.encode(section, forKey: .section)
        try container.encode(isImportant, forKey: .isImportant)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encodeIfPresent(completedAt, forKey: .completedAt)
    }
}
