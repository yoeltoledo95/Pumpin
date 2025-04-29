import SwiftUI

struct WorkoutSessionView: View {
    @StateObject private var viewModel: WorkoutSessionViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutSessionViewModel(workout: workout))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isResting {
                    RestTimerView(
                        timeRemaining: viewModel.restTimeRemaining,
                        onSkip: { viewModel.skipRest() }
                    )
                } else if let currentExercise = viewModel.currentExercise {
                    ExerciseSessionView(
                        exercise: currentExercise,
                        currentSet: viewModel.currentSet,
                        onCompleteSet: { actualReps, actualWeight in
                            viewModel.completeSet(actualReps: actualReps, actualWeight: actualWeight)
                        }
                    )
                } else {
                    WorkoutSummaryView(
                        completedExercises: viewModel.completedExercises,
                        onFinish: {
                            Task {
                                await viewModel.finishWorkout()
                                dismiss()
                            }
                        }
                    )
                }
            }
            .navigationTitle("Workout Session")
            .navigationBarItems(
                leading: Button("End Workout") {
                    Task {
                        await viewModel.finishWorkout()
                        dismiss()
                    }
                }
            )
        }
    }
}

#Preview {
    WorkoutSessionView(workout: Workout(name: "Sample Workout"))
} 