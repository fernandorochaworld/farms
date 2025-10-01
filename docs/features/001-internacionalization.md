# Internationalization (i18n) Feature

## Overview

This document describes the internationalization implementation for the Flutter app, enabling multi-language support and localization.

## Architecture

### Project Structure

```
lib/
├── core/
│   └── i18n/
│       ├── app_localizations.dart
│       ├── app_localizations_delegate.dart
│       └── supported_locales.dart
├── features/
│   └── [feature_name]/
│       └── i18n/
│           ├── en.dart
│           ├── es.dart
│           └── [locale].dart
└── l10n/
    ├── app_en.arb
    ├── app_es.arb
    └── app_[locale].arb
```

### Implementation Approach

**Option 1: Flutter's Built-in Intl Package** (Recommended)
- Uses ARB (Application Resource Bundle) files
- Code generation with `flutter_localizations`
- Type-safe access to translations
- Official Flutter solution

**Option 2: Easy Localization Package**
- Simpler setup for basic needs
- JSON or ARB file support
- Runtime language switching
- Community-maintained

## Setup Instructions

### Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true
```

### Configuration

Create `l10n.yaml` in project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### Main App Configuration

```dart
// lib/main.dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('pt', ''),
      ],
      locale: Locale('en'), // Default locale
      // Or use device locale:
      // locale: null, // Uses device locale
      home: HomeScreen(),
    );
  }
}
```

## Translation Files

### ARB File Structure

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "Farm Manager",
  "@appTitle": {
    "description": "The application title"
  },
  "welcome": "Welcome, {name}!",
  "@welcome": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items with plural support",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

### Spanish Translation

```json
// lib/l10n/app_es.arb
{
  "@@locale": "es",
  "appTitle": "Administrador de Granja",
  "welcome": "¡Bienvenido, {name}!",
  "itemCount": "{count, plural, =0{Sin elementos} =1{1 elemento} other{{count} elementos}}"
}
```

## Usage in Code

### Accessing Translations

```dart
// In any widget with BuildContext
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Column(
        children: [
          Text(l10n.welcome('John')),
          Text(l10n.itemCount(5)),
        ],
      ),
    );
  }
}
```

### Dynamic Language Switching

```dart
// lib/features/settings/controllers/language_controller.dart
import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}

// In main.dart with Provider
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageController(),
      child: Consumer<LanguageController>(
        builder: (context, languageController, child) {
          return MaterialApp(
            locale: languageController.locale,
            localizationsDelegates: [...],
            supportedLocales: [...],
          );
        },
      ),
    );
  }
}
```

## Best Practices

### Organization
- Keep translation keys descriptive and hierarchical
- Group related translations (e.g., `auth_login`, `auth_signup`)
- Use snake_case for translation keys
- Maintain all ARB files in sync

### Naming Conventions
```dart
// Good
"userProfileTitle": "User Profile"
"authLoginButton": "Log In"
"errorNetworkTimeout": "Network timeout"

// Avoid
"title": "Title"
"button1": "Log In"
"error": "Error"
```

### Placeholders
```json
// Use typed placeholders
"greeting": "Hello, {name}! You have {count} messages.",
"@greeting": {
  "placeholders": {
    "name": {"type": "String"},
    "count": {"type": "int"}
  }
}
```

### Pluralization
```json
"daysRemaining": "{count, plural, =0{Today} =1{1 day left} other{{count} days left}}",
"@daysRemaining": {
  "placeholders": {
    "count": {"type": "int"}
  }
}
```

### Date and Number Formatting

```dart
import 'package:intl/intl.dart';

// Format dates
final dateFormatter = DateFormat.yMMMd(Locale.localeOf(context).toString());
final formattedDate = dateFormatter.format(DateTime.now());

// Format numbers
final numberFormatter = NumberFormat.decimalPattern(Locale.localeOf(context).toString());
final formattedNumber = numberFormatter.format(1234567.89);

// Format currency
final currencyFormatter = NumberFormat.currency(
  locale: Locale.localeOf(context).toString(),
  symbol: '\$',
);
final formattedCurrency = currencyFormatter.format(99.99);
```

## Testing

### Unit Tests

```dart
// test/i18n/localizations_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  test('English translations load correctly', () async {
    final localizations = await AppLocalizations.delegate.load(Locale('en'));
    expect(localizations.appTitle, 'Farm Manager');
  });

  test('Spanish translations load correctly', () async {
    final localizations = await AppLocalizations.delegate.load(Locale('es'));
    expect(localizations.appTitle, 'Administrador de Granja');
  });
}
```

### Widget Tests

```dart
testWidgets('Widget displays correct translation', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: HomeScreen(),
    ),
  );

  expect(find.text('Farm Manager'), findsOneWidget);
});
```

## Common Patterns

### Loading States
```json
"loadingGeneric": "Loading...",
"loadingUserData": "Loading user data...",
"loadingFarmInfo": "Loading farm information..."
```

### Error Messages
```json
"errorGeneric": "An error occurred. Please try again.",
"errorNetwork": "Network connection failed.",
"errorAuth": "Authentication failed. Please log in again.",
"errorPermission": "Permission denied."
```

### Success Messages
```json
"successSaved": "Saved successfully!",
"successDeleted": "Deleted successfully!",
"successUpdated": "Updated successfully!"
```

## Locale Detection

```dart
// lib/core/i18n/locale_detector.dart
class LocaleDetector {
  static Locale getDeviceLocale() {
    final deviceLocale = WidgetsBinding.instance.window.locale;
    return deviceLocale;
  }

