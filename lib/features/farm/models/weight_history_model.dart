import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/firestore_paths.dart';

/// WeightHistory model representing weight measurements for a cattle lot
///
/// Weight history tracks the average weight of cattle in a lot over time,
/// allowing analysis of growth rates and performance. Each entry records
/// the average weight per head at a specific date.
///
/// Business Rules:
/// - Average weight must be > 0
/// - Date cannot be in the future
/// - Multiple entries per lot allowed for tracking growth
class WeightHistory extends Equatable {
  /// Unique identifier for the weight record
  final String id;

  /// Lot ID this weight record belongs to
  final String lotId;

  /// Date when weight was measured
  final DateTime date;

  /// Average weight per head in kilograms
  final double averageWeight;

  /// Timestamp when record was created
  final DateTime createdAt;

  /// User ID who created this record
  final String createdBy;

  const WeightHistory({
    required this.id,
    required this.lotId,
    required this.date,
    required this.averageWeight,
    required this.createdAt,
    required this.createdBy,
  });

  /// Check if weight measurement is recent (within last 30 days)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays <= 30;
  }

  /// Calculate weight gain compared to another weight history entry
  /// Returns positive value for gain, negative for loss
  double calculateWeightGain(WeightHistory previous) {
    return averageWeight - previous.averageWeight;
  }

  /// Calculate daily weight gain rate compared to another weight history entry
  /// Returns weight gain per day in kilograms
  double calculateDailyGainRate(WeightHistory previous) {
    final weightGain = calculateWeightGain(previous);
    final daysDifference = date.difference(previous.date).inDays;
    if (daysDifference <= 0) return 0;
    return weightGain / daysDifference;
  }

  /// Create WeightHistory instance from Firestore document
  factory WeightHistory.fromJson(Map<String, dynamic> json) {
    return WeightHistory(
      id: json[FirestoreFields.id] as String,
      lotId: json[FirestoreFields.lotId] as String,
      date: (json[FirestoreFields.date] as Timestamp).toDate(),
      averageWeight: (json[FirestoreFields.averageWeight] as num).toDouble(),
      createdAt: (json[FirestoreFields.createdAt] as Timestamp).toDate(),
      createdBy: json[FirestoreFields.createdBy] as String,
    );
  }

  /// Convert WeightHistory instance to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirestoreFields.id: id,
      FirestoreFields.lotId: lotId,
      FirestoreFields.date: Timestamp.fromDate(date),
      FirestoreFields.averageWeight: averageWeight,
      FirestoreFields.createdAt: Timestamp.fromDate(createdAt),
      FirestoreFields.createdBy: createdBy,
    };
  }

  /// Create a copy of this WeightHistory with modified fields
  WeightHistory copyWith({
    String? id,
    String? lotId,
    DateTime? date,
    double? averageWeight,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return WeightHistory(
      id: id ?? this.id,
      lotId: lotId ?? this.lotId,
      date: date ?? this.date,
      averageWeight: averageWeight ?? this.averageWeight,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  /// Validate weight history data
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (averageWeight <= 0) {
      return 'Average weight must be greater than 0';
    }
    if (averageWeight > 2000) {
      return 'Average weight seems unreasonably high';
    }
    if (date.isAfter(DateTime.now())) {
      return 'Weight measurement date cannot be in the future';
    }
    if (lotId.trim().isEmpty) {
      return 'Lot ID is required';
    }
    if (createdBy.trim().isEmpty) {
      return 'Creator ID is required';
    }
    return null;
  }

  /// Check if weight history is valid
  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
        id,
        lotId,
        date,
        averageWeight,
        createdAt,
        createdBy,
      ];

  @override
  String toString() {
    return 'WeightHistory(id: $id, date: $date, weight: ${averageWeight}kg)';
  }
}
