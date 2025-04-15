import SwiftUI

struct TrainingFrequencyView: View {
    @EnvironmentObject private var navigationModel: OnboardingNavigationModel
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    var body: some View {
        Form {
            Section {
                Picker("Days per week", selection: $viewModel.profile.trainingDaysPerWeek) {
                    ForEach(1...7, id: \.self) { day in
                        Text("\(day) days").tag(day)
                    }
                }
            } footer: {
                Text("Choose how many days per week you can commit to training")
            }
            
            Section {
                Button("Continue") {
                    navigationModel.navigateToNext(.split)
                }
            }
        }
        .navigationTitle("Training Frequency")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        TrainingFrequencyView()
            .environmentObject(OnboardingNavigationModel())
            .environmentObject(OnboardingViewModel())
    }
} 