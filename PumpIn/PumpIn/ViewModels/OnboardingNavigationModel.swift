import SwiftUI

enum OnboardingStep: Hashable {
    case frequency
    case split
    case goals
    case timeAvailability
    case experience
}

class OnboardingNavigationModel: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigateToNext(_ step: OnboardingStep) {
        path.append(step)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func resetNavigation() {
        path = NavigationPath()
    }
} 