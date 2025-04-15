import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var profile: UserProfile
    private let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager = .shared) {
        self.userDefaultsManager = userDefaultsManager
        self.profile = UserProfile()
        setupDefaultProfile()
    }
    
    private func setupDefaultProfile() {
        profile.trainingDaysPerWeek = 3
        profile.workoutSplit = .fullBody
        profile.mainGoal = .strength
        profile.timePerSession = .sixtyToNinety
        profile.experienceLevel = .beginner
        profile.injuries = ""
    }
    
    func updateProfile() {
        userDefaultsManager.userProfile = profile
        userDefaultsManager.setOnboardingCompleted(true)
    }
    
    func updateTrainingDays(_ days: Int) {
        profile.trainingDaysPerWeek = days
    }
    
    func updateWorkoutSplit(_ split: WorkoutSplit) {
        profile.workoutSplit = split
    }
    
    func updateMainGoal(_ goal: TrainingGoal) {
        profile.mainGoal = goal
    }
    
    func updateTimePerSession(_ time: TimeRange) {
        profile.timePerSession = time
    }
    
    func updateInjuries(_ injuries: String) {
        profile.injuries = injuries
    }
    
    func updateExperienceLevel(_ level: ExperienceLevel) {
        profile.experienceLevel = level
    }
} 