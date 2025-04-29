import Foundation
import Charts

@MainActor
class WorkoutHistoryViewModel: ObservableObject {
    private let workoutHistoryService: WorkoutHistoryServiceProtocol
    
    @Published private(set) var completedWorkouts: [CompletedWorkout] = []
    @Published private(set) var selectedTimeRange: TimeRange = .week
    @Published private(set) var selectedExercise: String?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init(workoutHistoryService: WorkoutHistoryServiceProtocol = WorkoutHistoryService()) {
        self.workoutHistoryService = workoutHistoryService
    }
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
        
        var dateRange: DateInterval {
            let calendar = Calendar.current
            let now = Date()
            
            switch self {
            case .week:
                let start = calendar.date(byAdding: .day, value: -7, to: now)!
                return DateInterval(start: start, end: now)
            case .month:
                let start = calendar.date(byAdding: .month, value: -1, to: now)!
                return DateInterval(start: start, end: now)
            case .year:
                let start = calendar.date(byAdding: .year, value: -1, to: now)!
                return DateInterval(start: start, end: now)
            case .all:
                return DateInterval(start: .distantPast, end: now)
            }
        }
    }
    
    struct CompletedWorkout: Identifiable, Codable {
        let id: UUID
        let name: String
        let date: Date
        let exercises: [CompletedExercise]
        
        var totalVolume: Double {
            exercises.reduce(0) { total, exercise in
                total + exercise.totalVolume
            }
        }
        
        init(id: UUID = UUID(), name: String, date: Date, exercises: [CompletedExercise]) {
            self.id = id
            self.name = name
            self.date = date
            self.exercises = exercises
        }
    }
    
    struct ExerciseProgress: Identifiable {
        let id = UUID()
        let name: String
        let date: Date
        let maxWeight: Double
        let totalVolume: Double
    }
    
    var filteredWorkouts: [CompletedWorkout] {
        let range = selectedTimeRange.dateRange
        return completedWorkouts.filter { range.contains($0.date) }
    }
    
    var exerciseProgressData: [ExerciseProgress] {
        let range = selectedTimeRange.dateRange
        let filtered = completedWorkouts.filter { range.contains($0.date) }
        
        var progress: [String: [ExerciseProgress]] = [:]
        
        for workout in filtered {
            for exercise in workout.exercises {
                let maxWeight = exercise.completedSets.map { $0.actualWeight }.max() ?? 0
                let totalVolume = exercise.totalVolume
                
                let data = ExerciseProgress(
                    name: exercise.name,
                    date: workout.date,
                    maxWeight: maxWeight,
                    totalVolume: totalVolume
                )
                
                progress[exercise.name, default: []].append(data)
            }
        }
        
        if let selectedExercise = selectedExercise {
            return progress[selectedExercise] ?? []
        }
        
        return progress.values.flatMap { $0 }
    }
    
    var availableExercises: [String] {
        Array(Set(completedWorkouts.flatMap { workout in
            workout.exercises.map { $0.name }
        })).sorted()
    }
    
    func selectExercise(_ exercise: String?) {
        selectedExercise = exercise
    }
    
    func selectTimeRange(_ range: TimeRange) {
        selectedTimeRange = range
    }
    
    func loadWorkouts() async {
        isLoading = true
        error = nil
        
        do {
            completedWorkouts = try await workoutHistoryService.loadWorkouts()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func saveWorkout(_ workout: CompletedWorkout) async {
        isLoading = true
        error = nil
        
        do {
            try await workoutHistoryService.saveWorkout(workout)
            await loadWorkouts()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func setSelectedTimeRange(_ range: TimeRange) {
        selectedTimeRange = range
    }
    
    func setSelectedExercise(_ exercise: String?) {
        selectedExercise = exercise
    }
} 