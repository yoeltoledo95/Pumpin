import SwiftUI

struct WorkoutSplitView: View {
    @StateObject private var viewModel = WorkoutSplitViewModel()
    @State private var showingAddDaySheet = false
    @State private var showingAddExerciseSheet = false
    @State private var selectedDayIndex: Int?
    @State private var newDayName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.workoutPlan.days.indices, id: \.self) { dayIndex in
                    let day = viewModel.workoutPlan.days[dayIndex]
                    Section(header: Text(day.name)) {
                        ForEach(day.exercises) { exercise in
                            ExerciseRow(exercise: exercise)
                        }
                        .onDelete { indices in
                            guard let index = indices.first else { return }
                            viewModel.removeExercise(from: dayIndex, at: index)
                            viewModel.save()
                        }
                        .onMove { source, destination in
                            viewModel.moveExercise(in: dayIndex, from: source, to: destination)
                            viewModel.save()
                        }
                        
                        Button(action: {
                            selectedDayIndex = dayIndex
                            showingAddExerciseSheet = true
                        }) {
                            Label("Add Exercise", systemImage: "plus.circle")
                        }
                    }
                }
                .onDelete { indices in
                    guard let index = indices.first else { return }
                    viewModel.removeDay(at: index)
                    viewModel.save()
                }
                .onMove { source, destination in
                    viewModel.moveDay(from: source, to: destination)
                    viewModel.save()
                }
            }
            .navigationTitle("Workout Split")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddDaySheet = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddDaySheet) {
                AddDaySheet(newDayName: $newDayName) { name in
                    viewModel.addDay(name: name)
                    viewModel.save()
                }
            }
            .sheet(isPresented: $showingAddExerciseSheet) {
                if let dayIndex = selectedDayIndex {
                    AddExerciseSheet { exercise in
                        viewModel.addExercise(to: dayIndex, exercise: exercise)
                        viewModel.save()
                    }
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
}

#Preview {
    WorkoutSplitView()
} 