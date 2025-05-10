import Foundation
import Combine

@MainActor
class WorkoutListViewModel: ObservableObject {
    @Published private(set) var workouts: [Workout] = []
    @Published private(set) var searchText = ""
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let workoutService: WorkoutServiceProtocol
    
    init(workoutService: WorkoutServiceProtocol = WorkoutService()) {
        self.workoutService = workoutService
    }
    
    var filteredWorkouts: [Workout] {
        if searchText.isEmpty {
            return workouts
        }
        return workouts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    func fetchWorkouts() async {
        isLoading = true
        error = nil
        
        do {
            workouts = try await workoutService.fetchWorkouts()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func createWorkout(name: String, exercises: [WorkoutExercise]) async {
        isLoading = true
        error = nil
        
        do {
            var workout = Workout(name: name)
            workout.exercises = exercises
            let createdWorkout = try await workoutService.createWorkout(workout)
            workouts.append(createdWorkout)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func deleteWorkout(_ workout: Workout) async {
        isLoading = true
        error = nil
        
        do {
            try await workoutService.deleteWorkout(workout)
            workouts.removeAll { $0.id == workout.id }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func setSearchText(_ text: String) {
        searchText = text
    }
    
    func updateWorkout(_ updated: Workout) {
        if let idx = workouts.firstIndex(where: { $0.id == updated.id }) {
            workouts[idx] = updated
        }
    }
} 