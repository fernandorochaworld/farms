import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';
import '../models/goal_model.dart';
import 'goal_repository.dart';

/// Firebase implementation of GoalRepository
///
/// Handles all Firestore operations for Goal entities with proper
/// error handling and data conversion. Goals are stored as subcollections
/// under farms.
class FirebaseGoalRepository implements GoalRepository {
  final FirebaseFirestore _firestore;

  FirebaseGoalRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to goals collection for a specific farm
  CollectionReference<Map<String, dynamic>> _goalsCollection(String farmId) =>
      _firestore.collection(FirestorePaths.goalsCollectionPath(farmId));

  @override
  Future<Goal> create(String farmId, Goal goal) async {
    try {
      // Validate goal before creating
      final validationError = goal.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (goal.farmId != farmId) {
        throw Exception('Goal farmId does not match the provided farmId');
      }

      await _goalsCollection(farmId).doc(goal.id).set(goal.toJson());
      return goal;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create goal: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create goal: $e');
    }
  }

  @override
  Future<Goal> getById(String farmId, String goalId) async {
    try {
      final doc = await _goalsCollection(farmId).doc(goalId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Goal not found with id: $goalId in farm: $farmId');
      }

      return Goal.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get goal: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get goal: $e');
    }
  }

  @override
  Future<List<Goal>> getByFarmId(String farmId) async {
    try {
      final snapshot = await _goalsCollection(farmId)
          .orderBy(FirestoreFields.goalDate, descending: true)
          .get();

      return snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get goals by farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get goals by farm: $e');
    }
  }

  @override
  Future<List<Goal>> getActive(String farmId) async {
    try {
      final snapshot = await _goalsCollection(farmId)
          .where(FirestoreFields.status, isEqualTo: GoalStatus.active.toJson())
          .orderBy(FirestoreFields.goalDate, descending: false)
          .get();

      return snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get active goals: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get active goals: $e');
    }
  }

  @override
  Future<List<Goal>> getCompleted(String farmId) async {
    try {
      return await getByStatus(farmId, GoalStatus.completed);
    } catch (e) {
      throw Exception('Failed to get completed goals: $e');
    }
  }

  @override
  Future<List<Goal>> getOverdue(String farmId) async {
    try {
      return await getByStatus(farmId, GoalStatus.overdue);
    } catch (e) {
      throw Exception('Failed to get overdue goals: $e');
    }
  }

  @override
  Future<List<Goal>> getByStatus(String farmId, GoalStatus status) async {
    try {
      final snapshot = await _goalsCollection(farmId)
          .where(FirestoreFields.status, isEqualTo: status.toJson())
          .orderBy(FirestoreFields.goalDate, descending: true)
          .get();

      return snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get goals by status: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get goals by status: $e');
    }
  }

  @override
  Future<List<Goal>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _goalsCollection(farmId)
          .where(FirestoreFields.goalDate,
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where(FirestoreFields.goalDate,
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy(FirestoreFields.goalDate, descending: false)
          .get();

      return snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get goals by date range: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get goals by date range: $e');
    }
  }

