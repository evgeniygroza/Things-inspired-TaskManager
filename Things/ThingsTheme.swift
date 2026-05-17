import SwiftUI

enum ThingsTheme {
    static let sidebarBackground = Color(red: 0.957, green: 0.957, blue: 0.945)
    static let contentBackground = Color(red: 0.992, green: 0.992, blue: 0.984)
    static let rowHover = Color.black.opacity(0.035)
    static let rowSelected = Color(red: 0.90, green: 0.94, blue: 1.0)
    static let hairline = Color.black.opacity(0.08)
    static let orange = Color(red: 0.94, green: 0.46, blue: 0.10)
    static let mutedText = Color.secondary.opacity(0.86)

    static func chipBackground(for section: TaskSection) -> Color {
        section.accentColor.opacity(0.11)
    }
}

struct CapsuleChip: View {
    let title: String
    let icon: String?
    let color: Color

    init(_ title: String, icon: String? = nil, color: Color = .secondary) {
        self.title = title
        self.icon = icon
        self.color = color
    }

    var body: some View {
        HStack(spacing: 5) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
            }

            Text(title)
                .font(.system(size: 11, weight: .medium))
                .lineLimit(1)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.11))
        .clipShape(Capsule())
    }
}
