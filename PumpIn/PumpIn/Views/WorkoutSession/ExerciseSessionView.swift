import SwiftUI

struct ExerciseSessionView: View {
    let exercise: WorkoutExercise
    let currentSet: ExerciseSet
    let onCompleteSet: (Int, Double) -> Void
    
    @State private var actualReps: String = ""
    @State private var actualWeight: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Exercise Header
            VStack(alignment: .leading, spacing: 8) {
                Text(exercise.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A38"))
                
                Text("Set \(exercise.sets.firstIndex(where: { $0.id == currentSet.id })! + 1) of \(exercise.sets.count)")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#64748B"))
            }
            
            // Target Stats
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("Target Reps")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#64748B"))
                    Text("\(currentSet.targetReps)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#1E2A38"))
                }
                
                VStack(spacing: 4) {
                    Text("Target Weight")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#64748B"))
                    Text("\(Int(currentSet.targetWeight)) kg")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#1E2A38"))
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
            
            // Actual Input
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Actual Reps")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#475569"))
                    
                    TextField("0", text: $actualReps)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Actual Weight")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#475569"))
                    
                    TextField("0", text: $actualWeight)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
            
            // Complete Set Button
            Button(action: {
                if let reps = Int(actualReps),
                   let weight = Double(actualWeight) {
                    onCompleteSet(reps, weight)
                    actualReps = ""
                    actualWeight = ""
                }
            }) {
                HStack {
                    Text("Complete Set")
                    Image(systemName: "checkmark")
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(actualReps.isEmpty || actualWeight.isEmpty ? Color(hex: "#475569") : Color(hex: "#F97316"))
                .cornerRadius(12)
            }
            .disabled(actualReps.isEmpty || actualWeight.isEmpty)
        }
        .padding(24)
        .background(Color(hex: "#F8FAFC"))
    }
}

#Preview {
    ExerciseSessionView(
        exercise: WorkoutExercise(name: "Bench Press"),
        currentSet: ExerciseSet(targetReps: 10, targetWeight: 135, restTime: 60),
        onCompleteSet: { _, _ in }
    )
} 