import Foundation

struct ExerciseHistoryEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var exerciseName: String
    var date: Date
    var weight: Double
    var reps: Int
    var volume: Double {
        Double(reps) * weight
    }
    
    init(id: UUID = UUID(),
         exerciseName: String,
         date: Date = Date(),
         weight: Double,
         reps: Int) {
        self.id = id
        self.exerciseName = exerciseName
        self.date = date
        self.weight = weight
        self.reps = reps
    }
} 