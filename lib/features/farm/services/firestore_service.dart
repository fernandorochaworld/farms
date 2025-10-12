import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore service helper with connection status and batch operations
///
/// This service provides utility methods for working with Firestore including:
/// - Connection status checking
/// - Batch write operations
/// - Transaction helpers
/// - Query builders
/// - Collection group queries
///
/// Use this service to simplify common Firestore operations and ensure
/// consistent patterns across the application.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Gets the Firestore instance
  FirebaseFirestore get instance => _firestore;

  /// Checks if Firestore is connected and accessible
  ///
  /// Attempts a simple read operation to verify connectivity.
  /// Returns true if connected, false otherwise.
  ///
  /// Note: This creates a temporary document to test connectivity.
  /// In production, you might want to use a specific health check collection.
  Future<bool> checkConnection() async {
    try {
      // Try to access Firestore settings as a connectivity check
      await _firestore
          .collection('_health_check')
          .limit(1)
          .get(const GetOptions(source: Source.server));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Performs a batch write operation
  ///
  /// Batch writes are atomic - either all operations succeed or all fail.
  /// Maximum 500 operations per batch.
  ///
  /// Example:
  /// ```dart
  /// await firestoreService.batchWrite((batch) {
  ///   batch.set(docRef1, data1);
  ///   batch.update(docRef2, data2);
  ///   batch.delete(docRef3);
  /// });
  /// ```
  ///
  /// Throws an exception if the batch operation fails.
  Future<void> batchWrite(
    void Function(WriteBatch batch) operations,
  ) async {
    final batch = _firestore.batch();
    operations(batch);
    await batch.commit();
  }

  /// Creates a batch for manual commit
  ///
  /// Use this when you need more control over batch creation and commit timing.
  ///
  /// Example:
  /// ```dart
  /// final batch = firestoreService.createBatch();
  /// batch.set(docRef1, data1);
  /// batch.update(docRef2, data2);
  /// await batch.commit();
  /// ```
  WriteBatch createBatch() {
    return _firestore.batch();
  }

  /// Performs a transaction operation
  ///
  /// Transactions are used for atomic read-modify-write operations.
  /// All reads must happen before writes within a transaction.
  ///
  /// Example:
  /// ```dart
  /// await firestoreService.runTransaction((transaction) async {
  ///   final snapshot = await transaction.get(docRef);
  ///   final newValue = snapshot.data()!['count'] + 1;
  ///   transaction.update(docRef, {'count': newValue});
  /// });
  /// ```
  ///
  /// Throws an exception if the transaction fails or is aborted.
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return await _firestore.runTransaction(
      transactionHandler,
      timeout: timeout,
    );
  }

  /// Batch deletes documents matching a query
  ///
  /// Deletes up to [batchSize] documents at a time. This is useful for
  /// deleting large collections without hitting batch limits.
  ///
  /// Example:
  /// ```dart
  /// final query = firestore.collection('old_data').where('expired', isEqualTo: true);
  /// await firestoreService.batchDelete(query);
  /// ```
  ///
  /// Returns the total number of documents deleted.
  Future<int> batchDelete(
    Query query, {
    int batchSize = 500,
  }) async {
    int totalDeleted = 0;
    bool hasMore = true;

    while (hasMore) {
      final snapshot = await query.limit(batchSize).get();

      if (snapshot.docs.isEmpty) {
        hasMore = false;
        break;
      }

      await batchWrite((batch) {
        for (final doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
      });

      totalDeleted += snapshot.docs.length;

      // If we got fewer docs than batch size, we're done
      if (snapshot.docs.length < batchSize) {
        hasMore = false;
      }
    }

    return totalDeleted;
  }

  /// Batch updates documents matching a query
  ///
  /// Updates up to [batchSize] documents at a time with the provided data.
  ///
  /// Example:
  /// ```dart
  /// final query = firestore.collection('users').where('status', isEqualTo: 'pending');
  /// await firestoreService.batchUpdate(query, {'status': 'active'});
  /// ```
  ///
  /// Returns the total number of documents updated.
  Future<int> batchUpdate(
    Query query,
    Map<String, dynamic> data, {
    int batchSize = 500,
  }) async {
    int totalUpdated = 0;
    bool hasMore = true;

    while (hasMore) {
      final snapshot = await query.limit(batchSize).get();

      if (snapshot.docs.isEmpty) {
        hasMore = false;
        break;
      }

      await batchWrite((batch) {
        for (final doc in snapshot.docs) {
          batch.update(doc.reference, data);
        }
      });

      totalUpdated += snapshot.docs.length;

      if (snapshot.docs.length < batchSize) {
        hasMore = false;
      }
    }

    return totalUpdated;
  }

  /// Creates a document reference with auto-generated ID
  ///
  /// Useful when you need to know the document ID before creating it.
  ///
  /// Example:
  /// ```dart
  /// final docRef = firestoreService.createDocumentReference('farms');
  /// final id = docRef.id;
  /// await docRef.set({'id': id, 'name': 'My Farm'});
  /// ```
  DocumentReference createDocumentReference(String collectionPath) {
    return _firestore.collection(collectionPath).doc();
  }

  /// Gets a collection reference
  ///
  /// Helper method for cleaner code.
  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }

  /// Gets a document reference
  ///
  /// Helper method for cleaner code.
  DocumentReference doc(String path) {
    return _firestore.doc(path);
  }

  /// Creates a collection group query
  ///
  /// Collection group queries search across all collections with the same ID,
  /// regardless of their location in the document hierarchy.
  ///
  /// Example:
  /// ```dart
  /// // Find all transactions across all lots
  /// final query = firestoreService.collectionGroup('transactions')
  ///   .where('date', isGreaterThan: Timestamp.fromDate(startDate));
  /// ```
  ///
  /// Note: Requires appropriate Firestore indexes.
  Query collectionGroup(String collectionId) {
    return _firestore.collectionGroup(collectionId);
  }

  /// Enables Firestore network (online mode)
  ///
  /// Resumes network usage for Firestore operations.
  Future<void> enableNetwork() async {
    await _firestore.enableNetwork();
  }

  /// Disables Firestore network (offline mode)
  ///
  /// Firestore will use cached data only.
  Future<void> disableNetwork() async {
    await _firestore.disableNetwork();
  }

  /// Clears Firestore persistence cache
  ///
  /// This will remove all cached documents. Call this only when necessary,
  /// such as during sign out.
  ///
  /// Note: This will cause Firestore to reload all data from the server.
  Future<void> clearPersistence() async {
    try {
      await _firestore.clearPersistence();
    } catch (e) {
      // Clearing persistence fails if there are active listeners
      // This is expected in some cases and can be ignored
      throw Exception('Failed to clear Firestore persistence: $e');
    }
  }

  /// Waits for pending writes to complete
  ///
  /// Useful before performing critical operations or during app shutdown.
  Future<void> waitForPendingWrites() async {
    await _firestore.waitForPendingWrites();
  }

  /// Configures Firestore settings
  ///
  /// Should be called before any Firestore operation.
  ///
  /// Example:
  /// ```dart
  /// firestoreService.configureSettings(
  ///   persistenceEnabled: true,
  ///   cacheSizeBytes: 100 * 1024 * 1024, // 100 MB
  /// );
  /// ```
  void configureSettings({
    bool? persistenceEnabled,
    int? cacheSizeBytes,
    String? host,
    bool? sslEnabled,
  }) {
    final settings = Settings(
      persistenceEnabled: persistenceEnabled ?? true,
      cacheSizeBytes: cacheSizeBytes ?? Settings.CACHE_SIZE_UNLIMITED,
      host: host,
      sslEnabled: sslEnabled ?? true,
    );
    _firestore.settings = settings;
  }

  /// Gets the current timestamp from Firestore server
  ///
  /// This ensures all timestamps are synchronized with the server,
  /// avoiding issues with client clock differences.
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  /// Helper to check if a document exists
  ///
  /// Returns true if the document exists, false otherwise.
  Future<bool> documentExists(String path) async {
    final doc = await _firestore.doc(path).get();
    return doc.exists;
  }

  /// Helper to check if a document exists by reference
  ///
  /// Returns true if the document exists, false otherwise.
  Future<bool> documentExistsByRef(DocumentReference ref) async {
    final doc = await ref.get();
    return doc.exists;
  }

  /// Gets document count for a query
  ///
  /// Returns the number of documents matching the query.
  ///
  /// Note: This retrieves all documents to count them. For large collections,
  /// consider maintaining a separate counter document.
  Future<int> getCount(Query query) async {
    final snapshot = await query.count().get();
    return snapshot.count ?? 0;
  }

  /// Creates a query builder for pagination
  ///
  /// Returns a query that can be used for pagination with startAfter/endBefore.
  Query paginateQuery(
    Query query, {
    DocumentSnapshot? startAfter,
    DocumentSnapshot? startAt,
    DocumentSnapshot? endBefore,
    DocumentSnapshot? endAt,
    int limit = 20,
  }) {
    Query paginatedQuery = query.limit(limit);

    if (startAfter != null) {
      paginatedQuery = paginatedQuery.startAfterDocument(startAfter);
    } else if (startAt != null) {
      paginatedQuery = paginatedQuery.startAtDocument(startAt);
    }

    if (endBefore != null) {
      paginatedQuery = paginatedQuery.endBeforeDocument(endBefore);
    } else if (endAt != null) {
      paginatedQuery = paginatedQuery.endAtDocument(endAt);
    }

    return paginatedQuery;
  }
}
