import SwiftUI

struct AddExerciseSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var exerciseName = ""
    @State private var sets = 3
    @State private var reps = 10
    @State private var weight: Double = 0
    
    let onAdd: (Exercise) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Exercise Name", text: $exerciseName)
                
                Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                Stepper("Reps: \(reps)", value: $reps, in: 1...100)
                
                HStack {
                    Text("Weight (kg):")
                    TextField("Weight", value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    let exercise = Exercise(
                        name: exerciseName,
                        sets: sets,
                        reps: reps,
                        weight: weight
                    )
                    onAdd(exercise)
                    dismiss()
                }
                .disabled(exerciseName.isEmpty)
            )
        }
    }
}

#Preview {
    AddExerciseSheet { _ in }
} 