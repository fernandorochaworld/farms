import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';
import '../models/cattle_lot_model.dart';
import 'cattle_lot_repository.dart';

/// Firebase implementation of CattleLotRepository
///
/// Handles all Firestore operations for CattleLot entities with proper
/// error handling and data conversion. Cattle lots are stored as subcollections
/// under farms.
class FirebaseCattleLotRepository implements CattleLotRepository {
  final FirebaseFirestore _firestore;

  FirebaseCattleLotRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to cattle lots collection for a specific farm
  CollectionReference<Map<String, dynamic>> _lotsCollection(String farmId) =>
      _firestore.collection(FirestorePaths.cattleLotsCollectionPath(farmId));

  @override
  Future<CattleLot> create(String farmId, CattleLot lot) async {
    try {
      // Validate lot before creating
      final validationError = lot.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (lot.farmId != farmId) {
        throw Exception('Lot farmId does not match the provided farmId');
      }

      await _lotsCollection(farmId).doc(lot.id).set(lot.toJson());
      return lot;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create cattle lot: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create cattle lot: $e');
    }
  }

  @override
  Future<CattleLot> getById(String farmId, String lotId) async {
    try {
      final doc = await _lotsCollection(farmId).doc(lotId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Cattle lot not found with id: $lotId in farm: $farmId');
      }

      return CattleLot.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get cattle lot: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get cattle lot: $e');
    }
  }

  @override
  Future<List<CattleLot>> getByFarmId(String farmId) async {
    try {
      final snapshot = await _lotsCollection(farmId)
          .orderBy(FirestoreFields.startDate, descending: true)
          .get();

      return snapshot.docs.map((doc) => CattleLot.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get cattle lots by farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get cattle lots by farm: $e');
    }
  }

  @override
  Future<List<CattleLot>> getActive(String farmId) async {
    try {
      // Get all lots and filter in memory (Firestore doesn't support compound queries easily)
      final allLots = await getByFarmId(farmId);
      return allLots.where((lot) => lot.isActive).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get active cattle lots: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get active cattle lots: $e');
    }
  }

  @override
  Future<List<CattleLot>> getByType(String farmId, CattleType cattleType) async {
    try {
      final snapshot = await _lotsCollection(farmId)
          .where(FirestoreFields.cattleType, isEqualTo: cattleType.toJson())
          .orderBy(FirestoreFields.startDate, descending: true)
          .get();

      return snapshot.docs.map((doc) => CattleLot.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get cattle lots by type: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get cattle lots by type: $e');
    }
  }

  @override
  Future<List<CattleLot>> getByGender(String farmId, CattleGender gender) async {
    try {
      final snapshot = await _lotsCollection(farmId)
          .where(FirestoreFields.gender, isEqualTo: gender.toJson())
          .orderBy(FirestoreFields.startDate, descending: true)
          .get();

      return snapshot.docs.map((doc) => CattleLot.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get cattle lots by gender: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get cattle lots by gender: $e');
    }
  }

  @override
  Future<List<CattleLot>> getClosed(String farmId) async {
    try {
      // Get all lots and filter in memory
      final allLots = await getByFarmId(farmId);
      final closedLots = allLots.where((lot) => lot.isClosed).toList();

      // Sort by end date (newest first)
      closedLots.sort((a, b) => b.endDate!.compareTo(a.endDate!));
      return closedLots;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get closed cattle lots: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get closed cattle lots: $e');
    }
  }

  @override
  Future<List<CattleLot>> getEmpty(String farmId) async {
    try {
      // Get all lots and filter in memory
      final allLots = await getByFarmId(farmId);
      return allLots.where((lot) => lot.isEmpty).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get empty cattle lots: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get empty cattle lots: $e');
    }
  }

  @override
  Future<CattleLot> update(String farmId, CattleLot lot) async {
    try {
      // Validate lot before updating
      final validationError = lot.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (lot.farmId != farmId) {
        throw Exception('Lot farmId does not match the provided farmId');
      }

      // Check if lot exists
      final exists = await this.exists(farmId, lot.id);
      if (!exists) {
        throw Exception('Cattle lot not found with id: ${lot.id} in farm: $farmId');
      }

      // Update with new timestamp
      final updatedLot = lot.copyWith(updatedAt: DateTime.now());
      await _lotsCollection(farmId).doc(lot.id).update(updatedLot.toJson());
      return updatedLot;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update cattle lot: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update cattle lot: $e');
    }
  }

  @override
  Future<void> delete(String farmId, String lotId) async {
    try {
      // Check if lot exists
      final exists = await this.exists(farmId, lotId);
      if (!exists) {
        throw Exception('Cattle lot not found with id: $lotId in farm: $farmId');
      }

      // Note: In production, you should delete all subcollections
      // (transactions, weight_history) before deleting the lot
      // TODO: Implement cascade delete for subcollections
      await _lotsCollection(farmId).doc(lotId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete cattle lot: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete cattle lot: $e');
    }
  }

  @override
  Future<List<CattleLot>> search(String farmId, String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      // Get all lots and filter in memory
      final allLots = await getByFarmId(farmId);
      final filteredLots = allLots
          .where((lot) => lot.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return filteredLots;
    } on FirebaseException catch (e) {
      throw Exception('Failed to search cattle lots: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search cattle lots: $e');
    }
  }

  @override
  Stream<CattleLot> watchById(String farmId, String lotId) {
    try {
      return _lotsCollection(farmId).doc(lotId).snapshots().map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          throw Exception('Cattle lot not found with id: $lotId in farm: $farmId');
        }
        return CattleLot.fromJson(snapshot.data()!);
      });
    } catch (e) {
      throw Exception('Failed to watch cattle lot: $e');
    }
  }

  @override
  Stream<List<CattleLot>> watchByFarmId(String farmId) {
    try {
      return _lotsCollection(farmId)
          .orderBy(FirestoreFields.startDate, descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => CattleLot.fromJson(doc.data())).toList());
    } catch (e) {
      throw Exception('Failed to watch cattle lots by farm: $e');
    }
  }

  @override
  Stream<List<CattleLot>> watchActive(String farmId) {
    try {
      return watchByFarmId(farmId).map(
        (lots) => lots.where((lot) => lot.isActive).toList(),
      );
    } catch (e) {
      throw Exception('Failed to watch active cattle lots: $e');
    }
  }

  @override
  Future<bool> exists(String farmId, String lotId) async {
    try {
      final doc = await _lotsCollection(farmId).doc(lotId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check cattle lot existence: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check cattle lot existence: $e');
    }
  }

  @override
  Future<int> count(String farmId) async {
    try {
      final snapshot = await _lotsCollection(farmId).get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count cattle lots: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count cattle lots: $e');
    }
  }

  @override
  Future<int> countActive(String farmId) async {
    try {
      final activeLots = await getActive(farmId);
      return activeLots.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count active cattle lots: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count active cattle lots: $e');
    }
  }

  @override
  Future<int> getTotalCattleCount(String farmId) async {
    try {
      final activeLots = await getActive(farmId);
      return activeLots.fold<int>(
        0,
        (sum, lot) => sum + lot.currentQuantity,
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to get total cattle count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get total cattle count: $e');
    }
  }
}
