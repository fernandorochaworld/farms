# Single Sign-On (SSO) Feature

## Overview
Implementation of Single Sign-On authentication supporting Google and Facebook providers, integrated with Firebase Authentication.

## Implementation Checklist

### Configuration & Setup
- [ ] Configure Firebase project for Google Sign-In
- [ ] Configure Firebase project for Facebook Sign-In
- [x] Add required dependencies to `pubspec.yaml`
- [ ] Setup platform-specific configuration (iOS/Android/Web)
- [x] Create environment configuration files
- [x] Configure Firebase Security Rules

### Core Implementation
- [x] Create SSO service with dependency injection
- [x] Implement Google Sign-In flow
- [x] Implement Facebook Sign-In flow
- [x] Add Firebase Auth state listener
- [x] Create typed user models with `fromJson`/`toJson`
- [x] Implement token management and refresh
- [x] Add secure token storage
- [x] Implement sign-out functionality

### UI Components
- [x] Create SSO buttons widget (Google & Facebook)
- [x] Design authentication screen
- [x] Add loading states
- [x] Implement error state UI
- [x] Add success feedback
- [ ] Handle platform-specific UI differences

### Error Handling
- [x] Handle user cancellation gracefully
- [x] Implement network failure handling
- [x] Add retry mechanisms
- [x] Show user-friendly error messages
- [x] Log errors for debugging
- [x] Handle auth credential conflicts

### Security
- [ ] Validate credentials server-side
- [x] Implement proper token storage (no plain text)
- [x] Request minimal necessary permissions
- [x] Add input validation
- [x] Configure Firebase Security Rules
- [ ] Setup environment variables for sensitive data

### Testing
- [ ] Write unit tests for auth service
- [ ] Create widget tests for SSO buttons
- [ ] Test authentication flows (success/failure)
- [ ] Mock Firebase services in tests
- [ ] Test token refresh logic
- [ ] Test sign-out functionality

### Documentation
- [x] Document setup instructions
- [ ] Add inline code documentation
- [ ] Create troubleshooting guide
- [ ] Document environment configuration

## Architecture

### Project Structure
```
lib/
├── features/
│   └── authentication/
│       ├── screens/
│       │   └── sign_in_screen.dart
│       ├── widgets/
│       │   ├── google_sign_in_button.dart
│       │   ├── facebook_sign_in_button.dart
│       │   └── sso_buttons_row.dart
│       ├── services/
│       │   ├── auth_service.dart
│       │   ├── google_auth_service.dart
│       │   └── facebook_auth_service.dart
│       └── models/
│           └── user_model.dart
├── shared/
│   └── services/
│       └── token_storage_service.dart
└── core/
    └── config/
        └── auth_config.dart
```

### Dependencies
```yaml
dependencies:
  firebase_auth: ^4.15.0
  google_sign_in: ^6.1.6
  flutter_facebook_auth: ^6.0.3
  get_it: ^7.6.4
  flutter_secure_storage: ^9.0.0
```

## Configuration Setup

### 1. Environment Configuration

Create `lib/core/config/auth_config.dart`:
```dart
class AuthConfig {
  // Google Sign-In
  static const String googleClientIdAndroid = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_ANDROID',
    defaultValue: '',
  );

  static const String googleClientIdIOS = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_IOS',
    defaultValue: '',
  );

  static const String googleClientIdWeb = String.fromEnvironment(
    'GOOGLE_CLIENT_ID_WEB',
    defaultValue: '',
  );

  // Facebook Sign-In
  static const String facebookAppId = String.fromEnvironment(
    'FACEBOOK_APP_ID',
    defaultValue: '',
  );

  static const String facebookClientToken = String.fromEnvironment(
    'FACEBOOK_CLIENT_TOKEN',
    defaultValue: '',
  );
}
```

### 2. Firebase Console Configuration

#### Google Sign-In Setup
1. Go to Firebase Console → Authentication → Sign-in method
2. Enable Google provider
3. Add your support email
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

