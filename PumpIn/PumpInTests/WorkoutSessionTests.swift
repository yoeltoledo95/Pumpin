import XCTest
@testable import PumpIn

final class WorkoutSessionTests: XCTestCase {
    var viewModel: WorkoutSessionViewModel!
    var mockWorkout: Workout!
    var mockWorkoutHistoryService: MockWorkoutHistoryService!
    
    override func setUp() {
        super.setUp()
        mockWorkout = Workout(name: "Test Workout")
        mockWorkoutHistoryService = MockWorkoutHistoryService()
        viewModel = WorkoutSessionViewModel(
            workout: mockWorkout,
            workoutHistoryService: mockWorkoutHistoryService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockWorkout = nil
        mockWorkoutHistoryService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNil(viewModel.currentExercise)
        XCTAssertEqual(viewModel.currentSet.targetReps, 0)
        XCTAssertEqual(viewModel.currentSet.targetWeight, 0)
        XCTAssertEqual(viewModel.currentSet.restTime, 0)
        XCTAssertTrue(viewModel.completedExercises.isEmpty)
        XCTAssertFalse(viewModel.isResting)
        XCTAssertEqual(viewModel.restTimeRemaining, 0)
        XCTAssertFalse(viewModel.isSaving)
        XCTAssertNil(viewModel.error)
    }
    
    func testCompleteSet() async {
        // Setup
        let exercise = WorkoutExercise(name: "Test Exercise")
        exercise.addSet(targetReps: 10, targetWeight: 50, restTime: 60)
        mockWorkout.exercises.append(exercise)
        
        // Act
        viewModel.completeSet(actualReps: 12, actualWeight: 52)
        
        // Assert
        XCTAssertEqual(viewModel.completedExercises.count, 1)
        XCTAssertEqual(viewModel.completedExercises[0].name, "Test Exercise")
        XCTAssertEqual(viewModel.completedExercises[0].completedSets.count, 1)
        XCTAssertEqual(viewModel.completedExercises[0].completedSets[0].actualReps, 12)
        XCTAssertEqual(viewModel.completedExercises[0].completedSets[0].actualWeight, 52)
    }
    
    func testFinishWorkout() async {
        // Setup
        let exercise = WorkoutExercise(name: "Test Exercise")
        exercise.addSet(targetReps: 10, targetWeight: 50, restTime: 60)
        mockWorkout.exercises.append(exercise)
        viewModel.completeSet(actualReps: 12, actualWeight: 52)
        
        // Act
        await viewModel.finishWorkout()
        
        // Assert
        XCTAssertFalse(viewModel.isSaving)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(mockWorkoutHistoryService.savedWorkouts.count, 1)
        XCTAssertEqual(mockWorkoutHistoryService.savedWorkouts[0].name, "Test Workout")
    }
}

// MARK: - Mock Service
class MockWorkoutHistoryService: WorkoutHistoryServiceProtocol {
    var savedWorkouts: [WorkoutHistoryViewModel.CompletedWorkout] = []
    
    func saveWorkout(_ workout: WorkoutHistoryViewModel.CompletedWorkout) async throws {
        savedWorkouts.append(workout)
    }
    
    func loadWorkouts() async throws -> [WorkoutHistoryViewModel.CompletedWorkout] {
        return savedWorkouts
    }
} 