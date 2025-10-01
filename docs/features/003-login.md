# Login & Authentication Feature

## Overview
Complete authentication system supporting traditional email/password login, user registration, password recovery, and Single Sign-On (SSO) integration with Google and Facebook. Built with a repository pattern to enable easy migration between different backend services (Firebase, Supabase, MongoDB, PostgreSQL, MySQL).

## Implementation Checklist

### Configuration & Setup
- [ ] Configure Firebase project for Authentication
- [ ] Setup Firestore for user data storage
- [ ] Add required dependencies to `pubspec.yaml`
- [ ] Create environment configuration files
- [ ] Configure Firebase Security Rules for users collection
- [ ] Setup email/password authentication in Firebase Console
- [ ] Configure password reset email templates

### Core Implementation
- [ ] Create repository pattern abstraction layer
- [ ] Implement Firebase authentication repository
- [ ] Create Person model with all required attributes
- [ ] Implement user registration service
- [ ] Implement email/password login service
- [ ] Integrate SSO services (Google & Facebook)
- [ ] Implement password reset flow
- [ ] Add Firebase Auth state listener
- [ ] Create secure token storage
- [ ] Implement automatic token refresh
- [ ] Add email verification flow
- [ ] Create username availability checker
- [ ] Implement sign-out functionality

### Data Layer
- [ ] Create Person model with `fromJson`/`toJson`
- [ ] Implement User Repository interface
- [ ] Create Firebase User Repository implementation
- [ ] Setup Firestore indexes for queries
- [ ] Implement batch operations for user creation
- [ ] Add data validation layer
- [ ] Create migration-ready repository pattern

### UI Components
- [ ] Design login screen
- [ ] Create registration/sign-up screen
- [ ] Design forgot password screen
- [ ] Build password reset confirmation screen
- [ ] Create custom text input widgets (email, password, username)
- [ ] Implement SSO buttons integration
- [ ] Add loading states for all forms
- [ ] Implement error state UI
- [ ] Add success feedback messages
- [ ] Create password visibility toggle
- [ ] Add form validation indicators
- [ ] Implement responsive layouts

### Form Validation
- [ ] Add email format validation
- [ ] Implement password strength validation
- [ ] Add username format validation
- [ ] Create name validation rules
- [ ] Implement real-time field validation
- [ ] Add form-level validation
- [ ] Create custom validation error messages
- [ ] Implement client-side validation
- [ ] Add server-side validation

### Error Handling
- [ ] Handle invalid credentials
- [ ] Implement network failure handling
- [ ] Handle email already in use
- [ ] Handle username already taken
- [ ] Add weak password errors
- [ ] Handle invalid email errors
- [ ] Implement user not found errors
- [ ] Add retry mechanisms
- [ ] Show user-friendly error messages
- [ ] Log errors for debugging

### Security
- [ ] Hash passwords (handled by Firebase Auth)
- [ ] Implement secure token storage
- [ ] Add input sanitization
- [ ] Validate all user inputs
- [ ] Configure Firebase Security Rules
- [ ] Setup environment variables for sensitive data
- [ ] Implement rate limiting for auth attempts
- [ ] Add CAPTCHA for registration (optional)
- [ ] Validate email verification
- [ ] Implement account lockout policy

### Testing
- [ ] Write unit tests for auth repository
- [ ] Create unit tests for Person model
- [ ] Test login flow (success/failure)
- [ ] Test registration flow
- [ ] Test password reset flow
- [ ] Test SSO integration
- [ ] Create widget tests for login screen
- [ ] Create widget tests for registration screen
- [ ] Test form validation logic
- [ ] Mock Firebase services in tests
- [ ] Test repository pattern abstraction
- [ ] Aim for >70% code coverage

### Documentation
- [ ] Document setup instructions
- [ ] Add inline code documentation
- [ ] Create troubleshooting guide
- [ ] Document migration strategy for databases
- [ ] Document environment configuration
- [ ] Create user flow diagrams

## Architecture

