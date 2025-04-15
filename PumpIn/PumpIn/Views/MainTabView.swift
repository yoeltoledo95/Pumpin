import SwiftUI

struct MainTabView: View {
    @State private var showingDebugMenu = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            WorkoutSplitView()
                .tabItem {
                    Label("Split", systemImage: "figure.strengthtraining.traditional")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingDebugMenu = true }) {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $showingDebugMenu) {
            DebugMenu()
        }
    }
}

struct DebugMenu: View {
    @Environment(\.dismiss) var dismiss
    @State private var hasCompletedOnboarding = UserDefaultsManager.shared.hasCompletedOnboarding()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button("Reset App") {
                        UserDefaultsManager.shared.resetApp()
                        hasCompletedOnboarding = false
                        dismiss()
                    }
                }
                
                Section(header: Text("Debug Info")) {
                    Text("Onboarding Completed: \(hasCompletedOnboarding ? "Yes" : "No")")
                    if let profile = UserDefaultsManager.shared.userProfile {
                        Text("Training Days: \(profile.trainingDaysPerWeek)")
                        Text("Workout Split: \(profile.workoutSplit.displayText)")
                        Text("Main Goal: \(profile.mainGoal.displayText)")
                        Text("Time per Session: \(profile.timePerSession.displayText)")
                        Text("Experience Level: \(profile.experienceLevel.displayText)")
                        Text("Injuries: \(profile.injuries)")
                    }
                }
            }
            .navigationTitle("Debug Menu")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

// Placeholder views - we'll implement these next
struct HomeView: View {
    var body: some View {
        Text("Home View - Coming soon")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View - Coming soon")
    }
}

#Preview {
    MainTabView()
} 