  @override
  Future<List<Goal>> getUpcoming(String farmId, {int days = 30}) async {
    try {
      final now = DateTime.now();
      final futureDate = now.add(Duration(days: days));

      final snapshot = await _goalsCollection(farmId)
          .where(FirestoreFields.status, isEqualTo: GoalStatus.active.toJson())
          .where(FirestoreFields.goalDate,
              isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where(FirestoreFields.goalDate,
              isLessThanOrEqualTo: Timestamp.fromDate(futureDate))
          .orderBy(FirestoreFields.goalDate, descending: false)
          .get();

      return snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get upcoming goals: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get upcoming goals: $e');
    }
  }

  @override
  Future<Goal> update(String farmId, Goal goal) async {
    try {
      // Validate goal before updating
      final validationError = goal.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (goal.farmId != farmId) {
        throw Exception('Goal farmId does not match the provided farmId');
      }

      // Check if goal exists
      final exists = await this.exists(farmId, goal.id);
      if (!exists) {
        throw Exception('Goal not found with id: ${goal.id} in farm: $farmId');
      }

      // Update with new timestamp
      final updatedGoal = goal.copyWith(updatedAt: DateTime.now());
      await _goalsCollection(farmId).doc(goal.id).update(updatedGoal.toJson());
      return updatedGoal;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update goal: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update goal: $e');
    }
  }

  @override
  Future<void> delete(String farmId, String goalId) async {
    try {
      // Check if goal exists
      final exists = await this.exists(farmId, goalId);
      if (!exists) {
        throw Exception('Goal not found with id: $goalId in farm: $farmId');
      }

      await _goalsCollection(farmId).doc(goalId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete goal: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete goal: $e');
    }
  }

  @override
  Future<Goal> markAsCompleted(String farmId, String goalId) async {
    try {
      final goal = await getById(farmId, goalId);
      final updatedGoal = goal.copyWith(
        status: GoalStatus.completed,
        updatedAt: DateTime.now(),
      );
      return await update(farmId, updatedGoal);
    } catch (e) {
      throw Exception('Failed to mark goal as completed: $e');
    }
  }

  @override
  Future<Goal> markAsCancelled(String farmId, String goalId) async {
    try {
      final goal = await getById(farmId, goalId);
      final updatedGoal = goal.copyWith(
        status: GoalStatus.cancelled,
        updatedAt: DateTime.now(),
      );
      return await update(farmId, updatedGoal);
    } catch (e) {
      throw Exception('Failed to mark goal as cancelled: $e');
    }
  }

  @override
  Future<int> updateOverdueGoals(String farmId) async {
    try {
      final now = DateTime.now();

      // Get all active goals with goal date in the past
      final snapshot = await _goalsCollection(farmId)
          .where(FirestoreFields.status, isEqualTo: GoalStatus.active.toJson())
          .where(FirestoreFields.goalDate,
              isLessThan: Timestamp.fromDate(now))
          .get();

      int updatedCount = 0;
      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          FirestoreFields.status: GoalStatus.overdue.toJson(),
          FirestoreFields.updatedAt: Timestamp.fromDate(now),
        });
        updatedCount++;
      }

      if (updatedCount > 0) {
        await batch.commit();
      }

      return updatedCount;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update overdue goals: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update overdue goals: $e');
    }
  }

  @override
  Stream<Goal> watchById(String farmId, String goalId) {
    try {
      return _goalsCollection(farmId).doc(goalId).snapshots().map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          throw Exception('Goal not found with id: $goalId in farm: $farmId');
        }
        return Goal.fromJson(snapshot.data()!);
      });
    } catch (e) {
      throw Exception('Failed to watch goal: $e');
    }
  }

  @override
  Stream<List<Goal>> watchByFarmId(String farmId) {
    try {
      return _goalsCollection(farmId)
          .orderBy(FirestoreFields.goalDate, descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList());
    } catch (e) {
      throw Exception('Failed to watch goals by farm: $e');
    }
  }

  @override
  Stream<List<Goal>> watchActive(String farmId) {
    try {
      return _goalsCollection(farmId)
          .where(FirestoreFields.status, isEqualTo: GoalStatus.active.toJson())
          .orderBy(FirestoreFields.goalDate, descending: false)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList());
    } catch (e) {
      throw Exception('Failed to watch active goals: $e');
    }
  }

  @override
  Future<bool> exists(String farmId, String goalId) async {
    try {
      final doc = await _goalsCollection(farmId).doc(goalId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check goal existence: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check goal existence: $e');
    }
  }

  @override
  Future<int> count(String farmId) async {
    try {
      final snapshot = await _goalsCollection(farmId).get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count goals: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count goals: $e');
    }
  }

  @override
  Future<int> countActive(String farmId) async {
    try {
      final snapshot = await _goalsCollection(farmId)
          .where(FirestoreFields.status, isEqualTo: GoalStatus.active.toJson())
          .get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count active goals: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count active goals: $e');
    }
  }
}
