import SwiftUI

struct WorkoutListView: View {
    @StateObject private var viewModel = WorkoutListViewModel()
    @State private var showingAddWorkout = false
    @State private var showingEditWorkout = false
    @State private var workoutToEdit: Workout? = nil
    @State private var workoutToDelete: Workout? = nil
    @State private var showDeleteAlert = false
    @Environment(\.theme) var theme
    
    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Buttons
                    HStack {
                        Spacer()
                        HStack(spacing: 12) {
                            NavigationLink(destination: WorkoutHistoryView()) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 20))
                                    .foregroundColor(theme.secondary)
                                    .frame(width: 44, height: 44)
                                    .background(theme.cardBackground)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            
                            Button(action: { showingAddWorkout = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(theme.accent)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    // Title
                    HStack {
                        Text("Workouts")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(theme.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    if viewModel.filteredWorkouts.isEmpty {
                        VStack(spacing: 24) {
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary)
                            VStack(spacing: 8) {
                                Text("No Workouts Yet")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(theme.textPrimary)
                                Text("Create your first workout to start tracking your fitness journey")
                                    .font(.system(size: 16))
                                    .foregroundColor(theme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            Button(action: { showingAddWorkout = true }) {
                                Text("Create Workout")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(theme.accent)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        // Workout List
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredWorkouts) { workout in
                                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                        WorkoutRowView(workout: workout)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            workoutToDelete = workout
                                            showDeleteAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            workoutToEdit = workout
                                            showingEditWorkout = true
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(theme.accent)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddWorkout) {
                CreateWorkoutView(isPresented: $showingAddWorkout) { name, exercises in
                    Task {
                        await viewModel.createWorkout(name: name, exercises: exercises)
                    }
                }
            }
            .sheet(isPresented: $showingEditWorkout) {
                if let workout = workoutToEdit {
                    CreateWorkoutView(
                        isPresented: $showingEditWorkout,
                        onSave: { name, exercises in
                            var updated = workout
                            updated.name = name
                            updated.exercises = exercises
                            viewModel.updateWorkout(updated)
                            // Optionally update backend here
                        },
                        initialWorkoutName: workout.name,
                        initialExercises: workout.exercises.map { ex in ExerciseFormData(name: ex.name, sets: "\(ex.sets.count)", repsPerSet: ex.sets.first.map { "\($0.targetReps)" } ?? "", weight: ex.sets.first.map { "\($0.targetWeight)" } ?? "", restTime: ex.sets.first.map { "\($0.restTime)" } ?? "") },
                        title: "Edit Workout",
                        buttonLabel: "Save Changes"
                    )
                }
            }
            .alert("Delete Workout?", isPresented: $showDeleteAlert, presenting: workoutToDelete) { workout in
                Button("Delete", role: .destructive) {
                    Task { await viewModel.deleteWorkout(workout) }
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("Are you sure you want to delete this workout? This action cannot be undone.")
            }
        }
        .task {
            await viewModel.fetchWorkouts()
        }
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Workout Name and Status
            HStack(alignment: .center) {
                Text(workout.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.textPrimary)
                
                Spacer()
                
                if workout.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.success)
                        .font(.system(size: 20))
                }
            }
            
            // Exercise Stats
            HStack(spacing: 24) {
                // Total Exercises
                HStack(spacing: 8) {
                    Image(systemName: "dumbbell.fill")
                        .foregroundColor(theme.accent)
                    Text("\(workout.exercises.count)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(theme.textPrimary)
                    Text("exercises")
                        .font(.system(size: 16))
                        .foregroundColor(theme.textSecondary)
                }
                
                // Total Sets
                HStack(spacing: 8) {
                    Image(systemName: "repeat")
                        .foregroundColor(theme.accent)
                    Text("\(workout.exercises.reduce(0) { $0 + $1.sets.count })")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(theme.textPrimary)
                    Text("sets")
                        .font(.system(size: 16))
                        .foregroundColor(theme.textSecondary)
                }
            }
            
            // Exercise Preview
            if !workout.exercises.isEmpty {
                Text(workout.exercises.map { $0.name }.joined(separator: " · "))
                    .font(.system(size: 14))
                    .foregroundColor(theme.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .background(theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    WorkoutListView()
} 