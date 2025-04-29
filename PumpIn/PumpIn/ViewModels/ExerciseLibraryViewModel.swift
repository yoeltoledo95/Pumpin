import Foundation
import Combine

@MainActor
class ExerciseLibraryViewModel: ObservableObject {
    @Published var exercises: [String] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    
    private let workoutService: WorkoutServiceProtocol
    
    init(workoutService: WorkoutServiceProtocol = WorkoutService()) {
        self.workoutService = workoutService
        loadDefaultExercises()
    }
    
    var filteredExercises: [String] {
        if searchText.isEmpty {
            return exercises
        }
        return exercises.filter { exercise in
            exercise.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func loadDefaultExercises() {
        // TODO: Load from a local JSON file or remote service
        exercises = [
            "Bench Press",
            "Squat",
            "Deadlift",
            "Overhead Press",
            "Barbell Row",
            "Pull-up",
            "Push-up",
            "Dumbbell Curl",
            "Tricep Extension",
            "Lateral Raise",
            "Leg Press",
            "Romanian Deadlift",
            "Calf Raise",
            "Plank",
            "Russian Twist"
        ].sorted()
    }
    
    func addCustomExercise(_ name: String) {
        if !exercises.contains(name) {
            exercises.append(name)
            exercises.sort()
        }
    }
    
    func deleteExercise(_ name: String) {
        exercises.removeAll { $0 == name }
    }
} 