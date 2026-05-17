import SwiftUI

struct TaskRow: View {

    @EnvironmentObject var appState: AppState
    var task: TaskItem

    var body: some View {

        HStack(spacing: 10) {

            Button {
                appState.toggleDone(task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16))
                    .foregroundColor(task.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {

                HStack(spacing: 6) {

                    Text(task.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                        .strikethrough(task.isCompleted)

                    if task.isImportant && !task.isCompleted {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 6, height: 6)
                    }
                }

                if let date = task.dueDate {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 5)
        .contentShape(Rectangle())
        .opacity(task.isCompleted ? 0.4 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
    }
}
