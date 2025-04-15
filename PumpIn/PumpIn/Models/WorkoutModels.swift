import Foundation

struct Exercise: Identifiable, Codable {
    var id: UUID
    var name: String
    var sets: Int
    var reps: Int
    var weight: Double
    var notes: String?
    
    init(id: UUID = UUID(), name: String, sets: Int = 3, reps: Int = 10, weight: Double = 0, notes: String? = nil) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.notes = notes
    }
}

struct WorkoutDay: Identifiable, Codable {
    var id: UUID
    var name: String
    var exercises: [Exercise]
    
    init(id: UUID = UUID(), name: String, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}

struct WorkoutSplitPlan: Codable {
    var days: [WorkoutDay]
    
    static let example = WorkoutSplitPlan(days: [
        WorkoutDay(name: "Push Day", exercises: [
            Exercise(name: "Bench Press", sets: 4, reps: 8, weight: 135),
            Exercise(name: "Shoulder Press", sets: 3, reps: 10, weight: 95),
            Exercise(name: "Tricep Extensions", sets: 3, reps: 12, weight: 45)
        ]),
        WorkoutDay(name: "Pull Day", exercises: [
            Exercise(name: "Barbell Rows", sets: 4, reps: 8, weight: 135),
            Exercise(name: "Pull-ups", sets: 3, reps: 10),
            Exercise(name: "Bicep Curls", sets: 3, reps: 12, weight: 30)
        ]),
        WorkoutDay(name: "Legs Day", exercises: [
            Exercise(name: "Squats", sets: 4, reps: 8, weight: 185),
            Exercise(name: "Romanian Deadlifts", sets: 3, reps: 10, weight: 155),
            Exercise(name: "Calf Raises", sets: 3, reps: 15, weight: 135)
        ])
    ])
} 