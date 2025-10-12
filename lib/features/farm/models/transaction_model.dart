import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';

/// Transaction model representing cattle movements and operations
///
/// Transactions track all cattle additions, removals, movements,
/// and mortality within lots. Each transaction affects lot quantities
/// and maintains a complete audit trail.
///
/// Business Rules:
/// - Quantity must be > 0
/// - Average weight must be > 0
/// - Value must be >= 0
/// - Date cannot be in the future
/// - Move transactions must have relatedTransactionId
class Transaction extends Equatable {
  /// Unique identifier for the transaction
  final String id;

  /// Lot ID this transaction affects
  final String lotId;

  /// Farm ID this transaction belongs to
  final String farmId;

  /// Type of transaction (buy, sell, move, die)
  final TransactionType type;

  /// Quantity of cattle in this transaction
  final int quantity;

  /// Average weight per head in kilograms
  final double averageWeight;

  /// Transaction value in currency (0 for non-financial transactions)
  final double value;

  /// Description or notes about this transaction
  final String description;

  /// Date when transaction occurred
  final DateTime date;

  /// Timestamp when transaction was recorded
  final DateTime createdAt;

  /// User ID who created this transaction
  final String createdBy;

  /// For Move type: ID of related transaction in destination lot
  final String? relatedTransactionId;

  const Transaction({
    required this.id,
    required this.lotId,
    required this.farmId,
    required this.type,
    required this.quantity,
    required this.averageWeight,
    required this.value,
    required this.description,
    required this.date,
    required this.createdAt,
    required this.createdBy,
    this.relatedTransactionId,
  });

  /// Total weight of all cattle in this transaction
  double get totalWeight => quantity * averageWeight;

  /// Check if this is a move transaction
  bool get isMove => type == TransactionType.move;

  /// Check if this transaction requires a related transaction
  bool get requiresRelatedTransaction => isMove;

  /// Check if this transaction has financial value
  bool get hasValue => value > 0;

  /// Create Transaction instance from Firestore document
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json[FirestoreFields.id] as String,
      lotId: json[FirestoreFields.lotId] as String,
      farmId: json[FirestoreFields.farmId] as String,
      type: TransactionTypeExtension.fromJson(
        json[FirestoreFields.type] as String,
      ),
      quantity: json[FirestoreFields.quantity] as int,
      averageWeight: (json[FirestoreFields.averageWeight] as num).toDouble(),
      value: (json[FirestoreFields.value] as num).toDouble(),
      description: json[FirestoreFields.description] as String? ?? '',
      date: (json[FirestoreFields.date] as Timestamp).toDate(),
      createdAt: (json[FirestoreFields.createdAt] as Timestamp).toDate(),
      createdBy: json[FirestoreFields.createdBy] as String,
      relatedTransactionId:
          json[FirestoreFields.relatedTransactionId] as String?,
    );
  }

  /// Convert Transaction instance to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirestoreFields.id: id,
      FirestoreFields.lotId: lotId,
      FirestoreFields.farmId: farmId,
      FirestoreFields.type: type.toJson(),
      FirestoreFields.quantity: quantity,
      FirestoreFields.averageWeight: averageWeight,
      FirestoreFields.value: value,
      FirestoreFields.description: description,
      FirestoreFields.date: Timestamp.fromDate(date),
      FirestoreFields.createdAt: Timestamp.fromDate(createdAt),
      FirestoreFields.createdBy: createdBy,
      if (relatedTransactionId != null)
        FirestoreFields.relatedTransactionId: relatedTransactionId,
    };
  }

  /// Create a copy of this Transaction with modified fields
  Transaction copyWith({
    String? id,
    String? lotId,
    String? farmId,
    TransactionType? type,
    int? quantity,
    double? averageWeight,
    double? value,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    String? createdBy,
    String? relatedTransactionId,
  }) {
    return Transaction(
      id: id ?? this.id,
      lotId: lotId ?? this.lotId,
      farmId: farmId ?? this.farmId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      averageWeight: averageWeight ?? this.averageWeight,
      value: value ?? this.value,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
    );
  }

  /// Validate transaction data
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }
    if (averageWeight <= 0) {
      return 'Average weight must be greater than 0';
    }
    if (averageWeight > 2000) {
      return 'Average weight seems unreasonably high';
    }
    if (value < 0) {
      return 'Value cannot be negative';
    }
    if (date.isAfter(DateTime.now())) {
      return 'Transaction date cannot be in the future';
    }
    if (lotId.trim().isEmpty) {
      return 'Lot ID is required';
    }
    if (farmId.trim().isEmpty) {
      return 'Farm ID is required';
    }
    if (createdBy.trim().isEmpty) {
      return 'Creator ID is required';
    }
    if (isMove && (relatedTransactionId == null || relatedTransactionId!.trim().isEmpty)) {
      return 'Move transactions must have a related transaction ID';
    }
    return null;
  }

  /// Check if transaction is valid
  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
        id,
        lotId,
        farmId,
        type,
        quantity,
        averageWeight,
        value,
        description,
        date,
        createdAt,
        createdBy,
        relatedTransactionId,
      ];

  @override
  String toString() {
    return 'Transaction(id: $id, type: ${type.label}, quantity: $quantity, value: $value)';
  }
}
