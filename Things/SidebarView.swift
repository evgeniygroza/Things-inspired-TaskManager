import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var appState: AppState
    
    let sections = [
        ("Inbox", "tray"),
        ("Today", "star"),
        ("Upcoming", "calendar"),
        ("Done", "checkmark.circle")
    ]
    
    var body: some View {
        
        List {
            
            ForEach(sections, id: \.0) { section in
                
                Button {
                    
                    withAnimation(.spring()) {
                        appState.selectedSection = section.0
                    }
                    
                } label: {
                    
                    HStack(spacing: 12) {
                        
                        Image(systemName: section.1)
                            .frame(width: 16)
                        
                        Text(section.0)
                        
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(
                        appState.selectedSection == section.0
                        ? Color.blue.opacity(0.12)
                        : Color.clear
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Things")
        .listStyle(.sidebar)
    }
}
