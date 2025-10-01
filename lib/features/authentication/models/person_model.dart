import 'package:equatable/equatable.dart';

/// Person model representing user data in the system.
/// This model is used for both authenticated users and general people in the system.
/// It syncs with SSO data and stores additional user information.
class Person extends Equatable {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? description;
  final bool isOwner;
  final bool isWorker;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? photoURL;
  final bool emailVerified;

  const Person({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.description,
    this.isOwner = false,
    this.isWorker = false,
    required this.createdAt,
    this.updatedAt,
    this.photoURL,
    this.emailVerified = false,
  });

  /// Creates a Person from JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      description: json['description'] as String?,
      isOwner: json['isOwner'] as bool? ?? false,
      isWorker: json['isWorker'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      photoURL: json['photoURL'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }

  /// Converts Person to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'description': description,
      'isOwner': isOwner,
      'isWorker': isWorker,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'photoURL': photoURL,
      'emailVerified': emailVerified,
    };
  }

  /// Creates a copy of Person with updated fields
  Person copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? description,
    bool? isOwner,
    bool? isWorker,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoURL,
    bool? emailVerified,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      description: description ?? this.description,
      isOwner: isOwner ?? this.isOwner,
      isWorker: isWorker ?? this.isWorker,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        description,
        isOwner,
        isWorker,
        createdAt,
        updatedAt,
        photoURL,
        emailVerified,
      ];
}