  static Locale getSupportedLocale(Locale deviceLocale, List<Locale> supported) {
    // Check for exact match
    for (var locale in supported) {
      if (locale.languageCode == deviceLocale.languageCode &&
          locale.countryCode == deviceLocale.countryCode) {
        return locale;
      }
    }

    // Check for language match
    for (var locale in supported) {
      if (locale.languageCode == deviceLocale.languageCode) {
        return locale;
      }
    }

    // Return default
    return supported.first;
  }
}
```

## Performance Optimization

### Use Const Constructors
```dart
// Good
const Text(key: ValueKey('welcome_text'))

// Load translations once
final l10n = AppLocalizations.of(context)!;
```

### Avoid Rebuilds
```dart
// Cache localization instance when possible
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(l10n.title),
        Text(l10n.subtitle),
        // All texts use same l10n instance
      ],
    );
  }
}
```

## Maintenance Checklist

- [ ] All ARB files contain same keys
- [ ] Placeholders are consistently defined
- [ ] Metadata descriptions are provided
- [ ] New features include translations
- [ ] Outdated keys are removed
- [ ] Translation tests are updated
- [ ] UI tested in all supported languages

## Troubleshooting

### Common Issues

**Translations not updating:**
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

**Missing translations:**
- Verify all ARB files have matching keys
- Check `l10n.yaml` configuration
- Ensure `generate: true` in `pubspec.yaml`

**Null safety errors:**
- Use `!` operator: `AppLocalizations.of(context)!`
- Or check for null: `AppLocalizations.of(context)?.appTitle ?? 'Default'`

## Resources

- [Flutter Internationalization Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [Intl Package Documentation](https://pub.dev/packages/intl)
- [ARB Format Specification](https://github.com/google/app-resource-bundle)
- [ISO 639-1 Language Codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)

## Implementation Status

### Completed Features
- [x] Added i18n dependencies (`flutter_localizations`, `intl`)
- [x] Created `l10n.yaml` configuration file
- [x] Created ARB translation files for English, Spanish, Portuguese, and Mandarin
- [x] Implemented `LanguageController` for dynamic language switching
- [x] Updated `main.dart` with localization delegates and supported locales
- [x] Added language selector in app bar (popup menu)
- [x] Updated existing pages to use localized strings
- [x] Created comprehensive unit tests for localizations
- [x] Created unit tests for `LanguageController`
- [x] Generated localization files successfully
- [x] All tests passing (13/13)

### Project Structure
```
lib/
├── core/
│   └── i18n/
│       └── language_controller.dart      ✓ Implemented
├── generated/
│   ├── app_localizations.dart            ✓ Generated
│   ├── app_localizations_en.dart         ✓ Generated
│   ├── app_localizations_es.dart         ✓ Generated
│   ├── app_localizations_pt.dart         ✓ Generated
│   └── app_localizations_zh.dart         ✓ Generated
├── l10n/
│   ├── app_en.arb                        ✓ Created
│   ├── app_es.arb                        ✓ Created
│   ├── app_pt.arb                        ✓ Created
│   └── app_zh.arb                        ✓ Created
└── main.dart                             ✓ Updated

test/
└── i18n/
    ├── localizations_test.dart           ✓ Created
    └── language_controller_test.dart     ✓ Created

l10n.yaml                                 ✓ Created
```

### How to Run Tests

```bash
# Run all internationalization tests
flutter test test/i18n/

# Run specific test file
flutter test test/i18n/localizations_test.dart
flutter test test/i18n/language_controller_test.dart

# Run with coverage
flutter test --coverage test/i18n/

# Run all project tests
flutter test
```

### How to Generate Localization Files

When you add new translations to ARB files, regenerate the localization code:

```bash
# Automatic generation (happens on flutter pub get)
flutter pub get

# Manual generation
flutter gen-l10n

# Or trigger via build
flutter build <platform>
```

### How to Use in Your App

1. **Access translations in widgets:**
```dart
import 'package:farms/generated/app_localizations.dart';

final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle);
```

2. **Change language dynamically:**
```dart
// Access the language controller from your widget
widget.languageController.changeLanguage('es'); // Spanish
widget.languageController.changeLanguage('pt'); // Portuguese
widget.languageController.changeLanguage('zh'); // Mandarin
widget.languageController.changeLanguage('en'); // English
```

3. **Add new translations:**
   - Add key to all ARB files (`app_en.arb`, `app_es.arb`, `app_pt.arb`, `app_zh.arb`)
   - Run `flutter pub get` to regenerate
   - Use `l10n.yourNewKey` in code

## Future Enhancements

- [ ] Add RTL (Right-to-Left) language support
- [ ] Implement lazy loading for translations
- [ ] Add translation management platform integration
- [ ] Support regional dialects (e.g., en_US vs en_GB)
- [ ] Implement context-aware translations
