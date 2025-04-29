import SwiftUI

struct RestTimerView: View {
    let timeRemaining: Int
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Rest Time")
                .font(.title)
                .padding()
            
            Text("\(timeRemaining)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
            
            Button(action: onSkip) {
                Text("Skip Rest")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    RestTimerView(timeRemaining: 60, onSkip: {})
} 