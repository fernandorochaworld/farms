# Firebase Setup Guide

This guide will help you configure Firebase for the Farms application.

## Prerequisites

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name (e.g., "farms-app")
4. Follow the setup wizard

## Step 2: Enable Authentication Providers

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider
3. Enable **Google** provider:
   - Add support email
   - Note the Web client ID for later
4. Enable **Facebook** provider (optional):
   - Go to [Facebook Developers](https://developers.facebook.com/)
   - Create a new app
   - Add Facebook Login product
   - Get App ID and App Secret
   - Add them to Firebase Console

## Step 3: Configure Firebase for Flutter

Run the FlutterFire configuration command:

```bash
flutterfire configure
```

This will:
- Ask you to select your Firebase project
- Generate `lib/firebase_options.dart` with proper configuration
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

## Step 4: Setup Firestore

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose production mode
4. Select a location

### Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

### Deploy Firestore Indexes

```bash
firebase deploy --only firestore:indexes
```

## Step 5: Platform-Specific Configuration

### Android Configuration

1. Ensure `android/app/google-services.json` exists
2. Update `android/app/build.gradle` if needed for SSO

For Facebook Sign-In, add to `android/app/build.gradle`:
```gradle
defaultConfig {
    // ... other config
    manifestPlaceholders = [
        facebookAppId: "YOUR_FACEBOOK_APP_ID",
        facebookClientToken: "YOUR_FACEBOOK_CLIENT_TOKEN"
    ]
}
```

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <!-- ... -->

    <!-- Google Sign-In -->
    <meta-data
        android:name="com.google.android.gms.version"
        android:value="@integer/google_play_services_version" />

    <!-- Facebook Sign-In (if using) -->
    <meta-data
        android:name="com.facebook.sdk.ApplicationId"
        android:value="${facebookAppId}" />
    <meta-data
        android:name="com.facebook.sdk.ClientToken"
        android:value="${facebookClientToken}" />
</application>
```

Add your SHA-1 fingerprint to Firebase Console:
```bash
# For debug builds
cd android
./gradlew signingReport
```

Copy the SHA-1 fingerprint and add it in Firebase Console → Project Settings → Your App

### iOS Configuration

1. Ensure `ios/Runner/GoogleService-Info.plist` exists
2. Update `ios/Runner/Info.plist` for SSO

Add to `ios/Runner/Info.plist`:
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
    <!-- If using Facebook -->
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>

<!-- Facebook Sign-In (if using) -->
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookClientToken</key>
<string>YOUR_FACEBOOK_CLIENT_TOKEN</string>
<key>FacebookDisplayName</key>
<string>Farms</string>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fbapi</string>
    <string>fb-messenger-share-api</string>
</array>
```

### Web Configuration

Update `web/index.html` to include:

```html
<head>
    <!-- ... -->

    <!-- Google Sign-In -->
    <meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID_WEB">

    <!-- Facebook SDK (if using) -->
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
</head>
```

## Step 6: Environment Variables (Optional)

Create `.env` file in project root (add to `.gitignore`):

```bash
# Google Sign-In
GOOGLE_CLIENT_ID_ANDROID=your_android_client_id
GOOGLE_CLIENT_ID_IOS=your_ios_client_id
GOOGLE_CLIENT_ID_WEB=your_web_client_id

# Facebook Sign-In
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_CLIENT_TOKEN=your_facebook_client_token
```

## Step 7: Test the Configuration

1. Run the app:
   ```bash
   flutter run
   ```

2. Try the following:
   - Email/password registration
   - Email/password login
   - Google Sign-In
   - Facebook Sign-In (if configured)
   - Password reset

## Troubleshooting

### Android Issues

**SHA-1 Fingerprint Mismatch**
- Make sure you added the correct SHA-1 fingerprint in Firebase Console
- For release builds, use the release keystore SHA-1

**Google Sign-In Not Working**
- Verify `google-services.json` is in `android/app/`
- Check that Google Sign-In is enabled in Firebase Console
- Ensure SHA-1 fingerprint is added

### iOS Issues

**Google Sign-In Not Working**
- Verify `GoogleService-Info.plist` is in `ios/Runner/`
- Check that the GIDClientID in Info.plist matches your project
- Ensure URL schemes are correctly configured

### General Issues

**Firebase not initialized**
- Make sure `Firebase.initializeApp()` is called before `runApp()`
- Verify `firebase_options.dart` has correct configuration

**Firestore permission denied**
- Check that security rules are deployed
- Verify user is authenticated before accessing Firestore

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Google Sign-In Package](https://pub.dev/packages/google_sign_in)
- [Facebook Login Package](https://pub.dev/packages/flutter_facebook_auth)
