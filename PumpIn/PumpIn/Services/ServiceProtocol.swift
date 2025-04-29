import Foundation

// Protocol for workout-related operations
protocol WorkoutServiceProtocol {
    func fetchWorkouts() async throws -> [Workout]
    func createWorkout(_ workout: Workout) async throws -> Workout
    func updateWorkout(_ workout: Workout) async throws
    func deleteWorkout(_ workout: Workout) async throws
}

// Protocol for exercise-related operations
protocol ExerciseServiceProtocol {
    func fetchExercises() async throws -> [WorkoutExercise]
    func createExercise(name: String) async throws -> WorkoutExercise
    func updateExercise(_ exercise: WorkoutExercise) async throws
    func deleteExercise(_ exercise: WorkoutExercise) async throws
} 