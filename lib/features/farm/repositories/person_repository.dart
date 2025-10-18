import '../models/person_model.dart';

/// Repository interface for Person operations
///
/// Defines all CRUD operations and queries for Person entities.
/// People are stored as a subcollection under farms.
///
/// Example usage:
/// ```dart
/// final repository = getIt<PersonRepository>();
/// final person = await repository.create(farmId, newPerson);
/// final people = await repository.getByFarmId(farmId);
/// ```
abstract class PersonRepository {
  /// Create a new person in a farm
  ///
  /// Throws [Exception] if person already exists or validation fails
  Future<Person> create(String farmId, Person person);

  /// Get person by ID
  ///
  /// Throws [Exception] if person not found
  Future<Person> getById(String farmId, String personId);

  /// Get all people in a farm
  ///
  /// Returns list sorted by creation date (oldest first)
  Future<List<Person>> getByFarmId(String farmId);

  /// Get all farms where a user is a person
  ///
  /// Returns list of person records for a specific user across all farms
  Future<List<Person>> getByUserId(String userId);

  /// Get person by user ID within a specific farm
  ///
  /// Returns null if user is not a member of the farm
  Future<Person?> getByUserIdInFarm(String farmId, String userId);

  /// Update an existing person
  ///
  /// Throws [Exception] if person not found or validation fails
  Future<Person> update(String farmId, Person person);

  /// Delete a person from a farm
  ///
  /// Throws [Exception] if person not found
  Future<void> delete(String farmId, String personId);

  /// Get admin users for a farm
  ///
  /// Returns all people marked as admin for the farm
  Future<List<Person>> getAdmins(String farmId);

  /// Check if a user is a member of a farm
  Future<bool> isMember(String farmId, String userId);

  /// Check if a user is an admin of a farm
  Future<bool> isAdmin(String farmId, String userId);

  /// Watch person changes in real-time
  ///
  /// Returns a stream that emits the person whenever it changes
  Stream<Person> watchById(String farmId, String personId);

  /// Watch all people in a farm in real-time
  ///
  /// Returns a stream that emits the list of people whenever any person changes
  Stream<List<Person>> watchByFarmId(String farmId);

  /// Check if a person exists
  Future<bool> exists(String farmId, String personId);

  /// Get total count of people in a farm
  Future<int> count(String farmId);

  /// Generate a new unique ID for a person in a farm
  ///
  /// Returns a Firestore-generated document ID
  String generateId(String farmId);
}
