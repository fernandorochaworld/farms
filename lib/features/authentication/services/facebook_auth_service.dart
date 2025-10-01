import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Service for handling Facebook Sign-In authentication
class FacebookAuthService {
  final FacebookAuth _facebookAuth;
  final FirebaseAuth _auth;

  FacebookAuthService({
    FacebookAuth? facebookAuth,
    FirebaseAuth? auth,
  })  : _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Sign in with Facebook
  /// Returns null if user cancels the sign-in
  Future<UserCredential?> signIn() async {
    try {
      // Trigger the Facebook authentication flow
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      // User cancelled or error occurred
      if (result.status != LoginStatus.success) {
        return null;
      }

      // Check if access token is available
      if (result.accessToken == null) {
        throw Exception('Facebook sign-in failed: No access token');
      }

      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      // Sign in to Firebase with the Facebook credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Facebook sign-in failed: $e');
    }
  }

  /// Sign out from Facebook
  Future<void> signOut() async {
    try {
      await _facebookAuth.logOut();
    } catch (e) {
      // Log error but don't throw
      // Silent failure is acceptable for sign out
    }
  }
}
