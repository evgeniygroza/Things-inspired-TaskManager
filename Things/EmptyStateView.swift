import SwiftUI

struct EmptyStateView: View {
    let section: TaskSection

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(section.accentColor.opacity(0.11))

                Image(systemName: section.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(section.accentColor)
            }
            .frame(width: 58, height: 58)

            VStack(spacing: 4) {
                Text(section.emptyTitle)
                    .font(.system(size: 18, weight: .semibold))

                Text(section.emptySubtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 320)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 64)
    }
}
