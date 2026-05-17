import SwiftUI

struct InboxView: View {

    @EnvironmentObject var appState: AppState

    @State private var newTask = ""
    @State private var isImportant = false

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Inbox")
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
                        section: "Inbox",
                        isImportant: isImportant
                    )

                    newTask = ""
                    isImportant = false
                }
                .buttonStyle(.borderedProminent)
            }

            List {
                ForEach(appState.tasks(for: "Inbox")) { task in
                    TaskRow(task: task)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
}
