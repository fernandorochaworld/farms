# Testing Guide

## Running Tests

### All Tests
```bash
flutter test
```

### Internationalization Tests Only
```bash
flutter test test/i18n/
```

### Specific Test Files
```bash
# Test localizations
flutter test test/i18n/localizations_test.dart

# Test language controller
flutter test test/i18n/language_controller_test.dart
```

### With Coverage
```bash
flutter test --coverage
```

### Watch Mode (runs tests on file changes)
```bash
flutter test --watch
```

## Test Results

Current test status: **All tests passing** ✓

- Localizations Tests: 7/7 passing
- Language Controller Tests: 6/6 passing
- **Total: 13/13 tests passing**

## Test Coverage

### Localizations (`test/i18n/localizations_test.dart`)
- ✓ English translations load correctly
- ✓ Spanish translations load correctly
- ✓ Portuguese translations load correctly
- ✓ Mandarin translations load correctly
- ✓ Placeholder interpolation works correctly
- ✓ Plural forms work correctly (English)
- ✓ Plural forms work correctly (Spanish)

### Language Controller (`test/i18n/language_controller_test.dart`)
- ✓ Default locale is English
- ✓ Change language updates locale
- ✓ Change language notifies listeners
- ✓ Supported language codes are correct
- ✓ `isSupported` returns true for supported languages
- ✓ `isSupported` returns false for unsupported languages

## Adding New Tests

When adding new translation keys or features:

1. Add test cases to `test/i18n/localizations_test.dart`
2. Ensure all locales are tested
3. Run tests to verify
4. Update this document with new test count
