import Foundation

class WorkoutSplitViewModel: ObservableObject {
    @Published var workoutPlan: WorkoutSplitPlan
    
    init(workoutPlan: WorkoutSplitPlan? = nil) {
        self.workoutPlan = workoutPlan ?? WorkoutSplitPlan(days: [])
    }
    
    // MARK: - Day Management
    
    func addDay(name: String) {
        let newDay = WorkoutDay(name: name)
        workoutPlan.days.append(newDay)
    }
    
    func removeDay(at index: Int) {
        workoutPlan.days.remove(at: index)
    }
    
    func moveDay(from source: IndexSet, to destination: Int) {
        workoutPlan.days.move(fromOffsets: source, toOffset: destination)
    }
    
    // MARK: - Exercise Management
    
    func addExercise(to dayIndex: Int, exercise: Exercise) {
        guard dayIndex < workoutPlan.days.count else { return }
        workoutPlan.days[dayIndex].exercises.append(exercise)
    }
    
    func removeExercise(from dayIndex: Int, at exerciseIndex: Int) {
        guard dayIndex < workoutPlan.days.count else { return }
        workoutPlan.days[dayIndex].exercises.remove(at: exerciseIndex)
    }
    
    func moveExercise(in dayIndex: Int, from source: IndexSet, to destination: Int) {
        guard dayIndex < workoutPlan.days.count else { return }
        workoutPlan.days[dayIndex].exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    // MARK: - Persistence
    
    func save() {
        do {
            let data = try JSONEncoder().encode(workoutPlan)
            UserDefaults.standard.set(data, forKey: "workoutPlan")
        } catch {
            print("Error saving workout plan: \(error)")
        }
    }
    
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "workoutPlan"),
              let plan = try? JSONDecoder().decode(WorkoutSplitPlan.self, from: data) else {
            // Load example data if no saved plan exists
            workoutPlan = WorkoutSplitPlan.example
            return
        }
        workoutPlan = plan
    }
} 