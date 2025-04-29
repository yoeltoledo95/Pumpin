import Foundation
import Combine

/// A view model that manages the state and logic for an active workout session.
/// This includes tracking the current exercise, sets, rest times, and completed exercises.
@MainActor
class WorkoutSessionViewModel: ObservableObject {
    // MARK: - Private Properties
    
    /// The workout being performed
    private let workout: Workout
    
    /// Index of the current exercise in the workout
    private var currentExerciseIndex = 0
    
    /// Index of the current set in the current exercise
    private var currentSetIndex = 0
    
    /// Timer for tracking rest periods
    private var timer: Timer?
    
    /// Service for saving workout history
    private let workoutHistoryService: WorkoutHistoryServiceProtocol
    
    // MARK: - Published Properties
    
    /// The current exercise being performed, or nil if the workout is complete
    @Published private(set) var currentExercise: WorkoutExercise?
    
    /// The current set being performed
    @Published private(set) var currentSet: ExerciseSet
    
    /// List of completed exercises with their actual performance data
    @Published private(set) var completedExercises: [CompletedExercise] = []
    
    /// Whether the user is currently in a rest period
    @Published private(set) var isResting = false
    
    /// Time remaining in the current rest period (in seconds)
    @Published private(set) var restTimeRemaining = 0
    
    /// Whether the workout is currently being saved
    @Published private(set) var isSaving = false
    
    /// Any error that occurred during the workout session
    @Published private(set) var error: Error?
    
    // MARK: - Initialization
    
    /// Creates a new workout session view model.
    /// - Parameters:
    ///   - workout: The workout to perform
    ///   - workoutHistoryService: Service for saving workout history
    init(workout: Workout, workoutHistoryService: WorkoutHistoryServiceProtocol = WorkoutHistoryService()) {
        self.workout = workout
        self.workoutHistoryService = workoutHistoryService
        self.currentSet = ExerciseSet(targetReps: 0, targetWeight: 0, restTime: 0)
        setupNextExercise()
    }
    
    // MARK: - Exercise Management
    
    /// Sets up the next exercise in the workout sequence
    private func setupNextExercise() {
        guard currentExerciseIndex < workout.exercises.count else {
            currentExercise = nil
            return
        }
        
        let exercise = workout.exercises[currentExerciseIndex]
        currentExercise = exercise
        currentSetIndex = 0
        setupNextSet()
    }
    
    /// Sets up the next set in the current exercise
    private func setupNextSet() {
        guard let exercise = currentExercise,
              currentSetIndex < exercise.sets.count else {
            currentExerciseIndex += 1
            setupNextExercise()
            return
        }
        
        currentSet = exercise.sets[currentSetIndex]
        startRestTimer()
    }
    
    // MARK: - Rest Timer Management
    
    /// Starts the rest timer for the current set
    private func startRestTimer() {
        isResting = true
        restTimeRemaining = currentSet.restTime
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                if self.restTimeRemaining > 0 {
                    self.restTimeRemaining -= 1
                } else {
                    self.stopRestTimer()
                }
            }
        }
    }
    
    /// Stops the current rest timer
    private func stopRestTimer() {
        timer?.invalidate()
        timer = nil
        isResting = false
    }
    
    /// Skips the current rest period
    func skipRest() {
        stopRestTimer()
    }
    
    // MARK: - Set Completion
    
    /// Records the completion of the current set with actual performance data
    /// - Parameters:
    ///   - actualReps: The number of reps actually performed
    ///   - actualWeight: The weight actually used
    func completeSet(actualReps: Int, actualWeight: Double) {
        guard let exercise = currentExercise else { return }
        
        let setNumber = exercise.sets.firstIndex(where: { $0.id == currentSet.id })! + 1
        
        let completedSet = CompletedSet(
            setNumber: setNumber,
            targetReps: currentSet.targetReps,
            targetWeight: currentSet.targetWeight,
            actualReps: actualReps,
            actualWeight: actualWeight
        )
        
        if let index = completedExercises.firstIndex(where: { $0.name == exercise.name }) {
            completedExercises[index].completedSets.append(completedSet)
        } else {
            let completedExercise = CompletedExercise(
                name: exercise.name,
                completedSets: [completedSet]
            )
            completedExercises.append(completedExercise)
        }
        
        currentSetIndex += 1
        setupNextSet()
    }
    
    // MARK: - Workout Completion
    
    /// Completes the current workout and saves it to history
    func finishWorkout() async {
        stopRestTimer()
        
        isSaving = true
        error = nil
        
        let completedWorkout = WorkoutHistoryViewModel.CompletedWorkout(
            name: workout.name,
            date: Date(),
            exercises: completedExercises
        )
        
        do {
            try await workoutHistoryService.saveWorkout(completedWorkout)
        } catch {
            self.error = error
        }
        
        isSaving = false
    }
    
    // MARK: - Cleanup
    
    deinit {
        // Since we can't use async/await in deinit, we'll just invalidate the timer
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Completed Exercise Types

/// Represents an exercise that has been completed during a workout
struct CompletedExercise: Identifiable, Codable {
    var id = UUID()
    let name: String
    var completedSets: [CompletedSet]
    
    /// Calculates the total volume (weight × reps) for all completed sets
    var totalVolume: Double {
        completedSets.reduce(0) { total, set in
            total + (set.actualWeight * Double(set.actualReps))
        }
    }
}

/// Represents a set that has been completed during an exercise
struct CompletedSet: Identifiable, Codable {
    var id = UUID()
    let setNumber: Int
    let targetReps: Int
    let targetWeight: Double
    let actualReps: Int
    let actualWeight: Double
} 