import '../models/farm_model.dart';

/// Repository interface for Farm operations
///
/// Defines all CRUD operations and queries for Farm entities.
/// Implementations should handle all data access and persistence logic.
///
/// Example usage:
/// ```dart
/// final repository = getIt<FarmRepository>();
/// final farm = await repository.create(newFarm);
/// final farms = await repository.getByUserId(userId);
/// ```
abstract class FarmRepository {
  /// Create a new farm
  ///
  /// Throws [Exception] if farm already exists or validation fails
  Future<Farm> create(Farm farm);

  /// Get farm by ID
  ///
  /// Throws [Exception] if farm not found
  Future<Farm> getById(String farmId);

  /// Get all farms where user is a member (via people subcollection)
  ///
  /// Uses collectionGroup query to find all farms where the user
  /// has a person document with matching userId
  Future<List<Farm>> getByUserId(String userId);

  /// Update an existing farm
  ///
  /// Throws [Exception] if farm not found or validation fails
  Future<Farm> update(Farm farm);

  /// Delete a farm and all its subcollections
  ///
  /// WARNING: This will delete all associated data (people, lots, transactions, etc.)
  /// Throws [Exception] if farm not found
  Future<void> delete(String farmId);

  /// Search farms by name
  ///
  /// Returns farms where name contains the query string (case-insensitive)
  Future<List<Farm>> search(String query);

  /// Get all farms created by a specific user
  ///
  /// Different from [getByUserId] - this returns farms where the user
  /// is the creator, not just a member
  Future<List<Farm>> getByCreator(String userId);

  /// Watch farm changes in real-time
  ///
  /// Returns a stream that emits the farm whenever it changes
  Stream<Farm> watchById(String farmId);

  /// Watch all farms for a user in real-time
  ///
  /// Returns a stream that emits the list of farms whenever any farm changes
  Stream<List<Farm>> watchByUserId(String userId);

  /// Check if a farm exists
  Future<bool> exists(String farmId);

  /// Get total count of farms
  Future<int> count();

  /// Generate a new unique ID for a farm
  ///
  /// Returns a Firestore-generated document ID
  String generateId();
}
