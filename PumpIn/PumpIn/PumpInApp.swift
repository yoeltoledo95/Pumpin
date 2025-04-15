//
//  PumpInApp.swift
//  PumpIn
//
//  Created by Yoel Toledo on 14/04/2025.
//

import SwiftUI

@main
struct PumpInApp: App {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var navigationModel = OnboardingNavigationModel()
    @State private var hasCompletedOnboarding = UserDefaultsManager.shared.hasCompletedOnboarding()
    
    init() {
        #if DEV
        // In development builds, we can add development features
        if ProcessInfo.processInfo.arguments.contains("--reset") {
            UserDefaultsManager.shared.resetApp()
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(onboardingViewModel)
            } else {
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
                }
                .environmentObject(navigationModel)
                .environmentObject(onboardingViewModel)
            }
        }
    }
}
