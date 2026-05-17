import Foundation

struct Task: Identifiable, Equatable {
    let id: UUID
    var title: String
    var createdAt: Date
    var isDone: Bool

    init(title: String, isDone: Bool = false) {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.isDone = isDone
    }
}
