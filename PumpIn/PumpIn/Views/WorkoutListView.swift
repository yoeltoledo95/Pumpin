import SwiftUI

struct WorkoutListView: View {
    @StateObject private var viewModel = WorkoutListViewModel()
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F8FAFC").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Buttons
                    HStack {
                        Spacer()
                        HStack(spacing: 12) {
                            NavigationLink(destination: WorkoutHistoryView()) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: "#475569"))
                                    .frame(width: 44, height: 44)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            
                            Button(action: { showingAddWorkout = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color(hex: "#F97316"))
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
                            .foregroundColor(Color(hex: "#1E2A38"))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    if viewModel.filteredWorkouts.isEmpty {
                        // Empty State
                        Spacer()
                        VStack(spacing: 24) {
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Color(hex: "#64748B"))
                            
                            VStack(spacing: 8) {
                                Text("No Workouts Yet")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(hex: "#1E2A38"))
                                
                                Text("Create your first workout to start tracking your fitness journey")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#64748B"))
                                    .multilineTextAlignment(.center)
                            }
                            
                            Button(action: { showingAddWorkout = true }) {
                                Text("Create First Workout")
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
                        .padding(24)
                        Spacer()
                    } else {
                        // Workout List
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredWorkouts) { workout in
                                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                        WorkoutRowView(workout: workout)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddWorkout) {
                CreateWorkoutView(isPresented: $showingAddWorkout, onSave: { name, exercises in
                    Task {
                        await viewModel.createWorkout(name: name, exercises: exercises)
                    }
                })
            }
        }
        .task {
            await viewModel.fetchWorkouts()
        }
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Workout Name and Status
            HStack(alignment: .center) {
                Text(workout.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A38"))
                
                Spacer()
                
                if workout.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#22C55E"))
                        .font(.system(size: 20))
                }
            }
            
            // Exercise Stats
            HStack(spacing: 24) {
                // Total Exercises
                HStack(spacing: 8) {
                    Image(systemName: "dumbbell.fill")
                        .foregroundColor(Color(hex: "#F97316"))
                    Text("\(workout.exercises.count)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#1E2A38"))
                    Text("exercises")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#64748B"))
                }
                
                // Total Sets
                HStack(spacing: 8) {
                    Image(systemName: "repeat")
                        .foregroundColor(Color(hex: "#F97316"))
                    Text("\(workout.exercises.reduce(0) { $0 + $1.sets.count })")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#1E2A38"))
                    Text("sets")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#64748B"))
                }
            }
            
            // Exercise Preview
            if !workout.exercises.isEmpty {
                Text(workout.exercises.map { $0.name }.joined(separator: " · "))
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#64748B"))
                    .lineLimit(1)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    WorkoutListView()
} 