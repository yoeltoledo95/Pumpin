import SwiftUI

struct WorkoutDetailView: View {
    @StateObject private var viewModel: WorkoutDetailViewModel
    @State private var showingAddExercise = false
    @State private var showingStartWorkout = false
    @Environment(\.dismiss) private var dismiss
    
    init(workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailViewModel(workout: workout))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Workout Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(viewModel.workout.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(hex: "#1E2A38"))
                        
                        Spacer()
                        
                        Text("\(viewModel.workout.exercises.count) exercises")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#64748B"))
                    }
                    
                    if let notes = viewModel.workout.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#475569"))
                    }
                }
                .padding(.horizontal, 24)
                
                // Exercises List
                VStack(spacing: 16) {
                    ForEach(viewModel.workout.exercises) { exercise in
                        ExerciseDetailView(exercise: exercise) {
                            viewModel.deleteExercise(exercise)
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Add Exercise Button
                Button(action: { showingAddExercise = true }) {
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
                
                // Start Workout Button
                if !viewModel.workout.exercises.isEmpty {
                    Button(action: { showingStartWorkout = true }) {
                        HStack {
                            Text("Start Workout")
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#F97316"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
            }
            .padding(.vertical, 24)
        }
        .background(Color(hex: "#F8FAFC"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(Color(hex: "#475569"))
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(isPresented: $showingAddExercise) { name, sets, reps, weight, restTime in
                var exercise = WorkoutExercise(name: name)
                for _ in 0..<sets {
                    exercise.addSet(targetReps: reps, targetWeight: weight, restTime: restTime)
                }
                viewModel.addExercise(name: name)
            }
        }
        .fullScreenCover(isPresented: $showingStartWorkout) {
            WorkoutSessionView(workout: viewModel.workout)
        }
    }
}

struct ExerciseDetailView: View {
    let exercise: WorkoutExercise
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Exercise Header
            HStack {
                Text(exercise.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#1E2A38"))
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            // Exercise Stats
            HStack(spacing: 24) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("\(exercise.sets.count) sets × \(exercise.sets.first?.targetReps ?? 0) reps")
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "scalemass.fill")
                    Text("\(Int(exercise.sets.first?.targetWeight ?? 0)) lbs")
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                    Text("\(exercise.sets.first?.restTime ?? 0)s rest")
                }
            }
            .font(.system(size: 14))
            .foregroundColor(Color(hex: "#64748B"))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }
}

struct AddExerciseView: View {
    @Binding var isPresented: Bool
    let onSave: (String, Int, Int, Double, Int) -> Void
    
    @State private var name = ""
    @State private var sets = "3"
    @State private var reps = "10"
    @State private var weight = "45"
    @State private var restTime = "60"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Exercise Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Exercise Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#475569"))
                        
                        TextField("e.g., Bench Press", text: $name)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Sets and Reps
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sets")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#475569"))
                            
                            TextField("3", text: $sets)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reps per Set")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#475569"))
                            
                            TextField("10", text: $reps)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                    
                    // Weight and Rest Time
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weight (lbs)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#475569"))
                            
                            TextField("45", text: $weight)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rest Time (seconds)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#475569"))
                            
                            TextField("60", text: $restTime)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                }
                .padding(24)
            }
            .background(Color(hex: "#F8FAFC"))
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(Color(hex: "#475569"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        onSave(
                            name,
                            Int(sets) ?? 3,
                            Int(reps) ?? 10,
                            Double(weight) ?? 45,
                            Int(restTime) ?? 60
                        )
                        isPresented = false
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(name.isEmpty ? Color(hex: "#475569") : Color(hex: "#F97316"))
                    .cornerRadius(8)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        WorkoutDetailView(workout: Workout(name: "Push Day"))
    }
} 