### Project Structure
```
lib/
├── features/
│   └── authentication/
│       ├── screens/
│       │   ├── login_screen.dart
│       │   ├── sign_up_screen.dart
│       │   ├── forgot_password_screen.dart
│       │   └── reset_password_confirmation_screen.dart
│       ├── widgets/
│       │   ├── email_input_field.dart
│       │   ├── password_input_field.dart
│       │   ├── username_input_field.dart
│       │   ├── name_input_field.dart
│       │   ├── login_form.dart
│       │   ├── sign_up_form.dart
│       │   ├── forgot_password_form.dart
│       │   ├── sso_buttons_row.dart (from SSO feature)
│       │   └── auth_error_message.dart
│       ├── services/
│       │   ├── auth_service.dart
│       │   ├── google_auth_service.dart (from SSO)
│       │   ├── facebook_auth_service.dart (from SSO)
│       │   └── password_reset_service.dart
│       ├── repositories/
│       │   ├── user_repository.dart (interface)
│       │   └── firebase_user_repository.dart (implementation)
│       ├── models/
│       │   └── person_model.dart
│       └── controllers/
│           ├── login_controller.dart
│           └── sign_up_controller.dart
├── shared/
│   └── services/
│       └── token_storage_service.dart
└── core/
    ├── config/
    │   └── auth_config.dart
    └── di/
        └── injection.dart
```

### Dependencies
```yaml
dependencies:
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0

  # SSO (from SSO feature)
  google_sign_in: ^6.1.6
  flutter_facebook_auth: ^6.0.3

  # Storage & DI
  flutter_secure_storage: ^9.0.0
  get_it: ^7.6.4

  # State Management (choose one)
  flutter_bloc: ^8.1.3
  # or provider: ^6.1.1
  # or riverpod: ^2.4.9

  # Form Validation
  formz: ^0.6.1

  # Utilities
  equatable: ^2.0.5

dev_dependencies:
  # Testing
  mockito: ^5.4.4
  build_runner: ^2.4.7
```

## Data Model

### Person Model

```dart
// lib/features/authentication/models/person_model.dart
import 'package:equatable/equatable.dart';

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
```

## Repository Pattern Implementation

### Repository Interface

```dart
// lib/features/authentication/repositories/user_repository.dart
abstract class UserRepository {
  /// Authenticate user with email and password
  Future<Person> signInWithEmailAndPassword(String email, String password);

  /// Register new user with email and password
  Future<Person> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
    String? description,
    bool isOwner = false,
    bool isWorker = false,
  });

  /// Sign in with Google (SSO)
  Future<Person> signInWithGoogle();

  /// Sign in with Facebook (SSO)
  Future<Person> signInWithFacebook();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Verify password reset code
  Future<bool> verifyPasswordResetCode(String code);

  /// Confirm password reset
  Future<void> confirmPasswordReset(String code, String newPassword);

  /// Sign out current user
  Future<void> signOut();

  /// Get current user
  Future<Person?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<Person?> authStateChanges();

  /// Check if username is available
  Future<bool> isUsernameAvailable(String username);

  /// Check if email is available
  Future<bool> isEmailAvailable(String email);

  /// Update user profile
  Future<Person> updateProfile(Person person);

  /// Send email verification
  Future<void> sendEmailVerification();

  /// Reload user data
  Future<Person?> reloadUser();
}
```

### Firebase Implementation

