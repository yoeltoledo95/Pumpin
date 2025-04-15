import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let userProfile = "userProfile"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private init() {}
    
    var userProfile: UserProfile? {
        get {
            guard let data = defaults.data(forKey: Keys.userProfile) else { return nil }
            return try? JSONDecoder().decode(UserProfile.self, from: data)
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                defaults.set(encoded, forKey: Keys.userProfile)
            }
        }
    }
    
    func hasCompletedOnboarding() -> Bool {
        return defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.hasCompletedOnboarding)
    }
    
    func clearUserProfile() {
        defaults.removeObject(forKey: Keys.userProfile)
    }
    
    func resetApp() {
        clearUserProfile()
        setOnboardingCompleted(false)
        defaults.synchronize()
    }
} 