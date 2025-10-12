/// Firestore collection and document path constants for Farm Management System
///
/// This file centralizes all Firestore path definitions to ensure consistency
/// and make path management easier across the application.

class FirestorePaths {
  FirestorePaths._(); // Private constructor to prevent instantiation

  // Root collections
  static const String farmsCollection = 'farms';

  // Farm subcollections
  static const String peopleCollection = 'people';
  static const String cattleLotsCollection = 'cattle_lots';
  static const String goalsCollection = 'goals';
  static const String servicesCollection = 'services';
  static const String auditLogsCollection = 'audit_logs';

  // Cattle lot subcollections
  static const String transactionsCollection = 'transactions';
  static const String weightHistoryCollection = 'weight_history';

  // Full paths for farms
  static String farmDocument(String farmId) => '$farmsCollection/$farmId';

  // Full paths for people
  static String peopleCollectionPath(String farmId) =>
      '${farmDocument(farmId)}/$peopleCollection';

  static String personDocument(String farmId, String personId) =>
      '${peopleCollectionPath(farmId)}/$personId';

  // Full paths for cattle lots
  static String cattleLotsCollectionPath(String farmId) =>
      '${farmDocument(farmId)}/$cattleLotsCollection';

  static String cattleLotDocument(String farmId, String lotId) =>
      '${cattleLotsCollectionPath(farmId)}/$lotId';

  // Full paths for transactions
  static String transactionsCollectionPath(String farmId, String lotId) =>
      '${cattleLotDocument(farmId, lotId)}/$transactionsCollection';

  static String transactionDocument(
    String farmId,
    String lotId,
    String transactionId,
  ) =>
      '${transactionsCollectionPath(farmId, lotId)}/$transactionId';

  // Full paths for weight history
  static String weightHistoryCollectionPath(String farmId, String lotId) =>
      '${cattleLotDocument(farmId, lotId)}/$weightHistoryCollection';

  static String weightHistoryDocument(
    String farmId,
    String lotId,
    String weightId,
  ) =>
      '${weightHistoryCollectionPath(farmId, lotId)}/$weightId';

  // Full paths for goals
  static String goalsCollectionPath(String farmId) =>
      '${farmDocument(farmId)}/$goalsCollection';

  static String goalDocument(String farmId, String goalId) =>
      '${goalsCollectionPath(farmId)}/$goalId';

  // Full paths for services
  static String servicesCollectionPath(String farmId) =>
      '${farmDocument(farmId)}/$servicesCollection';

  static String serviceDocument(String farmId, String serviceId) =>
      '${servicesCollectionPath(farmId)}/$serviceId';

  // Full paths for audit logs
  static String auditLogsCollectionPath(String farmId) =>
      '${farmDocument(farmId)}/$auditLogsCollection';

  static String auditLogDocument(String farmId, String logId) =>
      '${auditLogsCollectionPath(farmId)}/$logId';
}

/// Firestore field name constants
class FirestoreFields {
  FirestoreFields._(); // Private constructor to prevent instantiation

  // Common fields
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String createdBy = 'created_by';

  // Farm fields
  static const String name = 'name';
  static const String description = 'description';
  static const String capacity = 'capacity';

  // Person fields
  static const String userId = 'user_id';
  static const String farmId = 'farm_id';
  static const String personType = 'person_type';
  static const String isAdmin = 'is_admin';

  // Cattle lot fields
  static const String cattleType = 'cattle_type';
  static const String gender = 'gender';
  static const String birthStart = 'birth_start';
  static const String birthEnd = 'birth_end';
  static const String qtdAdded = 'qtd_added';
  static const String qtdRemoved = 'qtd_removed';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';

  // Transaction fields
  static const String lotId = 'lot_id';
  static const String type = 'type';
  static const String quantity = 'quantity';
  static const String averageWeight = 'average_weight';
  static const String value = 'value';
  static const String date = 'date';
  static const String relatedTransactionId = 'related_transaction_id';

  // Weight history fields
  // (uses date and average_weight from above)

  // Goal fields
  static const String definitionDate = 'definition_date';
  static const String goalDate = 'goal_date';
  static const String birthQuantity = 'birth_quantity';
  static const String status = 'status';

  // Service fields
  static const String serviceType = 'service_type';
  // (uses date, value, description, created_at, created_by from above)

  // Audit log fields
  static const String action = 'action';
  static const String resourceType = 'resource_type';
  static const String resourceId = 'resource_id';
  static const String timestamp = 'timestamp';
  static const String details = 'details';
  static const String ipAddress = 'ip_address';
}
