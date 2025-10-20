import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';

/// FarmServiceHistory model representing farm maintenance and care services
///
/// Service history tracks all farm-related services such as vaccinations,
/// veterinary care, feeding, medical treatments, and other maintenance
/// activities. Each service records the type, date, cost, and description.
///
/// Business Rules:
/// - Service type is required
/// - Value must be >= 0
/// - Date cannot be in the future
/// - Description should provide context for the service
class FarmServiceHistory extends Equatable {
  /// Unique identifier for the service record
  final String id;

  /// Farm this service belongs to
  final String farmId;

  /// Type of service performed
  final ServiceType serviceType;

  /// Date when service was performed
  final DateTime date;

  /// Cost of the service in currency
  final double value;

  /// Description or notes about the service
  final String description;

  /// Timestamp when record was created
  final DateTime createdAt;

  /// User ID who created this record
  final String createdBy;
  final ServiceStatus status;

  const FarmServiceHistory({
    required this.id,
    required this.farmId,
    required this.serviceType,
    required this.date,
    required this.value,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.status,
  });

  /// Check if service is recent (within last 30 days)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays <= 30;
  }

  /// Check if service has associated cost
  bool get hasCost => value > 0;

  /// Check if service is a medical/health related type
  bool get isMedical =>
      serviceType == ServiceType.vaccination ||
      serviceType == ServiceType.veterinary ||
      serviceType == ServiceType.medicalTreatment ||
      serviceType == ServiceType.deworming;

  /// Get the number of days since the service was performed
  int get daysSinceService {
    final now = DateTime.now();
    return now.difference(date).inDays;
  }

  /// Create FarmServiceHistory instance from Firestore document
  factory FarmServiceHistory.fromJson(Map<String, dynamic> json) {
    return FarmServiceHistory(
      id: json[FirestoreFields.id] as String,
      farmId: json[FirestoreFields.farmId] as String,
      serviceType: ServiceTypeExtension.fromJson(
        json[FirestoreFields.serviceType] as String,
      ),
      date: (json[FirestoreFields.date] as Timestamp).toDate(),
      value: (json[FirestoreFields.value] as num).toDouble(),
      description: json[FirestoreFields.description] as String? ?? '',
      createdAt: (json[FirestoreFields.createdAt] as Timestamp).toDate(),
      createdBy: json[FirestoreFields.createdBy] as String,
      status: ServiceStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ServiceStatus.done,
      ),
    );
  }

  /// Convert FarmServiceHistory instance to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirestoreFields.id: id,
      FirestoreFields.farmId: farmId,
      FirestoreFields.serviceType: serviceType.toJson(),
      FirestoreFields.date: Timestamp.fromDate(date),
      FirestoreFields.value: value,
      FirestoreFields.description: description,
      FirestoreFields.createdAt: Timestamp.fromDate(createdAt),
      FirestoreFields.createdBy: createdBy,
      'status': status.toString(),
    };
  }

  /// Create a copy of this FarmServiceHistory with modified fields
  FarmServiceHistory copyWith({
    String? id,
    String? farmId,
    ServiceType? serviceType,
    DateTime? date,
    double? value,
    String? description,
    DateTime? createdAt,
    String? createdBy,
    ServiceStatus? status,
  }) {
    return FarmServiceHistory(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      serviceType: serviceType ?? this.serviceType,
      date: date ?? this.date,
      value: value ?? this.value,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
    );
  }

  /// Validate farm service history data
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (value < 0) {
      return 'Service value cannot be negative';
    }
    if (date.isAfter(DateTime.now())) {
      return 'Service date cannot be in the future';
    }
    if (farmId.trim().isEmpty) {
      return 'Farm ID is required';
    }
    if (createdBy.trim().isEmpty) {
      return 'Creator ID is required';
    }
    if (description.trim().isEmpty) {
      return 'Description is required';
    }
    if (description.length > 1000) {
      return 'Description must not exceed 1000 characters';
    }
    return null;
  }

  /// Check if service record is valid
  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
        id,
        farmId,
        serviceType,
        date,
        value,
        description,
        createdAt,
        createdBy,
        status,
      ];

  @override
  String toString() {
    return 'FarmServiceHistory(id: $id, type: ${serviceType.label}, date: $date, value: $value)';
  }
}