#### Facebook Sign-In Setup
1. Create Facebook App at [Facebook Developers](https://developers.facebook.com)
2. Add Facebook Login product
3. Get App ID and App Secret
4. Go to Firebase Console → Authentication → Sign-in method
5. Enable Facebook provider
6. Add Facebook App ID and App Secret

### 3. Platform-Specific Configuration

#### Android (`android/app/build.gradle`)
```gradle
defaultConfig {
    // ... other config
    manifestPlaceholders = [
        facebookAppId: "${System.getenv('FACEBOOK_APP_ID') ?: ''}",
        facebookClientToken: "${System.getenv('FACEBOOK_CLIENT_TOKEN') ?: ''}"
    ]
}
```

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<!-- Google Sign-In -->
<meta-data
    android:name="com.google.android.gms.version"
    android:value="@integer/google_play_services_version" />

<!-- Facebook Sign-In -->
<meta-data
    android:name="com.facebook.sdk.ApplicationId"
    android:value="${facebookAppId}" />
<meta-data
    android:name="com.facebook.sdk.ClientToken"
    android:value="${facebookClientToken}" />
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<!-- Google Sign-In -->
<key>GIDClientID</key>
<string>YOUR_GOOGLE_CLIENT_ID</string>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>

<!-- Facebook Sign-In -->
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookClientToken</key>
<string>YOUR_FACEBOOK_CLIENT_TOKEN</string>
<key>FacebookDisplayName</key>
<string>YOUR_APP_NAME</string>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fbapi</string>
    <string>fb-messenger-share-api</string>
</array>
```

#### Web (`web/index.html`)
```html
<!-- Google Sign-In -->
<meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID_WEB">

<!-- Facebook SDK -->
<script>
  window.fbAsyncInit = function() {
    FB.init({
      appId      : 'YOUR_FACEBOOK_APP_ID',
      cookie     : true,
      xfbml      : true,
      version    : 'v18.0'
    });
  };
</script>
<script async defer crossorigin="anonymous"
  src="https://connect.facebook.net/en_US/sdk.js"></script>
```

### 4. Environment Variables Setup

Create `.env` file (add to `.gitignore`):
```bash
# Google Sign-In
GOOGLE_CLIENT_ID_ANDROID=your_android_client_id
GOOGLE_CLIENT_ID_IOS=your_ios_client_id
GOOGLE_CLIENT_ID_WEB=your_web_client_id

# Facebook Sign-In
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_CLIENT_TOKEN=your_facebook_client_token
```

## Implementation Guide

### 1. Auth Service Interface

```dart
// lib/features/authentication/services/auth_service.dart
abstract class AuthService {
  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithFacebook();
  Future<void> signOut();
  Stream<User?> authStateChanges();
}
```

### 2. Google Sign-In Service

```dart
// lib/features/authentication/services/google_auth_service.dart
class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signIn() async {
    try {
      // Check platform availability
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Log and rethrow
      throw AuthException('Google sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
```

### 3. Facebook Sign-In Service

```dart
// lib/features/authentication/services/facebook_auth_service.dart
class FacebookAuthService {
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signIn() async {
    try {
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        // User cancelled or error
        return null;
      }

      final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw AuthException('Facebook sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    await _facebookAuth.logOut();
  }
}
```

### 4. Dependency Injection Setup

```dart
// lib/core/di/injection.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<GoogleAuthService>(
    () => GoogleAuthService()
  );
  getIt.registerLazySingleton<FacebookAuthService>(
    () => FacebookAuthService()
  );
  getIt.registerLazySingleton<TokenStorageService>(
    () => TokenStorageService()
  );
}
```

### 5. User Model

```dart
// lib/features/authentication/models/user_model.dart
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String provider;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    required this.provider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      provider: json['provider'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'provider': provider,
    };
  }
}
```

## Security Considerations

### Firebase Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Best Practices
- Never commit API keys or tokens to version control
- Use `.env` files with `.gitignore`
- Validate all user inputs
- Implement rate limiting for auth attempts
- Use HTTPS for all network requests
- Store tokens using `flutter_secure_storage`
- Request minimal permissions from providers
- Verify credentials server-side for sensitive operations

## Error Handling

### Common Error Scenarios
1. **User Cancellation**: Handle gracefully, don't show error
2. **Network Failure**: Show retry option with user-friendly message
3. **Invalid Credentials**: Clear message and alternative auth options
4. **Account Exists**: Provide account linking flow
5. **Platform Not Supported**: Show appropriate fallback

### Example Error Handler
```dart
String getErrorMessage(dynamic error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'account-exists-with-different-credential':
        return 'Account exists with different sign-in method';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again';
      case 'network-request-failed':
        return 'Network error. Please check connection';
      default:
        return 'Authentication failed. Please try again';
    }
  }
  return 'An unexpected error occurred';
}
```

## Testing

### Unit Test Example
```dart
// test/features/authentication/services/google_auth_service_test.dart
void main() {
  late GoogleAuthService service;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockAuth = MockFirebaseAuth();
    service = GoogleAuthService(
      googleSignIn: mockGoogleSignIn,
      auth: mockAuth,
    );
  });

  test('signIn returns UserCredential on success', () async {
    // Arrange
    when(mockGoogleSignIn.signIn())
      .thenAnswer((_) async => mockGoogleUser);

    // Act
    final result = await service.signIn();

    // Assert
    expect(result, isA<UserCredential>());
  });
}
```

## Performance Optimization

- Use `const` constructors for SSO buttons
- Implement debouncing for button clicks
- Cache auth state where appropriate
- Optimize asset sizes for provider logos
- Profile auth flow with DevTools

## Troubleshooting

### Common Issues

**Google Sign-In not working on Android**
- Verify SHA-1 fingerprint in Firebase Console
- Check `google-services.json` is up to date
- Ensure Google Play Services is available

**Facebook Sign-In fails on iOS**
- Verify URL schemes in `Info.plist`
- Check Facebook App ID matches
- Ensure app is not in Facebook Development mode for production

**Web authentication issues**
- Verify authorized domains in Firebase Console
- Check CORS settings
- Ensure meta tags are correctly set in `index.html`

## References

- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Facebook Login for Flutter](https://pub.dev/packages/flutter_facebook_auth)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
