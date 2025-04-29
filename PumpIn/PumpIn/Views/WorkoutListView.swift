import SwiftUI

struct WorkoutListView: View {
    @StateObject private var viewModel = WorkoutListViewModel()
    @State private var showingAddWorkout = false
    @State private var newWorkoutName = ""
    @State private var newWorkoutNotes = ""
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.filteredWorkouts.isEmpty {
                    ZStack {
                        Color(hex: "#F8FAFC").edgesIgnoringSafeArea(.all)
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Text("PumpIn")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(hex: "#1E2A38"))
                                Spacer()
                                HStack(spacing: 16) {
                                    NavigationLink(destination: WorkoutHistoryView()) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                            Text("Progress")
                                        }
                                        .foregroundColor(Color(hex: "#475569"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    }
                                    
                                    Button(action: { showingAddWorkout = true }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "plus")
                                            Text("Add Workout")
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color(hex: "#F97316"))
                                        .cornerRadius(8)
                                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .padding(.bottom, 24)
                            
                            Spacer()
                            
                            // Empty State
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
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.filteredWorkouts) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                WorkoutRowView(workout: workout)
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                for index in indexSet {
                                    await viewModel.deleteWorkout(viewModel.filteredWorkouts[index])
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("Workouts")
                }
            }
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
        VStack(alignment: .leading, spacing: 8) {
            Text(workout.name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#1E2A38"))
            
            if let notes = workout.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#64748B"))
            }
            
            HStack {
                Text("\(workout.exercises.count) exercises")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#475569"))
                
                Spacer()
                
                if workout.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#F97316"))
                }
            }
        }
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

#Preview {
    WorkoutListView()
} 