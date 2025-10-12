# Firebase Setup Guide

## Firebase Packages

### Installed Packages
- **firebase_core** (^4.1.1) - Firebase SDK initialization
- **firebase_auth** (^6.1.0) - Authentication
- **cloud_firestore** (^6.0.2) - NoSQL database

### SSO (Single Sign-On) Packages
- **google_sign_in** (^7.2.0) - Google authentication
- **flutter_facebook_auth** (^6.0.3) - Facebook authentication

## Firebase Initialization

### Setup (in main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupDependencies();
  runApp(const MyApp());
}
```

### Firebase Options
- Configuration stored in `lib/firebase_options.dart`
- Platform-specific settings (Android, iOS, Web, Windows)
- Generated via FlutterFire CLI

## Authentication Architecture

### User Model
**Person Model** (`features/authentication/models/person_model.dart`):
- `id`: User ID
- `name`: Full name
- `username`: Unique username
- `email`: Email address
- `description`: User bio/description
- `isOwner`: Farm owner flag
- `isWorker`: Farm worker flag
- `createdAt`: Account creation date
- `photoURL`: Profile photo URL
- `emailVerified`: Email verification status

### Repository Pattern
**UserRepository** (abstract interface):
- `signInWithEmailAndPassword(email, password)` - Email/password login
- `signUpWithEmailAndPassword(...)` - User registration
- `signInWithGoogle()` - Google SSO
- `signInWithFacebook()` - Facebook SSO
- `completeSSOProfile(person)` - Complete SSO user profile
- `getCurrentUser()` - Get current user
- `authStateChanges()` - Listen to auth changes
- `signOut()` - Logout
- `sendPasswordResetEmail(email)` - Password reset
- `getEmailFromUsername(username)` - Username to email lookup

**FirebaseUserRepository** (implementation):
- Located in `features/authentication/repositories/firebase_user_repository.dart`
- Implements UserRepository interface
- Uses FirebaseAuth, Firestore, and SSO services

### Dependency Injection
Firebase services registered in `core/di/injection.dart`:
```dart
// Firebase instances
getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

// SSO Services
getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
getIt.registerLazySingleton<FacebookAuthService>(() => FacebookAuthService());

// Repository
getIt.registerLazySingleton<UserRepository>(
  () => FirebaseUserRepository(
    auth: getIt<FirebaseAuth>(),
    firestore: getIt<FirebaseFirestore>(),
    googleAuthService: getIt<GoogleAuthService>(),
    facebookAuthService: getIt<FacebookAuthService>(),
  ),
);
```

## Authentication Flow

### Email/Password Authentication
1. User enters email/password or username/password
2. If username provided, lookup email in Firestore
3. Sign in with FirebaseAuth
4. Fetch user data from Firestore
5. Return Person model

### SSO Authentication (Google/Facebook)
1. Trigger SSO sign-in via service
2. Check if user exists in Firestore
3. **If existing user**: Return Person model
4. **If new user**: Return profile completion data
5. User completes profile (username, roles)
6. Save to Firestore
7. Return Person model

### Registration Flow
1. Validate email, password, name, username
2. Create user with FirebaseAuth
3. Create Person document in Firestore
4. Return Person model

## Firestore Structure

### Users Collection
Collection: `users`

Document structure:
```json
{
  "name": "John Doe",
  "username": "johndoe",
  "email": "john@example.com",
  "description": "Farm owner",
  "isOwner": true,
  "isWorker": false,
  "createdAt": "2024-01-15T10:30:00Z",
  "photoURL": "https://...",
  "emailVerified": true
}
```

### Username Lookup Collection
Collection: `usernames`

Document structure (for username → email mapping):
```json
{
  "email": "john@example.com"
}
```

Document ID is the username (lowercase).

## Authentication State Management

### AuthBloc Events
- `AuthStatusRequested` - Check current auth status
- `AuthLoginRequested` - Email/password login
- `AuthSignUpRequested` - User registration
- `AuthGoogleSignInRequested` - Google SSO
- `AuthFacebookSignInRequested` - Facebook SSO
- `AuthSSOProfileCompletionRequested` - Complete SSO profile
- `AuthLogoutRequested` - Logout
- `AuthPasswordResetRequested` - Password reset
- `AuthUserChanged` - Auth state changed (internal)

### AuthBloc States
- `AuthInitial` - Initial state
- `AuthLoading` - Processing
- `AuthAuthenticated` - User logged in
- `AuthUnauthenticated` - User logged out
- `AuthSSOProfileCompletionRequired` - SSO user needs profile setup
- `AuthPasswordResetSent` - Password reset email sent
- `AuthFailure` - Error occurred

### AuthGate Widget
Routes users based on auth state:
- `AuthLoading/AuthInitial` → Loading screen
- `AuthAuthenticated` → HomeScreen
- `AuthSSOProfileCompletionRequired` → Profile completion screen
- `AuthUnauthenticated` → LoginScreen

## Error Handling

Error messages handled in `features/authentication/utils/auth_error_messages.dart`:
- Converts Firebase exceptions to user-friendly messages
- Supports localization
- Handles common errors (weak password, email in use, etc.)

## Security

### Token Storage
- Uses `flutter_secure_storage` for secure token storage
- Service: `shared/services/token_storage_service.dart`
- Encrypted storage on device

### Best Practices
1. Never store passwords locally
2. Use Firebase Security Rules for Firestore
3. Validate all inputs (email, password, username)
4. Handle auth state changes properly
5. Sign out on token expiration

## Firebase Console Setup

Required Firebase services:
1. **Authentication**:
   - Email/Password provider enabled
   - Google Sign-In enabled
   - Facebook Sign-In enabled

2. **Firestore Database**:
   - `users` collection
   - `usernames` collection
   - Security rules configured

3. **Platform Configuration**:
   - Android: google-services.json
   - iOS: GoogleService-Info.plist
   - Web: Firebase config
   - Windows: Firebase config

## Resources
- Firebase Flutter Setup: https://firebase.google.com/docs/flutter/setup
- Firebase Auth: https://firebase.google.com/docs/auth/flutter/start
- Firestore: https://firebase.google.com/docs/firestore/quickstart
- Google Sign-In: https://pub.dev/packages/google_sign_in
- Facebook Auth: https://pub.dev/packages/flutter_facebook_auth
