import SwiftUI

struct TimeAvailabilityView: View {
    @EnvironmentObject private var navigationModel: OnboardingNavigationModel
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    var body: some View {
        Form {
            Section {
                Picker("Time per session", selection: $viewModel.profile.timePerSession) {
                    ForEach(TimeRange.allCases) { timeRange in
                        Text(timeRange.displayText)
                            .tag(timeRange)
                    }
                }
            } footer: {
                Text("Select how much time you can dedicate to each workout session")
            }
            
            Section {
                Button("Continue") {
                    navigationModel.navigateToNext(.experience)
                }
            }
        }
        .navigationTitle("Time Availability")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        TimeAvailabilityView()
            .environmentObject(OnboardingNavigationModel())
            .environmentObject(OnboardingViewModel())
    }
} 