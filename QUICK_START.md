# 🚀 Quick Start Guide

## Prerequisites

- Flutter SDK installed
- Firebase CLI: `npm install -g firebase-tools`
- FlutterFire CLI: `dart pub global activate flutterfire_cli`

## Setup (5 Steps)

### 1️⃣ Install Dependencies
```bash
flutter pub get
```

### 2️⃣ Configure Firebase
```bash
flutterfire configure
```
- Select or create Firebase project
- Choose platforms (Android, iOS, Web)
- This generates `firebase_options.dart`

### 3️⃣ Enable Authentication in Firebase Console
1. Go to https://console.firebase.google.com
2. Select your project
3. Navigate to **Authentication** → **Sign-in method**
4. Enable:
   - ✅ Email/Password
   - ✅ Google
   - ✅ Facebook (optional)

### 4️⃣ Setup Firestore
1. In Firebase Console, go to **Firestore Database**
2. Click **Create database** → **Production mode**
3. Deploy security rules:
   ```bash
   firebase deploy --only firestore:rules
   ```
4. Deploy indexes:
   ```bash
   firebase deploy --only firestore:indexes
   ```

### 5️⃣ Run the App
```bash
flutter run
```

## Platform-Specific Setup

### Android (Required for Google Sign-In)
1. Get SHA-1 fingerprint:
   ```bash
   cd android
   ./gradlew signingReport
   ```
2. Copy SHA-1 fingerprint
3. Add to Firebase Console → Project Settings → Your App → Add fingerprint

### iOS (Optional)
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- URL schemes are auto-configured by FlutterFire

### Web (Optional)
- Update `web/index.html` with Google client ID
- See `FIREBASE_SETUP.md` for details

## Test the App

Once running, try:
- ✅ Sign up with email/password
- ✅ Login with email/password
- ✅ Sign in with Google
- ✅ Sign in with Facebook (if configured)
- ✅ Forgot password
- ✅ Sign out

## Troubleshooting

**Firebase not initialized?**
→ Run `flutterfire configure`

**Google Sign-In not working on Android?**
→ Add SHA-1 fingerprint to Firebase Console

**Need more help?**
→ See `FIREBASE_SETUP.md` for detailed instructions

## Key Files

- `lib/main.dart` - App entry point with auth guard
- `lib/features/authentication/` - All auth code
- `firestore.rules` - Database security rules
- `FIREBASE_SETUP.md` - Detailed setup guide
- `AUTHENTICATION_README.md` - Implementation details

## Quick Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get && flutter run

# Analyze code
flutter analyze

# Format code
dart format lib/

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Firestore indexes
firebase deploy --only firestore:indexes
```

## What's Implemented

✅ Email/password authentication
✅ User registration with Person model
✅ Google Sign-In (SSO)
✅ Facebook Sign-In (SSO)
✅ Password reset
✅ Form validation
✅ Auth state management with BLoC
✅ Secure token storage
✅ Login as initial page with auth guard
✅ Repository pattern for easy database migration
✅ Firestore security rules

## Next Steps After Setup

1. Customize UI colors/branding in `lib/main.dart`
2. Add more user profile fields if needed
3. Implement additional features
4. Write tests
5. Deploy to production

## Support

- `FIREBASE_SETUP.md` - Complete Firebase setup guide
- `AUTHENTICATION_README.md` - Architecture and usage
- `IMPLEMENTATION_COMPLETE.md` - Full implementation details
- Firebase Console - Check logs and data
- Flutter docs - https://docs.flutter.dev

---

**You're ready to go!** Just run `flutterfire configure` and start the app. 🎉
