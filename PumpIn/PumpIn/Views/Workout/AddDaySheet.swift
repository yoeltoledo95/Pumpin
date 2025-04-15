import SwiftUI

struct AddDaySheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var newDayName: String
    let onAdd: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Day Name", text: $newDayName)
            }
            .navigationTitle("Add Workout Day")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    if !newDayName.isEmpty {
                        onAdd(newDayName)
                        newDayName = ""
                        dismiss()
                    }
                }
                .disabled(newDayName.isEmpty)
            )
        }
    }
}

#Preview {
    AddDaySheet(
        newDayName: .constant(""),
        onAdd: { _ in }
    )
} 