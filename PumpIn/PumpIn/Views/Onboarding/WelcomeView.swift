import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var navigationModel: OnboardingNavigationModel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
            
            Text("Welcome to PumpIn")
                .font(.largeTitle)
                .bold()
            
            Text("Let's create your personalized workout plan")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                navigationModel.navigateToNext(.frequency)
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
            .environmentObject(OnboardingNavigationModel())
    }
} 