import '../constants/enums.dart';
import '../models/farm_service_history_model.dart';

/// Repository interface for FarmServiceHistory operations
///
/// Defines all CRUD operations and queries for FarmServiceHistory entities.
/// Service history records are stored as a subcollection under farms.
///
/// Example usage:
/// ```dart
/// final repository = getIt<FarmServiceRepository>();
/// final service = await repository.create(farmId, newService);
/// final services = await repository.getByFarmId(farmId);
/// ```
abstract class FarmServiceRepository {
  /// Create a new service record in a farm
  ///
  /// Throws [Exception] if service already exists or validation fails
  Future<FarmServiceHistory> create(String farmId, FarmServiceHistory service);

  /// Get service record by ID
  ///
  /// Throws [Exception] if service not found
  Future<FarmServiceHistory> getById(String farmId, String serviceId);

  /// Get all service records in a farm
  ///
  /// Returns list sorted by date (newest first)
  Future<List<FarmServiceHistory>> getByFarmId(String farmId);

  /// Get service records by type
  ///
  /// Returns services of a specific type
  Future<List<FarmServiceHistory>> getByType(
    String farmId,
    ServiceType serviceType,
  );

  /// Get service records by date range
  ///
  /// Returns services with dates within the specified range
  Future<List<FarmServiceHistory>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get recent service records (within last N days)
  ///
  /// Returns services performed within the specified number of days
  Future<List<FarmServiceHistory>> getRecent(String farmId, {int days = 30});

  /// Get medical/health related services
  ///
  /// Returns vaccination, veterinary, medical treatment, and deworming services
  Future<List<FarmServiceHistory>> getMedicalServices(String farmId);

  /// Get service records created by a specific user
  ///
  /// Returns services created by the specified user
  Future<List<FarmServiceHistory>> getByCreator(
    String farmId,
    String userId,
  );

  /// Get total service cost for a date range
  ///
  /// Returns the sum of all service values within the date range
  Future<double> getTotalCost(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get total service cost by type for a date range
  ///
  /// Returns the sum of service values for a specific type within the date range
  Future<double> getTotalCostByType(
    String farmId,
    ServiceType serviceType,
    DateTime startDate,
    DateTime endDate,
  );

  /// Update an existing service record
  ///
  /// Throws [Exception] if service not found or validation fails
  Future<FarmServiceHistory> update(
    String farmId,
    FarmServiceHistory service,
  );

  /// Delete a service record
  ///
  /// Throws [Exception] if service not found
  Future<void> delete(String farmId, String serviceId);

  /// Search service records by description
  ///
  /// Returns services where description contains the query string (case-insensitive)
  Future<List<FarmServiceHistory>> search(String farmId, String query);

  /// Watch service record changes in real-time
  ///
  /// Returns a stream that emits the service whenever it changes
  Stream<FarmServiceHistory> watchById(String farmId, String serviceId);

  /// Watch all service records in a farm in real-time
  ///
  /// Returns a stream that emits the list of services whenever any service changes
  Stream<List<FarmServiceHistory>> watchByFarmId(String farmId);

  /// Watch service records by type in real-time
  ///
  /// Returns a stream that emits the list of services of a specific type
  Stream<List<FarmServiceHistory>> watchByType(
    String farmId,
    ServiceType serviceType,
  );

  /// Watch recent service records in real-time
  ///
  /// Returns a stream that emits recent services (within last N days)
  Stream<List<FarmServiceHistory>> watchRecent(String farmId, {int days = 30});

  /// Check if a service record exists
  Future<bool> exists(String farmId, String serviceId);

  /// Get total count of service records in a farm
  Future<int> count(String farmId);

  /// Get count of services by type
  Future<int> countByType(String farmId, ServiceType serviceType);

  /// Get the last service date for a specific type
  ///
  /// Returns null if no services of that type exist
  Future<DateTime?> getLastServiceDate(
    String farmId,
    ServiceType serviceType,
  );
}
