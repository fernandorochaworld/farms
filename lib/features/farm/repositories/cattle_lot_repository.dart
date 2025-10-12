import '../constants/enums.dart';
import '../models/cattle_lot_model.dart';

/// Repository interface for CattleLot operations
///
/// Defines all CRUD operations and queries for CattleLot entities.
/// Cattle lots are stored as a subcollection under farms.
///
/// Example usage:
/// ```dart
/// final repository = getIt<CattleLotRepository>();
/// final lot = await repository.create(farmId, newLot);
/// final activeLots = await repository.getActive(farmId);
/// ```
abstract class CattleLotRepository {
  /// Create a new cattle lot in a farm
  ///
  /// Throws [Exception] if lot already exists or validation fails
  Future<CattleLot> create(String farmId, CattleLot lot);

  /// Get cattle lot by ID
  ///
  /// Throws [Exception] if lot not found
  Future<CattleLot> getById(String farmId, String lotId);

  /// Get all cattle lots in a farm
  ///
  /// Returns list sorted by start date (newest first)
  Future<List<CattleLot>> getByFarmId(String farmId);

  /// Get active cattle lots (endDate is null and currentQuantity > 0)
  ///
  /// Returns list sorted by start date (newest first)
  Future<List<CattleLot>> getActive(String farmId);

  /// Get cattle lots by type
  ///
  /// Returns lots of a specific cattle type
  Future<List<CattleLot>> getByType(String farmId, CattleType cattleType);

  /// Get cattle lots by gender
  ///
  /// Returns lots of a specific gender composition
  Future<List<CattleLot>> getByGender(String farmId, CattleGender gender);

  /// Get closed cattle lots (endDate is not null)
  ///
  /// Returns list sorted by end date (newest first)
  Future<List<CattleLot>> getClosed(String farmId);

  /// Get empty cattle lots (currentQuantity <= 0)
  ///
  /// Returns lots with no cattle remaining
  Future<List<CattleLot>> getEmpty(String farmId);

  /// Update an existing cattle lot
  ///
  /// Throws [Exception] if lot not found or validation fails
  Future<CattleLot> update(String farmId, CattleLot lot);

  /// Delete a cattle lot and its subcollections (transactions, weight history)
  ///
  /// WARNING: This will delete all associated data
  /// Throws [Exception] if lot not found
  Future<void> delete(String farmId, String lotId);

  /// Search cattle lots by name
  ///
  /// Returns lots where name contains the query string (case-insensitive)
  Future<List<CattleLot>> search(String farmId, String query);

  /// Watch cattle lot changes in real-time
  ///
  /// Returns a stream that emits the lot whenever it changes
  Stream<CattleLot> watchById(String farmId, String lotId);

  /// Watch all cattle lots in a farm in real-time
  ///
  /// Returns a stream that emits the list of lots whenever any lot changes
  Stream<List<CattleLot>> watchByFarmId(String farmId);

  /// Watch active cattle lots in real-time
  ///
  /// Returns a stream that emits the list of active lots whenever they change
  Stream<List<CattleLot>> watchActive(String farmId);

  /// Check if a cattle lot exists
  Future<bool> exists(String farmId, String lotId);

  /// Get total count of cattle lots in a farm
  Future<int> count(String farmId);

  /// Get total count of active cattle lots in a farm
  Future<int> countActive(String farmId);

  /// Get total cattle quantity across all active lots in a farm
  Future<int> getTotalCattleCount(String farmId);
}