```dart
// lib/features/authentication/repositories/firebase_user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/person_model.dart';
import '../services/google_auth_service.dart';
import '../services/facebook_auth_service.dart';
import 'user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleAuthService _googleAuthService;
  final FacebookAuthService _facebookAuthService;

  FirebaseUserRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    required GoogleAuthService googleAuthService,
    required FacebookAuthService facebookAuthService,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleAuthService = googleAuthService,
        _facebookAuthService = facebookAuthService;

  @override
  Future<Person> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await _getPersonFromFirestore(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<Person> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
    String? description,
    bool isOwner = false,
    bool isWorker = false,
  }) async {
    try {
      // Check username availability
      final usernameAvailable = await isUsernameAvailable(username);
      if (!usernameAvailable) {
        throw Exception('Username already taken');
      }

      // Create auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Create person document
      final person = Person(
        id: user.uid,
        name: name,
        username: username,
        email: email,
        description: description,
        isOwner: isOwner,
        isWorker: isWorker,
        createdAt: DateTime.now(),
        emailVerified: user.emailVerified,
      );

      await _firestore.collection('users').doc(user.uid).set(person.toJson());

      // Send email verification
      await user.sendEmailVerification();

      return person;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<Person> signInWithGoogle() async {
    try {
      final userCredential = await _googleAuthService.signIn();

      if (userCredential == null) {
        throw Exception('Google sign-in cancelled');
      }

      final user = userCredential.user!;

      // Check if user exists in Firestore
      final docSnapshot = await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        return Person.fromJson(docSnapshot.data()!);
      } else {
        // Create new person for SSO user
        final person = Person(
          id: user.uid,
          name: user.displayName ?? '',
          username: _generateUsernameFromEmail(user.email!),
          email: user.email!,
          createdAt: DateTime.now(),
          photoURL: user.photoURL,
          emailVerified: user.emailVerified,
        );

        await _firestore.collection('users').doc(user.uid).set(person.toJson());
        return person;
      }
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  @override
  Future<Person> signInWithFacebook() async {
    try {
      final userCredential = await _facebookAuthService.signIn();

      if (userCredential == null) {
        throw Exception('Facebook sign-in cancelled');
      }

      final user = userCredential.user!;

      // Check if user exists in Firestore
      final docSnapshot = await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        return Person.fromJson(docSnapshot.data()!);
      } else {
        // Create new person for SSO user
        final person = Person(
          id: user.uid,
          name: user.displayName ?? '',
          username: _generateUsernameFromEmail(user.email!),
          email: user.email!,
          createdAt: DateTime.now(),
          photoURL: user.photoURL,
          emailVerified: user.emailVerified,
        );

        await _firestore.collection('users').doc(user.uid).set(person.toJson());
        return person;
      }
    } catch (e) {
      throw Exception('Facebook sign-in failed: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<bool> verifyPasswordResetCode(String code) async {
    try {
      await _auth.verifyPasswordResetCode(code);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleAuthService.signOut(),
      _facebookAuthService.signOut(),
    ]);
  }

  @override
  Future<Person?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    return await _getPersonFromFirestore(user.uid);
  }

  @override
  Stream<Person?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getPersonFromFirestore(user.uid);
    });
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Person> updateProfile(Person person) async {
    try {
      final updatedPerson = person.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(person.id)
          .update(updatedPerson.toJson());

      return updatedPerson;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<Person?> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    await user.reload();
    return await _getPersonFromFirestore(user.uid);
  }

  // Helper methods
  Future<Person> _getPersonFromFirestore(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();

    if (!docSnapshot.exists) {
      throw Exception('User not found in database');
    }

    return Person.fromJson(docSnapshot.data()!);
  }

  String _generateUsernameFromEmail(String email) {
    return email.split('@')[0].toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Invalid password');
      case 'email-already-in-use':
        return Exception('Email already in use');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
```

## Form Validation

### Email Validation

```dart
// lib/features/authentication/validators/email_validator.dart
import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!_emailRegex.hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}
```

### Password Validation

```dart
// lib/features/authentication/validators/password_validator.dart
import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort, weak }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.tooShort;
    } else if (!_isStrongPassword(value)) {
      return PasswordValidationError.weak;
    }
    return null;
  }

  bool _isStrongPassword(String value) {
    // At least one uppercase, one lowercase, one number
    return value.contains(RegExp(r'[A-Z]')) &&
        value.contains(RegExp(r'[a-z]')) &&
        value.contains(RegExp(r'[0-9]'));
  }
}
```

### Username Validation

```dart
// lib/features/authentication/validators/username_validator.dart
import 'package:formz/formz.dart';

enum UsernameValidationError { empty, tooShort, invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) {
      return UsernameValidationError.empty;
    } else if (value.length < 3) {
      return UsernameValidationError.tooShort;
    } else if (!_usernameRegex.hasMatch(value)) {
      return UsernameValidationError.invalid;
    }
    return null;
  }
}
```

