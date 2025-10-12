# Flutter Development Guide

## Project Overview
- **Name**: Farms
- **Version**: 1.0.0+1
- **SDK**: Dart ^3.9.2
- **Framework**: Flutter (latest stable)

## Key Technologies

### Flutter Packages
- **flutter_bloc** (^9.1.1) - State management using BLoC pattern
- **bloc** (^9.0.1) - Core BLoC library
- **formz** (^0.8.0) - Form validation
- **equatable** (^2.0.5) - Value equality
- **cupertino_icons** (^1.0.8) - iOS style icons

### Internationalization
- **flutter_localizations** - Built-in Flutter localization
- **intl** - Internationalization and date formatting
- **Supported Locales**: English (en), Spanish (es), Portuguese (pt), Chinese (zh)
- **l10n Generation**: Enabled via `flutter: generate: true` in pubspec.yaml

### Storage & Dependency Injection
- **get_it** (^8.2.0) - Service locator for dependency injection
- **flutter_secure_storage** (^10.0.0-beta.4) - Secure token storage

### Testing
- **flutter_test** - Built-in testing framework
- **mockito** (^5.4.4) - Mocking for tests
- **build_runner** (^2.4.7) - Code generation
- **bloc_test** (^10.0.0) - Testing for BLoC

## Architecture

### Project Structure
```
lib/
├── core/
│   ├── di/                    # Dependency injection setup
│   └── i18n/                  # Internationalization
├── features/
│   └── authentication/
│       ├── bloc/              # BLoC (Business Logic Component)
│       ├── models/            # Data models
│       ├── repositories/      # Data layer
│       ├── screens/           # UI screens
│       ├── services/          # SSO services (Google, Facebook)
│       ├── utils/             # Error handling utilities
│       ├── validators/        # Form validators (formz)
│       └── widgets/           # Reusable widgets
├── screens/                   # Shared screens
├── shared/
│   └── services/              # Shared services
├── generated/                 # Auto-generated i18n files
└── main.dart                  # App entry point
```

### State Management Pattern
**BLoC (Business Logic Component)** is used for state management:
- **Events**: User actions (AuthEvent)
- **States**: UI states (AuthState)
- **BLoC**: Business logic (AuthBloc)
- **Repository**: Data access layer (UserRepository)

Example flow:
```
UI → Event → BLoC → Repository → BLoC → State → UI
```

### Dependency Injection
Using **GetIt** service locator pattern:
- All dependencies registered in `core/di/injection.dart`
- Call `setupDependencies()` in `main()`
- Access via `getIt<ServiceType>()`

Example:
```dart
// Register
getIt.registerLazySingleton<UserRepository>(() => FirebaseUserRepository());

// Use
final repo = getIt<UserRepository>();
```

### Form Validation
Using **formz** package for type-safe form validation:
- Custom validators in `features/authentication/validators/`
- Examples: EmailValidator, PasswordValidator, UsernameValidator, NameValidator
- Provides pure, testable validation logic

## Development Commands

See `makefiles/flutter.mk` for all available commands:

```bash
make install       # Install dependencies
make setup         # Setup project
make run           # Run app
make run-windows   # Run on Windows
make test          # Run tests
make build         # Build APK
make clean         # Clean build artifacts
```

## Best Practices

1. **State Management**: Use BLoC for all business logic
2. **Dependency Injection**: Register all services in `injection.dart`
3. **Validation**: Use formz validators for forms
4. **Localization**: Add strings to `.arb` files, run `flutter gen-l10n`
5. **Testing**: Write unit tests for BLoCs and repositories
6. **Code Style**: Follow flutter_lints recommendations

## Common Tasks

### Adding a new feature
1. Create feature folder under `lib/features/`
2. Implement BLoC (events, states, bloc)
3. Create repository interface and implementation
4. Build UI screens and widgets
5. Register dependencies in `injection.dart`
6. Write tests

### Adding translations
1. Edit `lib/l10n/app_en.arb` (and other locale files)
2. Run `flutter gen-l10n` or restart app
3. Use `AppLocalizations.of(context)!.stringKey`

### Adding dependencies
1. Add to `pubspec.yaml`
2. Run `flutter pub get` or `make install`
3. If needed, register in `injection.dart`

## Resources
- Flutter Docs: https://docs.flutter.dev/
- BLoC Library: https://bloclibrary.dev/
- GetIt: https://pub.dev/packages/get_it
- Formz: https://pub.dev/packages/formz
