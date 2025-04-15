import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var trainingDays = 3
    @State private var mainGoal = TrainingGoal.strength
    @State private var workoutSplit = WorkoutSplit.fullBody
    @State private var timePerSession = TimeRange.sixtyToNinety
    @State private var injuries = ""
    @State private var experienceLevel = ExperienceLevel.beginner
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Training Schedule")) {
                    Picker("Days per week", selection: $trainingDays) {
                        ForEach(1...7, id: \.self) { day in
                            Text("\(day) days").tag(day)
                        }
                    }
                }
                
                Section(header: Text("Goals")) {
                    Picker("Main goal", selection: $mainGoal) {
                        ForEach(TrainingGoal.allCases, id: \.self) { goal in
                            Text(goal.rawValue).tag(goal)
                        }
                    }
                }
                
                Section(header: Text("Workout Split")) {
                    Picker("Split type", selection: $workoutSplit) {
                        ForEach(WorkoutSplit.allCases, id: \.self) { split in
                            Text(split.rawValue).tag(split)
                        }
                    }
                }
                
                Section(header: Text("Time Availability")) {
                    Picker("Time per session", selection: $timePerSession) {
                        ForEach(TimeRange.allCases, id: \.self) { time in
                            Text(time.rawValue).tag(time)
                        }
                    }
                }
                
                Section(header: Text("Experience & Health")) {
                    Picker("Experience level", selection: $experienceLevel) {
                        ForEach(ExperienceLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    TextField("Injuries or limitations (optional)", text: $injuries)
                }
                
                Section {
                    Button("Complete Setup") {
                        saveProfile()
                    }
                }
            }
            .navigationTitle("Welcome to PumpIn")
        }
    }
    
    private func saveProfile() {
        let profile = UserProfile(
            trainingDaysPerWeek: trainingDays,
            workoutSplit: workoutSplit,
            mainGoal: mainGoal,
            timePerSession: timePerSession,
            injuries: injuries,
            experienceLevel: experienceLevel
        )
        
        UserDefaultsManager.shared.userProfile = profile
        UserDefaultsManager.shared.setOnboardingCompleted(true)
        hasCompletedOnboarding = true
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
} 