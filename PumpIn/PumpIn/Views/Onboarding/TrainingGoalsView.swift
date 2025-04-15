import SwiftUI

struct TrainingGoalsView: View {
    @EnvironmentObject private var navigationModel: OnboardingNavigationModel
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section {
                Picker("Main goal", selection: $viewModel.profile.mainGoal) {
                    ForEach(TrainingGoal.allCases) { goal in
                        Text(goal.displayText)
                            .tag(goal)
                    }
                }
            } footer: {
                Text("Select your primary training goal")
            }
            
            Section {
                Button("Continue") {
                    navigationModel.navigateToNext(.timeAvailability)
                }
            }
        }
        .navigationTitle("Training Goals")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TrainingGoalsView()
            .environmentObject(OnboardingNavigationModel())
            .environmentObject(OnboardingViewModel())
    }
} 