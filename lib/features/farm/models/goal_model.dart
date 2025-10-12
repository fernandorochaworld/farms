import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';

/// Goal model representing farm objectives and targets
///
/// Goals define targets for farm operations, such as achieving
/// a specific average weight or expected number of births by
/// a certain date. Goals can be tracked and marked as completed
/// or overdue.
///
/// Business Rules:
/// - Goal date must be after definition date
/// - Must have at least one target (weight or birth quantity)
/// - Status is automatically calculated based on dates and progress
class Goal extends Equatable {
  /// Unique identifier for the goal
  final String id;

  /// Farm this goal belongs to
  final String farmId;

  /// Date when goal was defined
  final DateTime definitionDate;

  /// Target date to achieve the goal
  final DateTime goalDate;

  /// Target average weight in kilograms (optional)
  final double? averageWeight;

  /// Expected number of births (optional)
  final int? birthQuantity;

  /// Current status of the goal
  final GoalStatus status;

  /// Timestamp when goal was created
  final DateTime createdAt;

  /// Timestamp of last update
  final DateTime? updatedAt;

  const Goal({
    required this.id,
    required this.farmId,
    required this.definitionDate,
    required this.goalDate,
    this.averageWeight,
    this.birthQuantity,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  /// Check if goal has a weight target
  bool get hasWeightTarget => averageWeight != null && averageWeight! > 0;

  /// Check if goal has a birth quantity target
  bool get hasBirthTarget => birthQuantity != null && birthQuantity! > 0;

  /// Check if goal is currently active
  bool get isActive => status == GoalStatus.active;

  /// Check if goal is completed
  bool get isCompleted => status == GoalStatus.completed;

  /// Check if goal is overdue
  bool get isOverdue => status == GoalStatus.overdue;

  /// Check if goal is cancelled
  bool get isCancelled => status == GoalStatus.cancelled;

  /// Calculate days remaining until goal date
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(goalDate)) return 0;
    return goalDate.difference(now).inDays;
  }

  /// Calculate days since goal was defined
  int get daysSinceDefinition {
    final now = DateTime.now();
    return now.difference(definitionDate).inDays;
  }

  /// Check if goal date has passed
  bool get isPastDueDate {
    return DateTime.now().isAfter(goalDate);
  }

  /// Create Goal instance from Firestore document
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json[FirestoreFields.id] as String,
      farmId: json[FirestoreFields.farmId] as String,
      definitionDate:
          (json[FirestoreFields.definitionDate] as Timestamp).toDate(),
      goalDate: (json[FirestoreFields.goalDate] as Timestamp).toDate(),
      averageWeight: json[FirestoreFields.averageWeight] != null
          ? (json[FirestoreFields.averageWeight] as num).toDouble()
          : null,
      birthQuantity: json[FirestoreFields.birthQuantity] as int?,
      status: GoalStatusExtension.fromJson(
        json[FirestoreFields.status] as String,
      ),
      createdAt: (json[FirestoreFields.createdAt] as Timestamp).toDate(),
      updatedAt: json[FirestoreFields.updatedAt] != null
          ? (json[FirestoreFields.updatedAt] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert Goal instance to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirestoreFields.id: id,
      FirestoreFields.farmId: farmId,
      FirestoreFields.definitionDate: Timestamp.fromDate(definitionDate),
      FirestoreFields.goalDate: Timestamp.fromDate(goalDate),
      if (averageWeight != null)
        FirestoreFields.averageWeight: averageWeight,
      if (birthQuantity != null)
        FirestoreFields.birthQuantity: birthQuantity,
      FirestoreFields.status: status.toJson(),
      FirestoreFields.createdAt: Timestamp.fromDate(createdAt),
      if (updatedAt != null)
        FirestoreFields.updatedAt: Timestamp.fromDate(updatedAt!),
    };
  }

  /// Create a copy of this Goal with modified fields
  Goal copyWith({
    String? id,
    String? farmId,
    DateTime? definitionDate,
    DateTime? goalDate,
    double? averageWeight,
    int? birthQuantity,
    GoalStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      definitionDate: definitionDate ?? this.definitionDate,
      goalDate: goalDate ?? this.goalDate,
      averageWeight: averageWeight ?? this.averageWeight,
      birthQuantity: birthQuantity ?? this.birthQuantity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Validate goal data
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (goalDate.isBefore(definitionDate)) {
      return 'Goal date must be after definition date';
    }
    if (!hasWeightTarget && !hasBirthTarget) {
      return 'Goal must have at least one target (weight or birth quantity)';
    }
    if (averageWeight != null && averageWeight! <= 0) {
      return 'Average weight target must be greater than 0';
    }
    if (averageWeight != null && averageWeight! > 2000) {
      return 'Average weight target seems unreasonably high';
    }
    if (birthQuantity != null && birthQuantity! <= 0) {
      return 'Birth quantity target must be greater than 0';
    }
    if (farmId.trim().isEmpty) {
      return 'Farm ID is required';
    }
    return null;
  }

  /// Check if goal is valid
  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
        id,
        farmId,
        definitionDate,
        goalDate,
        averageWeight,
        birthQuantity,
        status,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    final targets = <String>[];
    if (hasWeightTarget) targets.add('weight: ${averageWeight}kg');
    if (hasBirthTarget) targets.add('births: $birthQuantity');
    return 'Goal(id: $id, ${targets.join(', ')}, status: ${status.label})';
  }
}
