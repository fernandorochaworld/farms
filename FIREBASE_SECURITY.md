# 🔒 Firebase Security & Configuration Guide

## ⚠️ IMPORTANT: What NOT to Commit

The following files contain **sensitive credentials** and are excluded from git via `.gitignore`:

### Firebase Configuration Files
- ❌ `lib/firebase_options.dart` - Contains API keys for all platforms
- ❌ `android/app/google-services.json` - Android Firebase config
- ❌ `ios/Runner/GoogleService-Info.plist` - iOS Firebase config
- ❌ `.firebaserc` - Firebase project aliases

### Environment & Secrets
- ❌ `.env` and `.env.*` - Environment variables
- ❌ `facebook_app_id.txt` - Facebook App ID
- ❌ `facebook_client_token.txt` - Facebook Client Token

### Signing Keys
- ❌ `*.jks` - Android Java KeyStore files
- ❌ `*.keystore` - Android keystore files
- ❌ `key.properties` - Android signing configuration

## ✅ What IS Safe to Commit

These files are templates and should be committed:
- ✅ `lib/firebase_options.dart.example` - Template for Firebase config
- ✅ `firestore.rules` - Database security rules (no secrets)
- ✅ `firestore.indexes.json` - Database indexes (no secrets)
- ✅ `firebase.json` - Firebase project config (no secrets)

## 🔧 Setting Up Firebase (For New Developers)

### Step 1: Install Prerequisites
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login
```

### Step 2: Configure Firebase
```bash
# Run FlutterFire configuration
flutterfire configure
```

This command will:
1. Create `lib/firebase_options.dart` with your project's credentials
2. Generate `android/app/google-services.json`
3. Generate `ios/Runner/GoogleService-Info.plist`

### Step 3: Set Active Firebase Project
```bash
firebase use farms-2025
# Or use your own project:
# firebase use your-project-id
```

### Step 4: Deploy Firestore Rules & Indexes
```bash
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

## 🔐 API Key Security Best Practices

### Are Firebase API Keys Secret?

**Short Answer**: Firebase API keys in `firebase_options.dart` are **not traditional secrets** but should still be protected.

**Why?**
- Firebase API keys are designed to be included in client apps
- They identify your Firebase project, not authenticate users
- Security is enforced through Firestore rules and Firebase Auth

**However**, you should still keep them private because:
- Prevents quota abuse from unauthorized domains
- Reduces exposure to potential attacks
- Maintains best security practices

### Additional Security Measures

1. **Enable App Check** (Recommended for Production)
   ```bash
   # In Firebase Console:
   # Project Settings → App Check
   # Enable for Android, iOS, and Web
   ```

2. **Restrict API Keys** (Firebase Console)
   - Go to Google Cloud Console → APIs & Services → Credentials
   - Restrict each API key to specific platforms and APIs

3. **Use Environment Variables for Secrets**
   ```dart
   // For truly sensitive values (not Firebase config):
   const facebookAppId = String.fromEnvironment('FACEBOOK_APP_ID');
   ```

4. **Monitor Usage** (Firebase Console)
   - Check Firebase Console → Usage and billing
   - Set up budget alerts

## 🚨 If You Accidentally Committed Secrets

### Option 1: Remove from History (Recommended)
```bash
# Remove sensitive file from all commits
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch lib/firebase_options.dart" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (WARNING: Dangerous if others have cloned)
git push origin --force --all
```

### Option 2: Rotate Credentials
1. **Regenerate API Keys** (Firebase Console)
   - Project Settings → General
   - Delete exposed app and create new one
   - Run `flutterfire configure` again

2. **Create New Firebase Project**
   - If widely exposed, create entirely new project
   - Migrate data if necessary

## 📋 Security Checklist

Before pushing code:
- [ ] `lib/firebase_options.dart` is in `.gitignore`
- [ ] `google-services.json` is in `.gitignore`
- [ ] `GoogleService-Info.plist` is in `.gitignore`
- [ ] No hardcoded API keys in source code
- [ ] Firestore security rules are deployed
- [ ] Firebase App Check enabled (production)
- [ ] API keys restricted in Google Cloud Console

Before going to production:
- [ ] Enable Firebase App Check
- [ ] Restrict API keys by platform
- [ ] Set up budget alerts
- [ ] Review Firestore security rules
- [ ] Enable 2FA on Firebase/Google account
- [ ] Use separate Firebase projects for dev/staging/prod

## 📖 Related Documentation

- [Firebase Security Best Practices](https://firebase.google.com/support/guides/security-checklist)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase App Check](https://firebase.google.com/docs/app-check)

---

**Remember**: The best security practice is to never commit credentials in the first place! Always use `.gitignore` before your first commit.
