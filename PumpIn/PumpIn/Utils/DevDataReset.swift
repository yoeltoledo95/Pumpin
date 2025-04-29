import Foundation

#if DEBUG
struct DevDataReset {
    static func resetAll() {
        let keys = ["workouts", "exercises", "completedWorkouts"]
        let defaults = UserDefaults.standard
        for key in keys {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
}
#endif 