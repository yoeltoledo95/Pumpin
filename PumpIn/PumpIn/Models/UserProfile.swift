import Foundation

enum TrainingGoal: String, Codable, CaseIterable, Identifiable {
    case strength = "Strength"
    case hypertrophy = "Hypertrophy"
    case fatLoss = "Fat Loss"
    
    var id: String { rawValue }
    var displayText: String { rawValue }
}

enum WorkoutSplit: String, Codable, CaseIterable, Identifiable {
    case pushPullLegs = "Push/Pull/Legs"
    case upperLower = "Upper/Lower"
    case fullBody = "Full Body"
    case custom = "Custom"
    
    var id: String { rawValue }
    var displayText: String { rawValue }
}

enum TimeRange: String, Codable, CaseIterable, Identifiable {
    case thirtyToFortyFive = "30-45 minutes"
    case fortyFiveToSixty = "45-60 minutes"
    case sixtyToNinety = "60-90 minutes"
    case ninetyPlus = "90+ minutes"
    
    var id: String { rawValue }
    var displayText: String { rawValue }
}

enum ExperienceLevel: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var id: String { rawValue }
    var displayText: String { rawValue }
}

struct UserProfile: Codable {
    var trainingDaysPerWeek: Int
    var workoutSplit: WorkoutSplit
    var mainGoal: TrainingGoal
    var timePerSession: TimeRange
    var injuries: String
    var experienceLevel: ExperienceLevel
    
    init(trainingDaysPerWeek: Int = 3,
         workoutSplit: WorkoutSplit = .fullBody,
         mainGoal: TrainingGoal = .strength,
         timePerSession: TimeRange = .sixtyToNinety,
         injuries: String = "",
         experienceLevel: ExperienceLevel = .beginner) {
        self.trainingDaysPerWeek = trainingDaysPerWeek
        self.workoutSplit = workoutSplit
        self.mainGoal = mainGoal
        self.timePerSession = timePerSession
        self.injuries = injuries
        self.experienceLevel = experienceLevel
    }
} 