import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';
import '../models/transaction_model.dart' as model;
import 'transaction_repository.dart';

/// Firebase implementation of TransactionRepository
///
/// Handles all Firestore operations for Transaction entities with proper
/// error handling and data conversion. Transactions are stored as nested
/// subcollections under cattle lots.
class FirebaseTransactionRepository implements TransactionRepository {
  final FirebaseFirestore _firestore;

  FirebaseTransactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to transactions collection for a specific lot
  CollectionReference<Map<String, dynamic>> _transactionsCollection(
    String farmId,
    String lotId,
  ) =>
      _firestore.collection(
        FirestorePaths.transactionsCollectionPath(farmId, lotId),
      );

  @override
  Future<model.Transaction> create(
    String farmId,
    String lotId,
    model.Transaction transaction,
  ) async {
    try {
      // Validate transaction before creating
      final validationError = transaction.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure IDs match
      if (transaction.farmId != farmId) {
        throw Exception('Transaction farmId does not match the provided farmId');
      }
      if (transaction.lotId != lotId) {
        throw Exception('Transaction lotId does not match the provided lotId');
      }

      await _transactionsCollection(farmId, lotId)
          .doc(transaction.id)
          .set(transaction.toJson());
      return transaction;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create transaction: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  @override
  Future<model.Transaction> getById(
    String farmId,
    String lotId,
    String transactionId,
  ) async {
    try {
      final doc =
          await _transactionsCollection(farmId, lotId).doc(transactionId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception(
          'Transaction not found with id: $transactionId in lot: $lotId',
        );
      }

      return model.Transaction.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get transaction: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  @override
  Future<List<model.Transaction>> getByLotId(String farmId, String lotId) async {
    try {
      final snapshot = await _transactionsCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => model.Transaction.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get transactions by lot: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get transactions by lot: $e');
    }
  }

  @override
  Future<List<model.Transaction>> getByDateRange(
    String farmId,
    String lotId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _transactionsCollection(farmId, lotId)
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
          .map((doc) => model.Transaction.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get transactions by date range: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get transactions by date range: $e');
    }
  }

  @override
  Future<List<model.Transaction>> getByType(
    String farmId,
    String lotId,
    TransactionType type,
  ) async {
    try {
      final snapshot = await _transactionsCollection(farmId, lotId)
          .where(FirestoreFields.type, isEqualTo: type.toJson())
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => model.Transaction.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get transactions by type: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get transactions by type: $e');
    }
  }

  @override
  Future<List<model.Transaction>> getAllByFarmId(String farmId) async {
    try {
      // Use collectionGroup to find all transactions across all lots
      final snapshot = await _firestore
          .collectionGroup(FirestorePaths.transactionsCollection)
          .where(FirestoreFields.farmId, isEqualTo: farmId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => model.Transaction.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get all transactions by farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get all transactions by farm: $e');
    }
  }

  @override
  Future<List<model.Transaction>> getRecent(
    String farmId,
    String lotId, {
    int limit = 10,
  }) async {
    try {
      final snapshot = await _transactionsCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => model.Transaction.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get recent transactions: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get recent transactions: $e');
    }
  }

  @override
  Future<List<model.Transaction>> getByCreator(
    String farmId,
    String lotId,
    String userId,
  ) async {
    try {
      final snapshot = await _transactionsCollection(farmId, lotId)
          .where(FirestoreFields.createdBy, isEqualTo: userId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => model.Transaction.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get transactions by creator: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get transactions by creator: $e');
    }
  }

  @override
  Future<model.Transaction> update(
    String farmId,
    String lotId,
    model.Transaction transaction,
  ) async {
    try {
      // Validate transaction before updating
      final validationError = transaction.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure IDs match
      if (transaction.farmId != farmId) {
        throw Exception('Transaction farmId does not match the provided farmId');
      }
      if (transaction.lotId != lotId) {
        throw Exception('Transaction lotId does not match the provided lotId');
      }

      // Check if transaction exists
      final exists = await this.exists(farmId, lotId, transaction.id);
      if (!exists) {
        throw Exception(
          'Transaction not found with id: ${transaction.id} in lot: $lotId',
        );
      }

      await _transactionsCollection(farmId, lotId)
          .doc(transaction.id)
          .update(transaction.toJson());
      return transaction;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update transaction: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> delete(
    String farmId,
    String lotId,
    String transactionId,
  ) async {
    try {
      // Check if transaction exists
      final exists = await this.exists(farmId, lotId, transactionId);
      if (!exists) {
        throw Exception(
          'Transaction not found with id: $transactionId in lot: $lotId',
        );
      }

      await _transactionsCollection(farmId, lotId).doc(transactionId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete transaction: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  @override
  Future<double> getTotalValueByType(
    String farmId,
    String lotId,
    TransactionType type,
  ) async {
    try {
      final transactions = await getByType(farmId, lotId, type);
      return transactions.fold<double>(
        0.0,
        (sum, transaction) => sum + transaction.value,
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to get total value by type: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get total value by type: $e');
    }
  }

  @override
  Future<int> getTotalQuantityByType(
    String farmId,
    String lotId,
    TransactionType type,
  ) async {
    try {
      final transactions = await getByType(farmId, lotId, type);
      return transactions.fold<int>(
        0,
        (sum, transaction) => sum + transaction.quantity,
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to get total quantity by type: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get total quantity by type: $e');
    }
  }

  @override
  Stream<model.Transaction> watchById(
    String farmId,
    String lotId,
    String transactionId,
  ) {
    try {
      return _transactionsCollection(farmId, lotId)
          .doc(transactionId)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          throw Exception(
            'Transaction not found with id: $transactionId in lot: $lotId',
          );
        }
        return model.Transaction.fromJson(snapshot.data()!);
      });
    } catch (e) {
      throw Exception('Failed to watch transaction: $e');
    }
  }

  @override
  Stream<List<model.Transaction>> watchByLotId(String farmId, String lotId) {
    try {
      return _transactionsCollection(farmId, lotId)
          .orderBy(FirestoreFields.date, descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => model.Transaction.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to watch transactions by lot: $e');
    }
  }

  @override
  Future<bool> exists(
    String farmId,
    String lotId,
    String transactionId,
  ) async {
    try {
      final doc =
          await _transactionsCollection(farmId, lotId).doc(transactionId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check transaction existence: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check transaction existence: $e');
    }
  }

  @override
  Future<int> count(String farmId, String lotId) async {
    try {
      final snapshot = await _transactionsCollection(farmId, lotId).get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count transactions: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count transactions: $e');
    }
  }
}