## Dependency Injection Setup

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/authentication/repositories/user_repository.dart';
import '../../features/authentication/repositories/firebase_user_repository.dart';
import '../../features/authentication/services/google_auth_service.dart';
import '../../features/authentication/services/facebook_auth_service.dart';
import '../../shared/services/token_storage_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Firebase instances
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Auth services
  getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
  getIt.registerLazySingleton<FacebookAuthService>(() => FacebookAuthService());

  // Storage
  getIt.registerLazySingleton<TokenStorageService>(() => TokenStorageService());

  // Repository
  getIt.registerLazySingleton<UserRepository>(
    () => FirebaseUserRepository(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      googleAuthService: getIt<GoogleAuthService>(),
      facebookAuthService: getIt<FacebookAuthService>(),
    ),
  );
}
```

## Firebase Configuration

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    function isValidUser(user) {
      return user.keys().hasAll(['id', 'name', 'username', 'email', 'createdAt']) &&
             user.name is string && user.name.size() > 0 &&
             user.username is string && user.username.matches('^[a-zA-Z0-9_]{3,20}$') &&
             user.email is string && user.email.matches('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$') &&
             user.isOwner is bool &&
             user.isWorker is bool;
    }

    // Users collection
    match /users/{userId} {
      // Anyone can read user profiles (adjust as needed)
      allow read: if isAuthenticated();

      // Users can create their own profile
      allow create: if isOwner(userId) && isValidUser(request.resource.data);

      // Users can update their own profile
      allow update: if isOwner(userId) &&
                       isValidUser(request.resource.data) &&
                       request.resource.data.id == resource.data.id &&
                       request.resource.data.createdAt == resource.data.createdAt;

      // Users can delete their own profile
      allow delete: if isOwner(userId);
    }
  }
}
```

### Firestore Indexes

Create in Firebase Console or `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "users",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "username", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "users",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "email", "order": "ASCENDING" }
      ]
    }
  ]
}
```

## UI Implementation Examples

### Login Screen

```dart
// lib/features/authentication/screens/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or app name
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Login form
                const LoginForm(),

                const SizedBox(height: 16),

                // Forgot password
                TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen
                  },
                  child: const Text('Forgot Password?'),
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // SSO buttons
                const SSOButtonsRow(),

                const SizedBox(height: 24),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up screen
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Sign Up Screen Structure

```dart
// lib/features/authentication/screens/sign_up_screen.dart
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join Us',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Sign up form with all fields
                const SignUpForm(),

                const SizedBox(height: 24),

                // SSO options
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),
                const SSOButtonsRow(),

                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Error Handling

### Error Messages

```dart
// lib/features/authentication/utils/auth_error_messages.dart
class AuthErrorMessages {
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('user not found')) {
      return 'No account found with this email';
    } else if (errorString.contains('wrong password') ||
               errorString.contains('invalid password')) {
      return 'Invalid email or password';
    } else if (errorString.contains('email already in use')) {
      return 'An account already exists with this email';
    } else if (errorString.contains('username already taken')) {
      return 'This username is already taken';
    } else if (errorString.contains('weak password')) {
      return 'Password must be at least 8 characters with uppercase, lowercase, and numbers';
    } else if (errorString.contains('invalid email')) {
      return 'Please enter a valid email address';
    } else if (errorString.contains('network')) {
      return 'Network error. Please check your connection';
    } else if (errorString.contains('too many requests')) {
      return 'Too many attempts. Please try again later';
    } else if (errorString.contains('cancelled')) {
      return ''; // Don't show error for user cancellation
    } else {
      return 'An error occurred. Please try again';
    }
  }
}
```

## Migration Strategy

### Database Abstraction Benefits

The repository pattern enables easy migration to other databases:

