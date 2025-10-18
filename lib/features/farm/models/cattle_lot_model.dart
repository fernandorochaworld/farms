import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';
import '../services/age_calculator_service.dart';




/// CattleLot model representing a group of cattle
///
/// A lot is a collection of cattle of the same type and gender,
/// born within a specific date range. Lots track additions and
/// removals through transactions.
///
/// Business Rules:
/// - Name must be 3-100 characters
/// - Birth end date must be >= birth start date
/// - Quantities must be >= 0
/// - Current quantity = qtdAdded - qtdRemoved
/// - Lot is active if endDate is null and currentQuantity > 0
class CattleLot extends Equatable {
  /// Unique identifier for the lot
  final String id;

  /// Farm this lot belongs to
  final String farmId;

  /// Lot name/identifier
  final String name;

  /// Type of cattle based on age classification
  final CattleType cattleType;

  /// Gender composition of the lot
  final CattleGender gender;

  /// Start of birth date range for cattle in this lot
  final DateTime birthStart;

  /// End of birth date range for cattle in this lot
  final DateTime birthEnd;

  /// Total quantity of cattle added to this lot
  final int qtdAdded;

  /// Total quantity of cattle removed from this lot
  final int qtdRemoved;

  /// Date when lot started (first transaction date)
  final DateTime startDate;

  /// Date when lot ended (null if still active)
  final DateTime? endDate;

  /// Timestamp when lot was created
  final DateTime createdAt;

  /// Timestamp of last update
  final DateTime? updatedAt;

  const CattleLot({
    required this.id,
    required this.farmId,
    required this.name,
    required this.cattleType,
    required this.gender,
    required this.birthStart,
    required this.birthEnd,
    required this.qtdAdded,
    required this.qtdRemoved,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    this.updatedAt,
  });

  /// Current quantity of cattle in this lot
  int get currentQuantity => qtdAdded - qtdRemoved;

  /// Whether this lot is currently active
  bool get isActive => endDate == null && currentQuantity > 0;

  /// Check if lot is empty (no cattle remaining)
  bool get isEmpty => currentQuantity <= 0;

  /// Check if lot is closed (has end date)
  bool get isClosed => endDate != null;

  int get daysActive {
    final end = endDate ?? DateTime.now();
    return end.difference(startDate).inDays;
  }

  AgeRange get ageRange {
    return AgeCalculator.calculateAgeRange(birthStart, birthEnd);
  }

  /// Calculate average age of cattle in months (from birth start to now)
  int get averageAgeInMonths {
    final now = DateTime.now();
    final difference = now.difference(birthStart);
    return (difference.inDays / 30).round();
  }

  /// Create CattleLot instance from Firestore document
  factory CattleLot.fromJson(Map<String, dynamic> json) {
    return CattleLot(
      id: json[FirestoreFields.id] as String,
      farmId: json[FirestoreFields.farmId] as String,
      name: json[FirestoreFields.name] as String,
      cattleType: CattleTypeExtension.fromJson(
        json[FirestoreFields.cattleType] as String,
      ),
      gender: CattleGenderExtension.fromJson(
        json[FirestoreFields.gender] as String,
      ),
      birthStart: (json[FirestoreFields.birthStart] as Timestamp).toDate(),
      birthEnd: (json[FirestoreFields.birthEnd] as Timestamp).toDate(),
      qtdAdded: json[FirestoreFields.qtdAdded] as int,
      qtdRemoved: json[FirestoreFields.qtdRemoved] as int,
      startDate: (json[FirestoreFields.startDate] as Timestamp).toDate(),
      endDate: json[FirestoreFields.endDate] != null
          ? (json[FirestoreFields.endDate] as Timestamp).toDate()
          : null,
      createdAt: (json[FirestoreFields.createdAt] as Timestamp).toDate(),
      updatedAt: json[FirestoreFields.updatedAt] != null
          ? (json[FirestoreFields.updatedAt] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert CattleLot instance to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirestoreFields.id: id,
      FirestoreFields.farmId: farmId,
      FirestoreFields.name: name,
      FirestoreFields.cattleType: cattleType.toJson(),
      FirestoreFields.gender: gender.toJson(),
      FirestoreFields.birthStart: Timestamp.fromDate(birthStart),
      FirestoreFields.birthEnd: Timestamp.fromDate(birthEnd),
      FirestoreFields.qtdAdded: qtdAdded,
      FirestoreFields.qtdRemoved: qtdRemoved,
      FirestoreFields.startDate: Timestamp.fromDate(startDate),
      if (endDate != null)
        FirestoreFields.endDate: Timestamp.fromDate(endDate!),
      FirestoreFields.createdAt: Timestamp.fromDate(createdAt),
      if (updatedAt != null)
        FirestoreFields.updatedAt: Timestamp.fromDate(updatedAt!),
    };
  }

  /// Create a copy of this CattleLot with modified fields
  CattleLot copyWith({
    String? id,
    String? farmId,
    String? name,
    CattleType? cattleType,
    CattleGender? gender,
    DateTime? birthStart,
    DateTime? birthEnd,
    int? qtdAdded,
    int? qtdRemoved,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CattleLot(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      cattleType: cattleType ?? this.cattleType,
      gender: gender ?? this.gender,
      birthStart: birthStart ?? this.birthStart,
      birthEnd: birthEnd ?? this.birthEnd,
      qtdAdded: qtdAdded ?? this.qtdAdded,
      qtdRemoved: qtdRemoved ?? this.qtdRemoved,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Validate cattle lot data
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (name.trim().isEmpty) {
      return 'Lot name is required';
    }
    if (name.trim().length < 3) {
      return 'Lot name must be at least 3 characters';
    }
    if (name.length > 100) {
      return 'Lot name must not exceed 100 characters';
    }
    if (birthEnd.isBefore(birthStart)) {
      return 'Birth end date must be after or equal to birth start date';
    }
    if (qtdAdded < 0) {
      return 'Added quantity cannot be negative';
    }
    if (qtdRemoved < 0) {
      return 'Removed quantity cannot be negative';
    }
    if (qtdRemoved > qtdAdded) {
      return 'Removed quantity cannot exceed added quantity';
    }
    if (startDate.isAfter(DateTime.now())) {
      return 'Start date cannot be in the future';
    }
    if (endDate != null && endDate!.isBefore(startDate)) {
      return 'End date must be after start date';
    }
    return null;
  }

  /// Check if lot is valid
  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
        id,
        farmId,
        name,
        cattleType,
        gender,
        birthStart,
        birthEnd,
        qtdAdded,
        qtdRemoved,
        startDate,
        endDate,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'CattleLot(id: $id, name: $name, type: ${cattleType.label}, quantity: $currentQuantity)';
  }
}
