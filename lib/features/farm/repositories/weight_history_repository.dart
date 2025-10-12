import '../models/weight_history_model.dart';

/// Repository interface for WeightHistory operations
///
/// Defines all CRUD operations and queries for WeightHistory entities.
/// Weight history records are stored as a subcollection under cattle lots,
/// which are themselves subcollections under farms.
///
/// Example usage:
/// ```dart
/// final repository = getIt<WeightHistoryRepository>();
/// final weight = await repository.create(farmId, lotId, newWeight);
/// final history = await repository.getByLotId(farmId, lotId);
/// ```
abstract class WeightHistoryRepository {
  /// Create a new weight history record in a cattle lot
  ///
  /// Throws [Exception] if record already exists or validation fails
  Future<WeightHistory> create(
    String farmId,
    String lotId,
    WeightHistory weightHistory,
  );

  /// Get weight history record by ID
  ///
  /// Throws [Exception] if record not found
  Future<WeightHistory> getById(
    String farmId,
    String lotId,
    String weightId,
  );

  /// Get all weight history records for a cattle lot
  ///
  /// Returns list sorted by date (newest first)
  Future<List<WeightHistory>> getByLotId(String farmId, String lotId);

  /// Get latest weight history record for a lot
  ///
  /// Returns the most recent weight measurement
  /// Returns null if no weight history exists
  Future<WeightHistory?> getLatest(String farmId, String lotId);

  /// Get weight history records by date range
  ///
  /// Returns records within the specified date range
  Future<List<WeightHistory>> getByDateRange(
    String farmId,
    String lotId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get recent weight history records (last N records)
  ///
  /// Returns the most recent weight measurements
  Future<List<WeightHistory>> getRecent(
    String farmId,
    String lotId, {
    int limit = 10,
  });

  /// Get weight history records created by a specific user
  ///
  /// Returns records created by the specified user
  Future<List<WeightHistory>> getByCreator(
    String farmId,
    String lotId,
    String userId,
  );

  /// Get all weight history records across all lots in a farm
  ///
  /// Uses collectionGroup query to find all weight history
  Future<List<WeightHistory>> getAllByFarmId(String farmId);

  /// Update an existing weight history record
  ///
  /// Throws [Exception] if record not found or validation fails
  Future<WeightHistory> update(
    String farmId,
    String lotId,
    WeightHistory weightHistory,
  );

  /// Delete a weight history record
  ///
  /// Throws [Exception] if record not found
  Future<void> delete(String farmId, String lotId, String weightId);

  /// Calculate average weight gain rate for a lot
  ///
  /// Returns the average daily weight gain in kg based on weight history
  /// Returns 0 if insufficient data
  Future<double> calculateAverageGainRate(String farmId, String lotId);

  /// Watch weight history record changes in real-time
  ///
  /// Returns a stream that emits the record whenever it changes
  Stream<WeightHistory> watchById(
    String farmId,
    String lotId,
    String weightId,
  );

  /// Watch all weight history records for a lot in real-time
  ///
  /// Returns a stream that emits the list of records whenever any changes
  Stream<List<WeightHistory>> watchByLotId(String farmId, String lotId);

  /// Watch latest weight history record in real-time
  ///
  /// Returns a stream that emits the latest record whenever it changes
  Stream<WeightHistory?> watchLatest(String farmId, String lotId);

  /// Check if a weight history record exists
  Future<bool> exists(String farmId, String lotId, String weightId);

  /// Get total count of weight history records in a lot
  Future<int> count(String farmId, String lotId);
}
