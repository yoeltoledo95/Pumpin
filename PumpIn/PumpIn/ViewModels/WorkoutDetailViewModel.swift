import Foundation
import Combine

@MainActor
class WorkoutDetailViewModel: ObservableObject {
    @Published var workout: Workout
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isEditing = false
    
    private let workoutService: WorkoutServiceProtocol
    
    init(workout: Workout, workoutService: WorkoutServiceProtocol = WorkoutService()) {
        self.workout = workout
        self.workoutService = workoutService
    }
    
    func updateWorkout() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await workoutService.updateWorkout(workout)
        } catch {
            self.error = error
        }
    }
    
    func addExercise(name: String) {
        workout.addExercise(name: name)
    }
    
    func deleteExercise(_ exercise: WorkoutExercise) {
        workout.exercises.removeAll { $0.id == exercise.id }
    }
    
    func addSet(to exercise: WorkoutExercise, targetReps: Int, targetWeight: Double, restTime: Int) {
        if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
            workout.exercises[index].addSet(
                targetReps: targetReps,
                targetWeight: targetWeight,
                restTime: restTime
            )
        }
    }
    
    func deleteSet(from exercise: WorkoutExercise, set: ExerciseSet) {
        if let exerciseIndex = workout.exercises.firstIndex(where: { $0.id == exercise.id }),
           let setIndex = workout.exercises[exerciseIndex].sets.firstIndex(where: { $0.id == set.id }) {
            workout.exercises[exerciseIndex].sets.remove(at: setIndex)
        }
    }
    
    func startWorkout() {
        isEditing = false
    }
    
    func completeWorkout() {
        workout.markAsCompleted()
    }
} 