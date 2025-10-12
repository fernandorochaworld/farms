import '../constants/enums.dart';
import '../models/transaction_model.dart';

/// Repository interface for Transaction operations
///
/// Defines all CRUD operations and queries for Transaction entities.
/// Transactions are stored as a subcollection under cattle lots,
/// which are themselves subcollections under farms.
///
/// Example usage:
/// ```dart
/// final repository = getIt<TransactionRepository>();
/// final transaction = await repository.create(farmId, lotId, newTransaction);
/// final transactions = await repository.getByLotId(farmId, lotId);
/// ```
abstract class TransactionRepository {
  /// Create a new transaction in a cattle lot
  ///
  /// Throws [Exception] if transaction already exists or validation fails
  Future<Transaction> create(String farmId, String lotId, Transaction transaction);

  /// Get transaction by ID
  ///
  /// Throws [Exception] if transaction not found
  Future<Transaction> getById(String farmId, String lotId, String transactionId);

  /// Get all transactions for a cattle lot
  ///
  /// Returns list sorted by date (newest first)
  Future<List<Transaction>> getByLotId(String farmId, String lotId);

  /// Get transactions by date range
  ///
  /// Returns transactions within the specified date range
  Future<List<Transaction>> getByDateRange(
    String farmId,
    String lotId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get transactions by type
  ///
  /// Returns transactions of a specific type (buy, sell, move, die)
  Future<List<Transaction>> getByType(
    String farmId,
    String lotId,
    TransactionType type,
  );

  /// Get all transactions across all lots in a farm
  ///
  /// Uses collectionGroup query to find all transactions
  Future<List<Transaction>> getAllByFarmId(String farmId);

  /// Get recent transactions (last N transactions)
  ///
  /// Returns the most recent transactions for a lot
  Future<List<Transaction>> getRecent(String farmId, String lotId, {int limit = 10});

  /// Get transactions created by a specific user
  ///
  /// Returns transactions created by the specified user
  Future<List<Transaction>> getByCreator(
    String farmId,
    String lotId,
    String userId,
  );

  /// Update an existing transaction
  ///
  /// Throws [Exception] if transaction not found or validation fails
  Future<Transaction> update(String farmId, String lotId, Transaction transaction);

  /// Delete a transaction
  ///
  /// Throws [Exception] if transaction not found
  Future<void> delete(String farmId, String lotId, String transactionId);

  /// Get total value of transactions by type
  ///
  /// Returns sum of transaction values for a specific type
  Future<double> getTotalValueByType(
    String farmId,
    String lotId,
    TransactionType type,
  );

  /// Get total quantity of transactions by type
  ///
  /// Returns sum of transaction quantities for a specific type
  Future<int> getTotalQuantityByType(
    String farmId,
    String lotId,
    TransactionType type,
  );

  /// Watch transaction changes in real-time
  ///
  /// Returns a stream that emits the transaction whenever it changes
  Stream<Transaction> watchById(String farmId, String lotId, String transactionId);

  /// Watch all transactions for a lot in real-time
  ///
  /// Returns a stream that emits the list of transactions whenever any changes
  Stream<List<Transaction>> watchByLotId(String farmId, String lotId);

  /// Check if a transaction exists
  Future<bool> exists(String farmId, String lotId, String transactionId);

  /// Get total count of transactions in a lot
  Future<int> count(String farmId, String lotId);
}
