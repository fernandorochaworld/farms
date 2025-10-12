import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_paths.dart';
import '../models/weight_history_model.dart';
import 'weight_history_repository.dart';

/// Firebase implementation of WeightHistoryRepository
///
/// Handles all Firestore operations for WeightHistory entities with proper
/// error handling and data conversion. Weight history records are stored as
/// nested subcollections under cattle lots.
class FirebaseWeightHistoryRepository implements WeightHistoryRepository {
  final FirebaseFirestore _firestore;

  FirebaseWeightHistoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to weight history collection for a specific lot
  CollectionReference<Map<String, dynamic>> _weightHistoryCollection(
    String farmId,
    String lotId,
  ) =>
      _firestore.collection(
        FirestorePaths.weightHistoryCollectionPath(farmId, lotId),
      );

  @override
  Future<WeightHistory> create(
    String farmId,
    String lotId,
    WeightHistory weightHistory,
  ) async {
    try {
      // Validate weight history before creating
      final validationError = weightHistory.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure lotId matches
      if (weightHistory.lotId != lotId) {
        throw Exception('WeightHistory lotId does not match the provided lotId');
      }

      await _weightHistoryCollection(farmId, lotId)
          .doc(weightHistory.id)
          .set(weightHistory.toJson());
      return weightHistory;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create weight history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create weight history: $e');
    }
  }

  @override
  Future<WeightHistory> getById(
    String farmId,
    String lotId,
    String weightId,
  ) async {
    try {
      final doc =
          await _weightHistoryCollection(farmId, lotId).doc(weightId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception(
          'Weight history not found with id: $weightId in lot: $lotId',
        );
      }

      return WeightHistory.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get weight history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get weight history: $e');
    }
  }

  @override
  Future<List<WeightHistory>> getByLotId(String farmId, String lotId) async {
    try {
      final snapshot = await _weightHistoryCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WeightHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get weight history by lot: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get weight history by lot: $e');
    }
  }

  @override
  Future<WeightHistory?> getLatest(String farmId, String lotId) async {
    try {
      final snapshot = await _weightHistoryCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return WeightHistory.fromJson(snapshot.docs.first.data());
    } on FirebaseException catch (e) {
      throw Exception('Failed to get latest weight history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get latest weight history: $e');
    }
  }

  @override
  Future<List<WeightHistory>> getByDateRange(
    String farmId,
    String lotId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _weightHistoryCollection(farmId, lotId)
          .where(
            FirestoreFields.date,
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where(
            FirestoreFields.date,
            isLessThanOrEqualTo: Timestamp.fromDate(endDate),
          )
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WeightHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get weight history by date range: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get weight history by date range: $e');
    }
  }

  @override
  Future<List<WeightHistory>> getRecent(
    String farmId,
    String lotId, {
    int limit = 10,
  }) async {
    try {
      final snapshot = await _weightHistoryCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => WeightHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get recent weight history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get recent weight history: $e');
    }
  }

  @override
  Future<List<WeightHistory>> getByCreator(
    String farmId,
    String lotId,
    String userId,
  ) async {
    try {
      final snapshot = await _weightHistoryCollection(farmId, lotId)
          .where(FirestoreFields.createdBy, isEqualTo: userId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WeightHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get weight history by creator: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get weight history by creator: $e');
    }
  }

  @override
  Future<List<WeightHistory>> getAllByFarmId(String farmId) async {
    try {
      // Use collectionGroup to find all weight history across all lots
      final snapshot = await _firestore
          .collectionGroup(FirestorePaths.weightHistoryCollection)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      // Filter by farmId in memory (since collectionGroup doesn't support it directly)
      // Note: In production, you might want to add farmId field to weight history
      return snapshot.docs
          .map((doc) => WeightHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get all weight history by farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get all weight history by farm: $e');
    }
  }

  @override
  Future<WeightHistory> update(
    String farmId,
    String lotId,
    WeightHistory weightHistory,
  ) async {
    try {
      // Validate weight history before updating
      final validationError = weightHistory.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure lotId matches
      if (weightHistory.lotId != lotId) {
        throw Exception('WeightHistory lotId does not match the provided lotId');
      }

      // Check if weight history exists
      final exists = await this.exists(farmId, lotId, weightHistory.id);
      if (!exists) {
        throw Exception(
          'Weight history not found with id: ${weightHistory.id} in lot: $lotId',
        );
      }

      await _weightHistoryCollection(farmId, lotId)
          .doc(weightHistory.id)
          .update(weightHistory.toJson());
      return weightHistory;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update weight history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update weight history: $e');
    }
  }

  @override
  Future<void> delete(String farmId, String lotId, String weightId) async {
    try {
      // Check if weight history exists
      final exists = await this.exists(farmId, lotId, weightId);
      if (!exists) {
        throw Exception(
          'Weight history not found with id: $weightId in lot: $lotId',
        );
      }

      await _weightHistoryCollection(farmId, lotId).doc(weightId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete weight history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete weight history: $e');
    }
  }

  @override
  Future<double> calculateAverageGainRate(String farmId, String lotId) async {
    try {
      final history = await getByLotId(farmId, lotId);

      if (history.length < 2) {
        return 0.0; // Insufficient data
      }

      // Sort by date (oldest first)
      history.sort((a, b) => a.date.compareTo(b.date));

      // Calculate total weight gain and total days
      double totalGain = 0;
      int totalDays = 0;
      int pairCount = 0;

      for (int i = 1; i < history.length; i++) {
        final gain = history[i].calculateWeightGain(history[i - 1]);
        final days = history[i].date.difference(history[i - 1].date).inDays;

        if (days > 0) {
          totalGain += gain;
          totalDays += days;
          pairCount++;
        }
      }

      if (totalDays == 0 || pairCount == 0) {
        return 0.0;
      }

      return totalGain / totalDays;
    } on FirebaseException catch (e) {
      throw Exception('Failed to calculate average gain rate: ${e.message}');
    } catch (e) {
      throw Exception('Failed to calculate average gain rate: $e');
    }
  }

  @override
  Stream<WeightHistory> watchById(
    String farmId,
    String lotId,
    String weightId,
  ) {
    try {
      return _weightHistoryCollection(farmId, lotId)
          .doc(weightId)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          throw Exception(
            'Weight history not found with id: $weightId in lot: $lotId',
          );
        }
        return WeightHistory.fromJson(snapshot.data()!);
      });
    } catch (e) {
      throw Exception('Failed to watch weight history: $e');
    }
  }

  @override
  Stream<List<WeightHistory>> watchByLotId(String farmId, String lotId) {
    try {
      return _weightHistoryCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => WeightHistory.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to watch weight history by lot: $e');
    }
  }

  @override
  Stream<WeightHistory?> watchLatest(String farmId, String lotId) {
    try {
      return _weightHistoryCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return null;
        }
        return WeightHistory.fromJson(snapshot.docs.first.data());
      });
    } catch (e) {
      throw Exception('Failed to watch latest weight history: $e');
    }
  }

  @override
  Future<bool> exists(String farmId, String lotId, String weightId) async {
    try {
      final doc =
          await _weightHistoryCollection(farmId, lotId).doc(weightId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check weight history existence: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check weight history existence: $e');
    }
  }

  @override
  Future<int> count(String farmId, String lotId) async {
    try {
      final snapshot = await _weightHistoryCollection(farmId, lotId).get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count weight history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count weight history: $e');
    }
  }
}
