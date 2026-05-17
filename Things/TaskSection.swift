import SwiftUI

enum TaskSection: String, CaseIterable, Codable, Identifiable {
    case inbox = "Inbox"
    case today = "Today"
    case upcoming = "Upcoming"
    case anytime = "Anytime"
    case someday = "Someday"
    case logbook = "Logbook"

    var id: String { rawValue }

    static var primarySections: [TaskSection] {
        [.inbox, .today, .upcoming]
    }

    static var listSections: [TaskSection] {
        [.anytime, .someday, .logbook]
    }

    static var taskDestinations: [TaskSection] {
        [.inbox, .today, .upcoming, .anytime, .someday]
    }

    var title: String { rawValue }

    var icon: String {
        switch self {
        case .inbox:
            "tray"
        case .today:
            "sun.max"
        case .upcoming:
            "calendar"
        case .anytime:
            "archivebox"
        case .someday:
            "moon"
        case .logbook:
            "checkmark.circle"
        }
    }

    var accentColor: Color {
        switch self {
        case .inbox:
            Color(red: 0.10, green: 0.47, blue: 0.95)
        case .today:
            Color(red: 0.95, green: 0.54, blue: 0.11)
        case .upcoming:
            Color(red: 0.47, green: 0.32, blue: 0.86)
        case .anytime:
            Color(red: 0.13, green: 0.62, blue: 0.47)
        case .someday:
            Color(red: 0.44, green: 0.49, blue: 0.57)
        case .logbook:
            Color(red: 0.20, green: 0.67, blue: 0.35)
        }
    }

    var emptyTitle: String {
        switch self {
        case .inbox:
            "Inbox is clear"
        case .today:
            "Nothing planned for today"
        case .upcoming:
            "No upcoming tasks"
        case .anytime:
            "No anytime tasks"
        case .someday:
            "No someday tasks"
        case .logbook:
            "No completed tasks yet"
        }
    }

    var emptySubtitle: String {
        switch self {
        case .inbox:
            "Capture loose tasks here before deciding when they belong."
        case .today:
            "Add the next thing you want to finish before the day ends."
        case .upcoming:
            "Schedule tasks with future dates and they will appear here."
        case .anytime:
            "Keep flexible tasks here when they do not need a date."
        case .someday:
            "Park ideas that should stay visible without pressuring today."
        case .logbook:
            "Completed tasks move here with their original list and date."
        }
    }

    var allowsQuickEntry: Bool {
        self != .logbook
    }
}
