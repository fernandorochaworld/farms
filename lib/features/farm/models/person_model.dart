import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';

/// Person model representing a user associated with a farm
///
/// This model links an authenticated user to a farm with specific
/// roles and permissions. Each person has a type that determines
/// their access level and capabilities within the farm.
///
/// Business Rules:
/// - Name must be 3-100 characters
/// - Person type is required
/// - User ID must exist in users collection
/// - Only one admin per farm is recommended
class Person extends Equatable {
  /// Unique identifier for the person
  final String id;

  /// Farm this person belongs to
  final String farmId;

  /// User ID from authentication (links to User collection)
  final String userId;

  /// Person's display name
  final String name;

  /// Optional description or notes about this person
  final String? description;

  /// Person's role type (owner, manager, worker, arrendatario)
  final PersonType personType;

  /// Whether this person has admin privileges for the farm
  final bool isAdmin;

  /// Timestamp when person was added to farm
  final DateTime createdAt;

  const Person({
    required this.id,
    required this.farmId,
    required this.userId,
    required this.name,
    this.description,
    required this.personType,
    required this.isAdmin,
    required this.createdAt,
  });

  /// Create Person instance from Firestore document
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json[FirestoreFields.id] as String,
      farmId: json[FirestoreFields.farmId] as String,
      userId: json[FirestoreFields.userId] as String,
      name: json[FirestoreFields.name] as String,
      description: json[FirestoreFields.description] as String?,
      personType: PersonTypeExtension.fromJson(
        json[FirestoreFields.personType] as String,
      ),
      isAdmin: json[FirestoreFields.isAdmin] as bool? ?? false,
      createdAt: (json[FirestoreFields.createdAt] as Timestamp).toDate(),
    );
  }

  /// Convert Person instance to Firestore document
  Map<String, dynamic> toJson() {
    return {
      FirestoreFields.id: id,
      FirestoreFields.farmId: farmId,
      FirestoreFields.userId: userId,
      FirestoreFields.name: name,
      if (description != null) FirestoreFields.description: description,
      FirestoreFields.personType: personType.toJson(),
      FirestoreFields.isAdmin: isAdmin,
      FirestoreFields.createdAt: Timestamp.fromDate(createdAt),
    };
  }

  /// Create a copy of this Person with modified fields
  Person copyWith({
    String? id,
    String? farmId,
    String? userId,
    String? name,
    String? description,
    PersonType? personType,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return Person(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      personType: personType ?? this.personType,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Validate person data
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (name.length > 100) {
      return 'Name must not exceed 100 characters';
    }
    if (userId.trim().isEmpty) {
      return 'User ID is required';
    }
    if (farmId.trim().isEmpty) {
      return 'Farm ID is required';
    }
    return null;
  }

  /// Check if person is valid
  bool get isValid => validate() == null;

  /// Check if person can manage farm operations
  bool get canManage =>
      personType == PersonType.owner || personType == PersonType.manager;

  /// Check if person has full ownership
  bool get isOwner => personType == PersonType.owner;

  @override
  List<Object?> get props => [
        id,
        farmId,
        userId,
        name,
        description,
        personType,
        isAdmin,
        createdAt,
      ];

  @override
  String toString() {
    return 'Person(id: $id, name: $name, type: ${personType.label})';
  }
}
