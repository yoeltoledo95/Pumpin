import Foundation

protocol WorkoutHistoryServiceProtocol {
    func saveWorkout(_ workout: WorkoutHistoryViewModel.CompletedWorkout) async throws
    func loadWorkouts() async throws -> [WorkoutHistoryViewModel.CompletedWorkout]
}

class WorkoutHistoryService: WorkoutHistoryServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "completedWorkouts"
    
    func saveWorkout(_ workout: WorkoutHistoryViewModel.CompletedWorkout) async throws {
        var workouts = try await loadWorkouts()
        workouts.append(workout)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(workouts)
        userDefaults.set(data, forKey: workoutsKey)
    }
    
    func loadWorkouts() async throws -> [WorkoutHistoryViewModel.CompletedWorkout] {
        guard let data = userDefaults.data(forKey: workoutsKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([WorkoutHistoryViewModel.CompletedWorkout].self, from: data)
    }
} 