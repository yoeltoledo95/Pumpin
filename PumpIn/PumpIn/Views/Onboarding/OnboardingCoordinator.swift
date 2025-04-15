import SwiftUI

struct OnboardingCoordinator: View {
    @Binding var hasCompletedOnboarding: Bool
    @StateObject private var navigationModel = OnboardingNavigationModel()
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            WelcomeView()
                .navigationDestination(for: OnboardingStep.self) { step in
                    switch step {
                    case .frequency:
                        TrainingFrequencyView()
                    case .split:
                        TrainingSplitView()
                    case .goals:
                        TrainingGoalsView()
                    case .timeAvailability:
                        TimeAvailabilityView()
                    case .experience:
                        ExperienceLevelView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    }
                }
                .environmentObject(navigationModel)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    OnboardingCoordinator(hasCompletedOnboarding: .constant(false))
} 