import Foundation

class ExerciseService: ExerciseServiceProtocol {
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager = StorageManager.shared) {
        self.storageManager = storageManager
    }
    
    func fetchExercises() async throws -> [WorkoutExercise] {
        let workouts = try await storageManager.fetchWorkouts()
        return workouts.flatMap { $0.exercises }
    }
    
    func createExercise(name: String) async throws -> WorkoutExercise {
        return WorkoutExercise(name: name)
    }
    
    func updateExercise(_ exercise: WorkoutExercise) async throws {
        var workouts = try await storageManager.fetchWorkouts()
        for (workoutIndex, workout) in workouts.enumerated() {
            if let exerciseIndex = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
                workouts[workoutIndex].exercises[exerciseIndex] = exercise
                try await storageManager.updateWorkout(workouts[workoutIndex])
                return
            }
        }
    }
    
    func deleteExercise(_ exercise: WorkoutExercise) async throws {
        var workouts = try await storageManager.fetchWorkouts()
        for (index, workout) in workouts.enumerated() {
            if workout.exercises.contains(where: { $0.id == exercise.id }) {
                workouts[index].exercises.removeAll { $0.id == exercise.id }
                try await storageManager.updateWorkout(workouts[index])
                return
            }
        }
    }
} 