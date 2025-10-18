import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_paths.dart';
import '../models/person_model.dart';
import 'person_repository.dart';

/// Firebase implementation of PersonRepository
///
/// Handles all Firestore operations for Person entities with proper
/// error handling and data conversion. People are stored as subcollections
/// under farms.
class FirebasePersonRepository implements PersonRepository {
  final FirebaseFirestore _firestore;

  FirebasePersonRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to people collection for a specific farm
  CollectionReference<Map<String, dynamic>> _peopleCollection(String farmId) =>
      _firestore.collection(FirestorePaths.peopleCollectionPath(farmId));

  @override
  String generateId(String farmId) => _peopleCollection(farmId).doc().id;

  @override
  Future<Person> create(String farmId, Person person) async {
    try {
      // Validate person before creating
      final validationError = person.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (person.farmId != farmId) {
        throw Exception('Person farmId does not match the provided farmId');
      }

      await _peopleCollection(farmId).doc(person.id).set(person.toJson());
      return person;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create person: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create person: $e');
    }
  }

  @override
  Future<Person> getById(String farmId, String personId) async {
    try {
      final doc = await _peopleCollection(farmId).doc(personId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Person not found with id: $personId in farm: $farmId');
      }

      return Person.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get person: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get person: $e');
    }
  }

  @override
  Future<List<Person>> getByFarmId(String farmId) async {
    try {
      final snapshot = await _peopleCollection(farmId)
          .orderBy(FirestoreFields.createdAt, descending: false)
          .get();

      return snapshot.docs.map((doc) => Person.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get people by farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get people by farm: $e');
    }
  }

  @override
  Future<List<Person>> getByUserId(String userId) async {
    try {
      // Use collectionGroup to find all people subcollections
      final snapshot = await _firestore
          .collectionGroup(FirestorePaths.peopleCollection)
          .where(FirestoreFields.userId, isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) => Person.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get people by user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get people by user: $e');
    }
  }

  @override
  Future<Person?> getByUserIdInFarm(String farmId, String userId) async {
    try {
      // Get all people for the farm and filter in memory to avoid index requirement
      final snapshot = await _peopleCollection(farmId).get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      // Find person with matching userId
      for (final doc in snapshot.docs) {
        final person = Person.fromJson(doc.data());
        if (person.userId == userId) {
          return person;
        }
      }

      return null;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get person by user in farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get person by user in farm: $e');
    }
  }

  @override
  Future<Person> update(String farmId, Person person) async {
    try {
      // Validate person before updating
      final validationError = person.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (person.farmId != farmId) {
        throw Exception('Person farmId does not match the provided farmId');
      }

      // Check if person exists
      final exists = await this.exists(farmId, person.id);
      if (!exists) {
        throw Exception('Person not found with id: ${person.id} in farm: $farmId');
      }

      await _peopleCollection(farmId).doc(person.id).update(person.toJson());
      return person;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update person: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update person: $e');
    }
  }

  @override
  Future<void> delete(String farmId, String personId) async {
    try {
      // Check if person exists
      final exists = await this.exists(farmId, personId);
      if (!exists) {
        throw Exception('Person not found with id: $personId in farm: $farmId');
      }

      await _peopleCollection(farmId).doc(personId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete person: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete person: $e');
    }
  }

  @override
  Future<List<Person>> getAdmins(String farmId) async {
    try {
      final snapshot = await _peopleCollection(farmId)
          .where(FirestoreFields.isAdmin, isEqualTo: true)
          .orderBy(FirestoreFields.createdAt, descending: false)
          .get();

      return snapshot.docs.map((doc) => Person.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get admin people: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get admin people: $e');
    }
  }

  @override
  Future<bool> isMember(String farmId, String userId) async {
    try {
      final person = await getByUserIdInFarm(farmId, userId);
      return person != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isAdmin(String farmId, String userId) async {
    try {
      final person = await getByUserIdInFarm(farmId, userId);
      return person?.isAdmin ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<Person> watchById(String farmId, String personId) {
    try {
      return _peopleCollection(farmId).doc(personId).snapshots().map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          throw Exception('Person not found with id: $personId in farm: $farmId');
        }
        return Person.fromJson(snapshot.data()!);
      });
    } catch (e) {
      throw Exception('Failed to watch person: $e');
    }
  }

  @override
  Stream<List<Person>> watchByFarmId(String farmId) {
    try {
      return _peopleCollection(farmId)
          .orderBy(FirestoreFields.createdAt, descending: false)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Person.fromJson(doc.data())).toList());
    } catch (e) {
      throw Exception('Failed to watch people by farm: $e');
    }
  }

  @override
  Future<bool> exists(String farmId, String personId) async {
    try {
      final doc = await _peopleCollection(farmId).doc(personId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check person existence: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check person existence: $e');
    }
  }

  @override
  Future<int> count(String farmId) async {
    try {
      final snapshot = await _peopleCollection(farmId).get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count people: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count people: $e');
    }
  }
}
