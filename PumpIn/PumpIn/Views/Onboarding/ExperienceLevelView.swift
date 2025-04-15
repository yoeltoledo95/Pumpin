import SwiftUI

struct ExperienceLevelView: View {
    @Binding var hasCompletedOnboarding: Bool
    @EnvironmentObject private var navigationModel: OnboardingNavigationModel
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    var body: some View {
        Form {
            Section {
                Picker("Experience level", selection: $viewModel.profile.experienceLevel) {
                    ForEach(ExperienceLevel.allCases) { level in
                        Text(level.displayText)
                            .tag(level)
                    }
                }
            } footer: {
                Text("Select your current fitness experience level")
            }
            
            Section {
                Button("Complete Setup") {
                    viewModel.updateProfile()
                    navigationModel.resetNavigation()
                    hasCompletedOnboarding = true
                }
            }
        }
        .navigationTitle("Experience Level")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ExperienceLevelView(hasCompletedOnboarding: .constant(false))
            .environmentObject(OnboardingNavigationModel())
            .environmentObject(OnboardingViewModel())
    }
} 