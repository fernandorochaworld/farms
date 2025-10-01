import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service for handling Google Sign-In authentication
/// Compatible with google_sign_in 7.x
class GoogleAuthService {
  final FirebaseAuth _auth;
  StreamSubscription? _authEventsSubscription;

  GoogleAuthService({
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;

  /// Sign in with Google using the new v7.x API
  /// Returns null if user cancels the sign-in
  Future<UserCredential?> signIn() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      // Create a completer to handle the async authentication flow
      final completer = Completer<GoogleSignInAccount?>();

      // Subscribe to authentication events
      _authEventsSubscription = googleSignIn.authenticationEvents.listen(
        (event) {
          if (event is GoogleSignInAuthenticationEventSignIn) {
            if (!completer.isCompleted) {
              completer.complete(event.user);
            }
          }
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );

      // Check if authentication is supported and trigger it
      if (googleSignIn.supportsAuthenticate()) {
        try {
          await googleSignIn.authenticate();
        } catch (e) {
          _authEventsSubscription?.cancel();
          // User cancelled or error occurred
          if (e.toString().contains('sign_in_canceled') ||
              e.toString().contains('ERROR_CANCELED')) {
            return null;
          }
          rethrow;
        }
      } else {
        _authEventsSubscription?.cancel();
        throw Exception('Google Sign-In authentication not supported on this platform');
      }

      // Wait for the authentication event with a timeout
      final googleUser = await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _authEventsSubscription?.cancel();
          return null;
        },
      );

      // Cancel subscription
      await _authEventsSubscription?.cancel();

      // User cancelled the sign-in
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential using the ID token from GoogleSignInAuthentication
      // Note: In google_sign_in 7.x, only idToken is provided
      final credential = GoogleAuthProvider.credential(
        accessToken: null, // Not available in v7.x
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Clean up subscription
      await _authEventsSubscription?.cancel();

      // If error contains "sign_in_canceled", user cancelled
      if (e.toString().contains('sign_in_canceled') ||
          e.toString().contains('ERROR_CANCELED') ||
          e.toString().contains('CANCELED')) {
        return null;
      }
      throw Exception('Google sign-in failed: $e');
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _authEventsSubscription?.cancel();
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      // Log error but don't throw
      // Silent failure is acceptable for sign out
    }
  }

  /// Dispose resources
  void dispose() {
    _authEventsSubscription?.cancel();
  }
}
