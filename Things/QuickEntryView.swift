import SwiftUI

struct QuickEntryView: View {
    @Binding var title: String
    @Binding var notes: String
    @Binding var destination: TaskSection
    @Binding var dueDate: Date
    @Binding var usesDueDate: Bool
    @Binding var isImportant: Bool

    let onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(ThingsTheme.orange)
                    .padding(.top, 7)

                VStack(spacing: 6) {
                    TextField("New To-Do", text: $title)
                        .textFieldStyle(.plain)
                        .font(.system(size: 16, weight: .semibold))
                        .onSubmit(onSubmit)

                    TextField("Notes", text: $notes, axis: .vertical)
                        .textFieldStyle(.plain)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(1...3)
                }

                Button(action: onSubmit) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(canSubmit ? ThingsTheme.orange : Color.secondary.opacity(0.4))
                }
                .buttonStyle(.plain)
                .disabled(!canSubmit)
                .help("Add task")
            }

            HStack(spacing: 8) {
                Picker("List", selection: $destination) {
                    ForEach(TaskSection.taskDestinations) { section in
                        Label(section.title, systemImage: section.icon)
                            .tag(section)
                    }
                }
                .labelsHidden()
                .frame(width: 138)

                Button {
                    withAnimation(.easeInOut(duration: 0.12)) {
                        isImportant.toggle()
                    }
                } label: {
                    Label("Important", systemImage: isImportant ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(isImportant ? Color.red : Color.secondary)
                }
                .buttonStyle(.borderless)
                .help("Mark important")

                Button {
                    withAnimation(.easeInOut(duration: 0.12)) {
                        usesDueDate.toggle()
                    }
                } label: {
                    Label("Date", systemImage: usesDueDate ? "calendar.badge.clock" : "calendar")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(usesDueDate ? ThingsTheme.orange : Color.secondary)
                }
                .buttonStyle(.borderless)
                .help("Schedule")

                if usesDueDate {
                    DatePicker("", selection: $dueDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .frame(width: 130)
                }

                Spacer()
            }
            .padding(.leading, 32)
        }
        .padding(14)
        .background(.white.opacity(0.76))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ThingsTheme.hairline, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var canSubmit: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
