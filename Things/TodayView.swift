import SwiftUI

struct TodayView: View {

    @EnvironmentObject var appState: AppState

    @State private var newTask = ""
    @State private var isImportant = false

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Today")
                .font(.system(size: 28, weight: .bold))

            HStack(spacing: 10) {

                TextField("New task...", text: $newTask)
                    .textFieldStyle(.roundedBorder)

                Button {
                    isImportant.toggle()
                } label: {
                    Image(systemName: isImportant ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                        .foregroundColor(isImportant ? .red : .secondary)
                }
                .buttonStyle(.plain)

                Button("Add") {

                    guard !newTask.isEmpty else { return }

                    appState.addTask(
                        title: newTask,
                        section: "Today",
                        isImportant: isImportant
                    )

                    newTask = ""
                    isImportant = false
                }
                .buttonStyle(.borderedProminent)
            }

            List {
                ForEach(appState.tasks(for: "Today")) { task in
                    TaskRow(task: task)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
}
