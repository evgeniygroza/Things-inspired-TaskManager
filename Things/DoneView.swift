import SwiftUI

struct DoneView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Done")
                .font(.largeTitle.bold())
                .padding(.top)

            if appState.doneTasks.isEmpty {
                Text("No completed tasks")
                    .foregroundColor(.secondary)
                    .padding(.top, 20)

                Spacer()
            } else {

                List {

                    ForEach(appState.doneTasks) { task in

                        HStack {

                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough()
                                    .foregroundColor(.secondary)

                                Text(task.section)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                appState.delete(task)
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
