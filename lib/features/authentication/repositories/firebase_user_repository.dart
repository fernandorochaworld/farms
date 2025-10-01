import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/person_model.dart';
import '../services/facebook_auth_service.dart';
import '../services/google_auth_service.dart';
import 'user_repository.dart';

/// Firebase implementation of UserRepository
/// Handles all authentication and user management using Firebase services
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
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        return Person.fromJson(docSnapshot.data()!);
      } else {
        // Create new person for SSO user
        final username = await _generateUniqueUsernameFromEmail(user.email!);
        final person = Person(
          id: user.uid,
          name: user.displayName ?? '',
          username: username,
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
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        return Person.fromJson(docSnapshot.data()!);
      } else {
        // Create new person for SSO user
        final username = await _generateUniqueUsernameFromEmail(user.email!);
        final person = Person(
          id: user.uid,
          name: user.displayName ?? '',
          username: username,
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
      try {
        return await _getPersonFromFirestore(user.uid);
      } catch (e) {
        return null;
      }
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
      // Check if email is already registered by attempting to create a user
      // If email exists, createUserWithEmailAndPassword will throw an error
      // This is a workaround since fetchSignInMethodsForEmail is deprecated

      // Alternative: Query Firestore users collection
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
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

  /// Retrieves Person data from Firestore
  Future<Person> _getPersonFromFirestore(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();

    if (!docSnapshot.exists) {
      throw Exception('User not found in database');
    }

    return Person.fromJson(docSnapshot.data()!);
  }

  /// Generates a username from email
  String _generateUsernameFromEmail(String email) {
    return email
        .split('@')[0]
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_');
  }

  /// Generates a unique username from email by checking availability
  Future<String> _generateUniqueUsernameFromEmail(String email) async {
    var username = _generateUsernameFromEmail(email);

    // Check if username is available
    var isAvailable = await isUsernameAvailable(username);

    // If not available, append numbers until we find an available one
    if (!isAvailable) {
      var counter = 1;
      while (!isAvailable) {
        username = '${_generateUsernameFromEmail(email)}$counter';
        isAvailable = await isUsernameAvailable(username);
        counter++;
      }
    }

    return username;
  }

  /// Handles Firebase Auth exceptions and returns user-friendly error messages
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
      case 'operation-not-allowed':
        return Exception('Operation not allowed. Please contact support');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
