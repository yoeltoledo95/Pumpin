import SwiftUI

struct WorkoutSummaryView: View {
    let completedExercises: [CompletedExercise]
    let onFinish: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Workout Complete!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A38"))
                
                Text("Great job! Here's your workout summary")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#64748B"))
            }
            .padding(.top, 24)
            
            // Exercise Summary
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(completedExercises) { exercise in
                        VStack(spacing: 16) {
                            // Exercise Header
                            HStack {
                                Text(exercise.name)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1E2A38"))
                                
                                Spacer()
                                
                                Text("\(exercise.completedSets.count) sets")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#64748B"))
                            }
                            
                            // Sets
                            VStack(spacing: 12) {
                                ForEach(exercise.completedSets) { set in
                                    HStack(spacing: 24) {
                                        Text("Set \(set.setNumber)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(hex: "#475569"))
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 8) {
                                            Image(systemName: "arrow.triangle.2.circlepath")
                                            Text("\(set.actualReps)/\(set.targetReps)")
                                        }
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#64748B"))
                                        
                                        HStack(spacing: 8) {
                                            Image(systemName: "scalemass.fill")
                                            Text("\(Int(set.actualWeight))/\(Int(set.targetWeight)) kg")
                                        }
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#64748B"))
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Finish Button
            Button(action: onFinish) {
                HStack {
                    Text("Finish Workout")
                    Image(systemName: "checkmark")
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "#22C55E"))
                .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color(hex: "#F8FAFC"))
    }
}

#Preview {
    WorkoutSummaryView(
        completedExercises: [
            CompletedExercise(
                name: "Bench Press",
                completedSets: [
                    CompletedSet(
                        setNumber: 1,
                        targetReps: 10,
                        targetWeight: 135,
                        actualReps: 12,
                        actualWeight: 145
                    ),
                    CompletedSet(
                        setNumber: 2,
                        targetReps: 10,
                        targetWeight: 135,
                        actualReps: 10,
                        actualWeight: 135
                    )
                ]
            ),
            CompletedExercise(
                name: "Incline Dumbbell Press",
                completedSets: [
                    CompletedSet(
                        setNumber: 1,
                        targetReps: 12,
                        targetWeight: 65,
                        actualReps: 12,
                        actualWeight: 65
                    )
                ]
            )
        ],
        onFinish: {}
    )
} 