import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_paths.dart';
import '../models/farm_model.dart';
import 'farm_repository.dart';

/// Firebase implementation of FarmRepository
///
/// Handles all Firestore operations for Farm entities with proper
/// error handling and data conversion.
class FirebaseFarmRepository implements FarmRepository {
  final FirebaseFirestore _firestore;

  FirebaseFarmRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to farms collection
  CollectionReference<Map<String, dynamic>> get _farmsCollection =>
      _firestore.collection(FirestorePaths.farmsCollection);

  @override
  Future<Farm> create(Farm farm) async {
    try {
      // Validate farm before creating
      final validationError = farm.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      await _farmsCollection.doc(farm.id).set(farm.toJson());
      return farm;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create farm: $e');
    }
  }

  @override
  Future<Farm> getById(String farmId) async {
    try {
      final doc = await _farmsCollection.doc(farmId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Farm not found with id: $farmId');
      }

      return Farm.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get farm: $e');
    }
  }

  @override
  Future<List<Farm>> getByUserId(String userId) async {
    try {
      // Use collectionGroup to find all people subcollections
      final peopleQuery = await _firestore
          .collectionGroup(FirestorePaths.peopleCollection)
          .where(FirestoreFields.userId, isEqualTo: userId)
          .get();

      if (peopleQuery.docs.isEmpty) {
        return [];
      }

      // Extract unique farm IDs from the people documents
      final farmIds = peopleQuery.docs
          .map((doc) => doc.data()[FirestoreFields.farmId] as String)
          .toSet()
          .toList();

      // Fetch all farms
      final farms = <Farm>[];
      for (final farmId in farmIds) {
        try {
          final farm = await getById(farmId);
          farms.add(farm);
        } catch (e) {
          // Skip farms that don't exist or can't be accessed
          continue;
        }
      }

      // Sort by creation date (newest first)
      farms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return farms;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get farms by user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get farms by user: $e');
    }
  }

  @override
  Future<Farm> update(Farm farm) async {
    try {
      // Validate farm before updating
      final validationError = farm.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Check if farm exists
      final exists = await this.exists(farm.id);
      if (!exists) {
        throw Exception('Farm not found with id: ${farm.id}');
      }

      // Update with new timestamp
      final updatedFarm = farm.copyWith(updatedAt: DateTime.now());
      await _farmsCollection.doc(farm.id).update(updatedFarm.toJson());
      return updatedFarm;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update farm: $e');
    }
  }

  @override
  Future<void> delete(String farmId) async {
    try {
      // Check if farm exists
      final exists = await this.exists(farmId);
      if (!exists) {
        throw Exception('Farm not found with id: $farmId');
      }

      // Note: In a production app, you should delete all subcollections
      // (people, cattle_lots, goals, services) before deleting the farm
      // For now, we'll just delete the farm document
      // TODO: Implement cascade delete for subcollections
      await _farmsCollection.doc(farmId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete farm: $e');
    }
  }

  @override
  Future<List<Farm>> search(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      // Note: Firestore doesn't support case-insensitive searches natively
      // This is a simple implementation that fetches all farms and filters
      // For production, consider using Algolia or similar search service
      final snapshot = await _farmsCollection.get();

      final farms = snapshot.docs
          .map((doc) => Farm.fromJson(doc.data()))
          .where((farm) =>
              farm.name.toLowerCase().contains(query.toLowerCase()) ||
              farm.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Sort by relevance (name matches first, then description matches)
      farms.sort((a, b) {
        final aNameMatch = a.name.toLowerCase().contains(query.toLowerCase());
        final bNameMatch = b.name.toLowerCase().contains(query.toLowerCase());
        if (aNameMatch && !bNameMatch) return -1;
        if (!aNameMatch && bNameMatch) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      return farms;
    } on FirebaseException catch (e) {
      throw Exception('Failed to search farms: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search farms: $e');
    }
  }

  @override
  Future<List<Farm>> getByCreator(String userId) async {
    try {
      final snapshot = await _farmsCollection
          .where(FirestoreFields.createdBy, isEqualTo: userId)
          .orderBy(FirestoreFields.createdAt, descending: true)
          .get();

      return snapshot.docs.map((doc) => Farm.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get farms by creator: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get farms by creator: $e');
    }
  }

  @override
  Stream<Farm> watchById(String farmId) {
    try {
      return _farmsCollection.doc(farmId).snapshots().map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          throw Exception('Farm not found with id: $farmId');
        }
        return Farm.fromJson(snapshot.data()!);
      });
    } catch (e) {
      throw Exception('Failed to watch farm: $e');
    }
  }

  @override
  Stream<List<Farm>> watchByUserId(String userId) {
    try {
      // Watch the people collectionGroup for changes
      return _firestore
          .collectionGroup(FirestorePaths.peopleCollection)
          .where(FirestoreFields.userId, isEqualTo: userId)
          .snapshots()
          .asyncMap((peopleSnapshot) async {
        if (peopleSnapshot.docs.isEmpty) {
          return <Farm>[];
        }

        // Extract unique farm IDs
        final farmIds = peopleSnapshot.docs
            .map((doc) => doc.data()[FirestoreFields.farmId] as String)
            .toSet()
            .toList();

        // Fetch all farms
        final farms = <Farm>[];
        for (final farmId in farmIds) {
          try {
            final farm = await getById(farmId);
            farms.add(farm);
          } catch (e) {
            // Skip farms that don't exist or can't be accessed
            continue;
          }
        }

        // Sort by creation date (newest first)
        farms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return farms;
      });
    } catch (e) {
      throw Exception('Failed to watch farms by user: $e');
    }
  }

  @override
  Future<bool> exists(String farmId) async {
    try {
      final doc = await _farmsCollection.doc(farmId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check farm existence: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check farm existence: $e');
    }
  }

  @override
  Future<int> count() async {
    try {
      final snapshot = await _farmsCollection.get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count farms: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count farms: $e');
    }
  }
}
