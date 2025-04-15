import SwiftUI

struct TrainingSplitView: View {
    @EnvironmentObject private var navigationModel: OnboardingNavigationModel
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    var body: some View {
        Form {
            Section {
                Picker("Training split", selection: $viewModel.profile.workoutSplit) {
                    ForEach(WorkoutSplit.allCases) { split in
                        Text(split.displayText)
                            .tag(split)
                    }
                }
            } footer: {
                Text("Select your preferred workout split")
            }
            
            Section {
                Button("Continue") {
                    navigationModel.navigateToNext(.goals)
                }
            }
        }
        .navigationTitle("Training Split")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        TrainingSplitView()
            .environmentObject(OnboardingNavigationModel())
            .environmentObject(OnboardingViewModel())
    }
} 