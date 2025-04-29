import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "workouts"
    
    private init() {}
    
    func fetchWorkouts() async throws -> [Workout] {
        guard let data = userDefaults.data(forKey: workoutsKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Workout].self, from: data)
    }
    
    func saveWorkout(_ workout: Workout) async throws -> Workout {
        var workouts = try await fetchWorkouts()
        workouts.append(workout)
        try await saveWorkouts(workouts)
        return workout
    }
    
    func updateWorkout(_ workout: Workout) async throws {
        var workouts = try await fetchWorkouts()
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            try await saveWorkouts(workouts)
        }
    }
    
    func deleteWorkout(_ workout: Workout) async throws {
        var workouts = try await fetchWorkouts()
        workouts.removeAll { $0.id == workout.id }
        try await saveWorkouts(workouts)
    }
    
    private func saveWorkouts(_ workouts: [Workout]) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(workouts)
        userDefaults.set(data, forKey: workoutsKey)
    }
} 