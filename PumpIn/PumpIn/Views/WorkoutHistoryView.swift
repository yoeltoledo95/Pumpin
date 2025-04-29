import SwiftUI
import Charts

struct WorkoutHistoryView: View {
    @StateObject private var viewModel = WorkoutHistoryViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading workout history...")
                } else if let error = viewModel.error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error loading workout history")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task {
                                await viewModel.loadWorkouts()
                            }
                        }
                        .padding()
                    }
                } else if viewModel.completedWorkouts.isEmpty {
                    VStack {
                        Image(systemName: "dumbbell")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No workout history yet")
                            .font(.headline)
                        Text("Complete a workout to see your progress here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        Section {
                            Picker("Time Range", selection: Binding(
                                get: { viewModel.selectedTimeRange },
                                set: { viewModel.setSelectedTimeRange($0) }
                            )) {
                                ForEach(WorkoutHistoryViewModel.TimeRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            if !viewModel.availableExercises.isEmpty {
                                Picker("Exercise", selection: Binding(
                                    get: { viewModel.selectedExercise },
                                    set: { viewModel.setSelectedExercise($0) }
                                )) {
                                    Text("All Exercises").tag(nil as String?)
                                    ForEach(viewModel.availableExercises, id: \.self) { exercise in
                                        Text(exercise).tag(exercise as String?)
                                    }
                                }
                            }
                        }
                        
                        Section("Progress") {
                            Chart(viewModel.exerciseProgressData) { data in
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value("Max Weight", data.maxWeight)
                                )
                                .foregroundStyle(by: .value("Exercise", data.name))
                            }
                            .frame(height: 200)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.month().day())
                                }
                            }
                            
                            Chart(viewModel.exerciseProgressData) { data in
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value("Volume", data.totalVolume)
                                )
                                .foregroundStyle(by: .value("Exercise", data.name))
                            }
                            .frame(height: 200)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.month().day())
                                }
                            }
                        }
                        
                        Section("Workout History") {
                            ForEach(viewModel.filteredWorkouts) { workout in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(workout.name)
                                            .font(.headline)
                                        Spacer()
                                        Text(workout.date, style: .date)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    ForEach(workout.exercises) { exercise in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(exercise.name)
                                                .font(.subheadline)
                                            
                                            ForEach(exercise.completedSets) { set in
                                                HStack {
                                                    Text("Set \(set.setNumber)")
                                                    Spacer()
                                                    Text("\(set.actualReps) reps")
                                                    Spacer()
                                                    Text("\(String(format: "%.1f", set.actualWeight)) kg")
                                                }
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding(.leading)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Workout History")
            .task {
                await viewModel.loadWorkouts()
            }
        }
    }
}

#Preview {
    WorkoutHistoryView()
} 