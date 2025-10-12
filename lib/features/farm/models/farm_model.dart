import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/firestore_paths.dart';

/// Farm model representing a livestock farm entity
///
/// This model contains all farm information including capacity,
/// ownership, and metadata. Each farm can have multiple people,
/// cattle lots, goals, and services.
///
/// Business Rules:
/// - Name must be 3-100 characters
/// - Capacity must be > 0
/// - Description is optional, max 500 characters
class Farm extends Equatable {
  /// Unique identifier for the farm
  final String id;

  /// Farm name (required, 3-100 characters)
  final String name;

  /// Farm description (optional, max 500 characters)
  final String description;

  /// Maximum cattle capacity
  final int capacity;

  /// User ID of the farm creator
  final String createdBy;

  /// Timestamp when farm was created
  final DateTime createdAt;

  /// Timestamp of last update (null if never updated)
  final DateTime? updatedAt;

  const Farm({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create Farm instance from Firestore document
  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json[FirestoreFields.id] as String,
      name: json[FirestoreFields.name] as String,
      description: json[FirestoreFields.description] as String? ?? '',
      capacity: json[FirestoreFields.capacity] as int,
      createdBy: json[FirestoreFields.createdBy] as String,
      createdAt: (json[FirestoreFields.createdAt] as Timestamp).toDate(),
      updatedAt: json[FirestoreFields.updatedAt] != null
          ? (json[FirestoreFields.updatedAt] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert Farm instance to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirestoreFields.id: id,
      FirestoreFields.name: name,
      FirestoreFields.description: description,
      FirestoreFields.capacity: capacity,
      FirestoreFields.createdBy: createdBy,
      FirestoreFields.createdAt: Timestamp.fromDate(createdAt),
      if (updatedAt != null)
        FirestoreFields.updatedAt: Timestamp.fromDate(updatedAt!),
    };
  }

  /// Create a copy of this Farm with modified fields
  Farm copyWith({
    String? id,
    String? name,
    String? description,
    int? capacity,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Farm(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      capacity: capacity ?? this.capacity,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Validate farm data
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (name.trim().isEmpty) {
      return 'Farm name is required';
    }
    if (name.trim().length < 3) {
      return 'Farm name must be at least 3 characters';
    }
    if (name.length > 100) {
      return 'Farm name must not exceed 100 characters';
    }
    if (description.length > 500) {
      return 'Description must not exceed 500 characters';
    }
    if (capacity <= 0) {
      return 'Capacity must be greater than 0';
    }
    if (capacity > 100000) {
      return 'Capacity seems unreasonably high';
    }
    return null;
  }

  /// Check if farm is valid
  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        capacity,
        createdBy,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Farm(id: $id, name: $name, capacity: $capacity)';
  }
}
