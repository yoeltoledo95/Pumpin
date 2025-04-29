import Foundation

class WorkoutService: WorkoutServiceProtocol {
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager = StorageManager.shared) {
        self.storageManager = storageManager
    }
    
    func fetchWorkouts() async throws -> [Workout] {
        return try await storageManager.fetchWorkouts()
    }
    
    func createWorkout(_ workout: Workout) async throws -> Workout {
        return try await storageManager.saveWorkout(workout)
    }
    
    func updateWorkout(_ workout: Workout) async throws {
        try await storageManager.updateWorkout(workout)
    }
    
    func deleteWorkout(_ workout: Workout) async throws {
        try await storageManager.deleteWorkout(workout)
    }
} 