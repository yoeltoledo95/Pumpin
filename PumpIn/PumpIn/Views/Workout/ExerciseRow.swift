import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(exercise.name)
                .font(.headline)
            HStack {
                Text("\(exercise.sets) sets")
                Text("•")
                Text("\(exercise.reps) reps")
                Text("•")
                Text("\(exercise.weight, specifier: "%.1f") kg")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ExerciseRow(exercise: Exercise(
        name: "Bench Press",
        sets: 4,
        reps: 8,
        weight: 135
    ))
} 