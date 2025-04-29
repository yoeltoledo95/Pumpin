import Foundation

// MARK: - Workout Model
struct Workout: Identifiable, Codable {
    let id: UUID
    var name: String
    var notes: String?
    var exercises: [WorkoutExercise]
    var isCompleted: Bool
    
    init(id: UUID = UUID(), name: String, notes: String? = nil, exercises: [WorkoutExercise] = [], isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.notes = notes
        self.exercises = exercises
        self.isCompleted = isCompleted
    }
    
    var totalVolume: Double {
        exercises.reduce(0) { $0 + $1.totalVolume }
    }
    
    var duration: TimeInterval {
        // Calculate total duration including rest times
        exercises.reduce(0) { total, exercise in
            total + exercise.sets.reduce(0) { $0 + Double($1.restTime) }
        }
    }
    
    mutating func addExercise(name: String) {
        let newExercise = WorkoutExercise(name: name)
        exercises.append(newExercise)
    }
    
    mutating func markAsCompleted() {
        isCompleted = true
    }
}

// MARK: - Exercise Model
struct WorkoutExercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var sets: [ExerciseSet]
    
    init(id: UUID = UUID(), name: String, sets: [ExerciseSet] = []) {
        self.id = id
        self.name = name
        self.sets = sets
    }
    
    mutating func addSet(targetReps: Int, targetWeight: Double, restTime: Int) {
        sets.append(ExerciseSet(targetReps: targetReps, targetWeight: targetWeight, restTime: restTime))
    }
    
    var totalVolume: Double {
        sets.reduce(0) { $0 + $1.totalVolume }
    }
}

// MARK: - Set Model
struct ExerciseSet: Identifiable, Codable {
    let id: UUID
    var targetReps: Int
    var targetWeight: Double
    var restTime: Int
    var actualReps: Int?
    var actualWeight: Double?
    var isCompleted: Bool
    
    init(id: UUID = UUID(), targetReps: Int, targetWeight: Double, restTime: Int, actualReps: Int? = nil, actualWeight: Double? = nil, isCompleted: Bool = false) {
        self.id = id
        self.targetReps = targetReps
        self.targetWeight = targetWeight
        self.restTime = restTime
        self.actualReps = actualReps
        self.actualWeight = actualWeight
        self.isCompleted = isCompleted
    }
    
    var totalVolume: Double {
        guard let actualReps = actualReps, let actualWeight = actualWeight else { return 0 }
        return Double(actualReps) * actualWeight
    }
} 