1. **Supabase Migration**: Create `SupabaseUserRepository` implementing `UserRepository`
2. **MongoDB Migration**: Create `MongoUserRepository` implementing `UserRepository`
3. **PostgreSQL Migration**: Create `PostgresUserRepository` implementing `UserRepository`
4. **MySQL Migration**: Create `MySQLUserRepository` implementing `UserRepository`

### Migration Steps

```dart
// Example: Switching to Supabase
// 1. Create new repository
class SupabaseUserRepository implements UserRepository {
  // Implement all methods using Supabase client
}

// 2. Update dependency injection
void setupDependencies() {
  // Replace Firebase repository
  getIt.registerLazySingleton<UserRepository>(
    () => SupabaseUserRepository(), // Changed from FirebaseUserRepository
  );
}

// 3. No changes needed in UI or business logic!
```

## Security Best Practices

### Password Security
- Minimum 8 characters
- Must contain uppercase, lowercase, and numbers
- Consider adding special characters requirement
- Implement password strength meter in UI

### Token Management
- Store tokens using `flutter_secure_storage`
- Never store passwords in plain text
- Implement automatic token refresh
- Clear tokens on sign out

### Input Validation
- Validate all inputs client-side AND server-side
- Sanitize user inputs before storage
- Use parameterized queries (handled by Firebase/Firestore)
- Implement rate limiting for authentication attempts

### Environment Security
- Never commit `.env` files
- Use different configurations for dev/staging/production
- Rotate API keys regularly
- Use Firebase Security Rules properly

## Testing Strategy

### Unit Tests

```dart
// test/features/authentication/repositories/firebase_user_repository_test.dart
void main() {
  late FirebaseUserRepository repository;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockGoogleAuthService mockGoogleAuth;
  late MockFacebookAuthService mockFacebookAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockGoogleAuth = MockGoogleAuthService();
    mockFacebookAuth = MockFacebookAuthService();

    repository = FirebaseUserRepository(
      auth: mockAuth,
      firestore: mockFirestore,
      googleAuthService: mockGoogleAuth,
      facebookAuthService: mockFacebookAuth,
    );
  });

  group('signInWithEmailAndPassword', () {
    test('returns Person on successful login', () async {
      // Arrange
      when(mockAuth.signInWithEmailAndPassword(
        email: any,
        password: any,
      )).thenAnswer((_) async => mockUserCredential);

      when(mockFirestore.collection('users').doc(any).get())
        .thenAnswer((_) async => mockDocSnapshot);

      // Act
      final result = await repository.signInWithEmailAndPassword(
        'test@example.com',
        'password123',
      );

      // Assert
      expect(result, isA<Person>());
    });

    test('throws exception on invalid credentials', () async {
      // Arrange
      when(mockAuth.signInWithEmailAndPassword(
        email: any,
        password: any,
      )).thenThrow(
        FirebaseAuthException(code: 'wrong-password'),
      );

      // Act & Assert
      expect(
        () => repository.signInWithEmailAndPassword(
          'test@example.com',
          'wrongpassword',
        ),
        throwsException,
      );
    });
  });

  group('signUpWithEmailAndPassword', () {
    test('creates new user successfully', () async {
      // Test implementation
    });

    test('throws exception if username taken', () async {
      // Test implementation
    });
  });
}
```

## Performance Optimization

- Use `const` constructors for widgets
- Implement debouncing for username availability checks
- Cache auth state appropriately
- Optimize form rebuilds with proper state management
- Profile with Flutter DevTools

## Troubleshooting

### Common Issues

**Email/Password login not working**
- Verify email/password provider is enabled in Firebase Console
- Check Firebase Security Rules allow read/write
- Ensure user document exists in Firestore

**SSO integration issues**
- See SSO documentation (002-single-sign-on.md)
- Verify platform-specific configurations

**Password reset email not sending**
- Check email template in Firebase Console
- Verify email is correctly configured
- Check spam folder

**Username uniqueness not enforced**
- Ensure Firestore index exists for username field
- Verify repository checks username before creation

## References

- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
- [SSO Integration Guide](./002-single-sign-on.md)
- [Best Practices Guide](../000-base/001-good-practices.md)
