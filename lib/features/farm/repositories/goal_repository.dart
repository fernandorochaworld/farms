import '../constants/enums.dart';
import '../models/goal_model.dart';

/// Repository interface for Goal operations
///
/// Defines all CRUD operations and queries for Goal entities.
/// Goals are stored as a subcollection under farms.
///
/// Example usage:
/// ```dart
/// final repository = getIt<GoalRepository>();
/// final goal = await repository.create(farmId, newGoal);
/// final activeGoals = await repository.getActive(farmId);
/// ```
abstract class GoalRepository {
  /// Create a new goal in a farm
  ///
  /// Throws [Exception] if goal already exists or validation fails
  Future<Goal> create(String farmId, Goal goal);

  /// Get goal by ID
  ///
  /// Throws [Exception] if goal not found
  Future<Goal> getById(String farmId, String goalId);

  /// Get all goals in a farm
  ///
  /// Returns list sorted by goal date (newest first)
  Future<List<Goal>> getByFarmId(String farmId);

  /// Get active goals (status is active)
  ///
  /// Returns list sorted by goal date (nearest first)
  Future<List<Goal>> getActive(String farmId);

  /// Get completed goals
  ///
  /// Returns goals that have been marked as completed
  Future<List<Goal>> getCompleted(String farmId);

  /// Get overdue goals
  ///
  /// Returns goals that are past their goal date but not completed
  Future<List<Goal>> getOverdue(String farmId);

  /// Get goals by status
  ///
  /// Returns goals with a specific status
  Future<List<Goal>> getByStatus(String farmId, GoalStatus status);

  /// Get goals by date range
  ///
  /// Returns goals with goal dates within the specified range
  Future<List<Goal>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get upcoming goals (active goals due in next N days)
  ///
  /// Returns active goals due within the specified number of days
  Future<List<Goal>> getUpcoming(String farmId, {int days = 30});

  /// Update an existing goal
  ///
  /// Throws [Exception] if goal not found or validation fails
  Future<Goal> update(String farmId, Goal goal);

  /// Delete a goal
  ///
  /// Throws [Exception] if goal not found
  Future<void> delete(String farmId, String goalId);

  /// Mark a goal as completed
  ///
  /// Updates goal status to completed and sets updatedAt timestamp
  Future<Goal> markAsCompleted(String farmId, String goalId);

  /// Mark a goal as cancelled
  ///
  /// Updates goal status to cancelled and sets updatedAt timestamp
  Future<Goal> markAsCancelled(String farmId, String goalId);

  /// Update overdue goals
  ///
  /// Automatically marks active goals past their goal date as overdue
  /// Returns the count of goals updated
  Future<int> updateOverdueGoals(String farmId);

  /// Watch goal changes in real-time
  ///
  /// Returns a stream that emits the goal whenever it changes
  Stream<Goal> watchById(String farmId, String goalId);

  /// Watch all goals in a farm in real-time
  ///
  /// Returns a stream that emits the list of goals whenever any goal changes
  Stream<List<Goal>> watchByFarmId(String farmId);

  /// Watch active goals in real-time
  ///
  /// Returns a stream that emits the list of active goals whenever they change
  Stream<List<Goal>> watchActive(String farmId);

  /// Check if a goal exists
  Future<bool> exists(String farmId, String goalId);

  /// Get total count of goals in a farm
  Future<int> count(String farmId);

  /// Get count of active goals in a farm
  Future<int> countActive(String farmId);
}
