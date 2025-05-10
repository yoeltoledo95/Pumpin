import SwiftUI

struct CreateWorkoutView: View {
    @Binding var isPresented: Bool
    let onSave: (String, [WorkoutExercise]) -> Void
    var initialWorkoutName: String = ""
    var initialExercises: [ExerciseFormData] = [ExerciseFormData()]
    var title: String = "Create New Workout"
    var buttonLabel: String = "Create Workout"
    
    @State private var workoutName: String
    @State private var exercises: [ExerciseFormData]
    
    init(isPresented: Binding<Bool>,
         onSave: @escaping (String, [WorkoutExercise]) -> Void,
         initialWorkoutName: String = "",
         initialExercises: [ExerciseFormData] = [ExerciseFormData()],
         title: String = "Create New Workout",
         buttonLabel: String = "Create Workout") {
        self._isPresented = isPresented
        self.onSave = onSave
        self.initialWorkoutName = initialWorkoutName
        self.initialExercises = initialExercises
        self.title = title
        self.buttonLabel = buttonLabel
        _workoutName = State(initialValue: initialWorkoutName)
        _exercises = State(initialValue: initialExercises)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Workout Name Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Workout Name")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#1E2A38"))
                        
                        TextField("e.g., Upper Body Strength", text: $workoutName)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    .padding(.horizontal, 24)
                    
                    // Exercises Section
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Exercises")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "#1E2A38"))
                            .padding(.horizontal, 24)
                        
                        ForEach($exercises.indices, id: \.self) { index in
                            ExerciseFormView(
                                exercise: $exercises[index],
                                exerciseNumber: index + 1,
                                onDelete: {
                                    if exercises.count > 1 {
                                        exercises.remove(at: index)
                                    }
                                }
                            )
                        }
                        
                        // Add Exercise Button
                        Button(action: { exercises.append(ExerciseFormData()) }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Exercise")
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "#F97316"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(Color(hex: "#F97316"), style: StrokeStyle(lineWidth: 1, dash: [5]))
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.vertical, 24)
            }
            .background(Color(hex: "#F8FAFC"))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(Color(hex: "#475569"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(buttonLabel) {
                        let workoutExercises = exercises.map { data in
                            var exercise = WorkoutExercise(name: data.name)
                            for _ in 0..<(Int(data.sets) ?? 1) {
                                exercise.addSet(
                                    targetReps: Int(data.repsPerSet) ?? 0,
                                    targetWeight: Double(data.weight) ?? 0,
                                    restTime: Int(data.restTime) ?? 0
                                )
                            }
                            return exercise
                        }
                        onSave(workoutName, workoutExercises)
                        isPresented = false
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(workoutName.isEmpty ? Color(hex: "#475569") : Color(hex: "#F97316"))
                    .cornerRadius(8)
                    .disabled(workoutName.isEmpty)
                }
            }
        }
    }
}

struct ExerciseFormView: View {
    @Binding var exercise: ExerciseFormData
    let exerciseNumber: Int
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Exercise \(exerciseNumber)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A38"))
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            // Exercise Fields
            VStack(alignment: .leading, spacing: 20) {
                // Exercise Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercise Name")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#475569"))
                    
                    TextField("e.g., Bench Press", text: $exercise.name)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                // Sets and Reps
                HStack(spacing: 16) {
                    // Sets
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sets")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#475569"))
                        
                        TextField("3", text: $exercise.sets)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    // Reps per Set
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reps per Set")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#475569"))
                        
                        TextField("10", text: $exercise.repsPerSet)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                
                // Weight and Rest Time
                HStack(spacing: 16) {
                    // Weight
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight (kg)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#475569"))
                        
                        TextField("45", text: $exercise.weight)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                    
                    // Rest Time
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rest Time (seconds)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#475569"))
                        
                        TextField("60", text: $exercise.restTime)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
        .padding(.horizontal, 24)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    @Environment(\.theme) var theme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(theme.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(theme.border, lineWidth: 1)
            )
    }
}

struct ExerciseFormData {
    var name: String = ""
    var sets: String = "3"
    var repsPerSet: String = "10"
    var weight: String = "45"
    var restTime: String = "60"
    
    var repsPerSetInt: Int { Int(repsPerSet) ?? 0 }
    var weightDouble: Double { Double(weight) ?? 0 }
    var restTimeInt: Int { Int(restTime) ?? 0 }
}

#Preview {
    CreateWorkoutView(isPresented: .constant(true)) { _, _ in }
} 