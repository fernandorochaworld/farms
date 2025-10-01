import '../models/person_model.dart';

/// Abstract repository interface for user authentication and management.
/// This abstraction enables easy migration between different backend services
/// (Firebase, Supabase, MongoDB, PostgreSQL, MySQL).
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

  /// Confirm password reset with new password
  Future<void> confirmPasswordReset(String code, String newPassword);

  /// Sign out current user
  Future<void> signOut();

  /// Get current authenticated user
  Future<Person?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<Person?> authStateChanges();

  /// Check if username is available
  Future<bool> isUsernameAvailable(String username);

  /// Check if email is available
  Future<bool> isEmailAvailable(String email);

  /// Update user profile
  Future<Person> updateProfile(Person person);

  /// Send email verification to current user
  Future<void> sendEmailVerification();

  /// Reload user data from backend
  Future<Person?> reloadUser();
}
