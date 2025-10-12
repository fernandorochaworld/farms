# Architecture Documentation

## Overview
This project follows **Clean Architecture** principles with **BLoC pattern** for state management.

## Architecture Layers

### 1. Presentation Layer (UI)
**Location**: `lib/features/*/screens/`, `lib/features/*/widgets/`

**Responsibilities**:
- Display UI
- Handle user interactions
- Trigger BLoC events
- React to BLoC states

**Key Components**:
- Screens (full pages)
- Widgets (reusable components)
- No business logic allowed

**Example**:
```dart
// Screen triggers event
BlocProvider.of<AuthBloc>(context).add(
  AuthLoginRequested(email: email, password: password),
);

// Screen listens to state
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return LoadingWidget();
    if (state is AuthAuthenticated) return HomeScreen();
    return LoginScreen();
  },
)
```

### 2. Business Logic Layer (BLoC)
**Location**: `lib/features/*/bloc/`

**Responsibilities**:
- Process business logic
- Handle events from UI
- Emit states to UI
- Coordinate with repositories

**Components**:
- **Events**: User actions (`*_event.dart`)
- **States**: UI states (`*_state.dart`)
- **BLoC**: Logic processor (`*_bloc.dart`)

**Example**:
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
```

### 3. Data Layer (Repository)
**Location**: `lib/features/*/repositories/`

**Responsibilities**:
- Abstract data sources
- Provide clean API to BLoC
- Handle data operations
- Manage external services

**Pattern**:
- Abstract repository interface
- Concrete implementation(s)
- Injected via GetIt

**Example**:
```dart
// Abstract interface
abstract class UserRepository {
  Future<Person> signInWithEmailAndPassword(String email, String password);
  Future<Person> getCurrentUser();
  Stream<Person?> authStateChanges();
}

// Concrete implementation
class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseUserRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth, _firestore = firestore;

  @override
  Future<Person> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _getPersonFromFirestore(credential.user!.uid);
  }
}
```

### 4. Models/Entities
**Location**: `lib/features/*/models/`

**Responsibilities**:
- Define data structures
- Serialize/deserialize
- Value equality (using Equatable)

**Example**:
```dart
class Person extends Equatable {
  final String id;
  final String name;
  final String email;
  final String username;

  const Person({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
  });

  @override
  List<Object?> get props => [id, name, email, username];
}
```

### 5. Services
**Location**: `lib/features/*/services/`, `lib/shared/services/`

**Responsibilities**:
- External service integration
- Third-party API wrappers
- Platform-specific code

**Examples**:
- `GoogleAuthService` - Google Sign-In
- `FacebookAuthService` - Facebook Auth
- `TokenStorageService` - Secure storage

### 6. Validators
**Location**: `lib/features/*/validators/`

**Responsibilities**:
- Input validation
- Type-safe validation using formz
- Reusable validation logic

**Example**:
```dart
enum EmailValidationError { invalid, empty }

class EmailValidator extends FormzInput<String, EmailValidationError> {
  const EmailValidator.pure() : super.pure('');
  const EmailValidator.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_isValidEmail(value)) return EmailValidationError.invalid;
    return null;
  }
}
```

## Dependency Flow

```
UI (Presentation)
    ↓ events
BLoC (Business Logic)
    ↓ method calls
Repository (Data)
    ↓ API calls
External Services (Firebase, etc.)
```

State flow (reverse):
```
External Services
    ↓ data
Repository
    ↓ models
BLoC
    ↓ states
UI
```

## Dependency Injection

Using **GetIt** service locator pattern.

### Setup Location
`lib/core/di/injection.dart`

### Registration
```dart
void setupDependencies() {
  // Singletons
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());

  // Factories (new instance each time)
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
    userRepository: getIt<UserRepository>(),
  ));
}
```

### Usage
```dart
// In main.dart
setupDependencies();

// In widgets
final userRepo = getIt<UserRepository>();

// In BLoC providers
BlocProvider(
  create: (context) => AuthBloc(
    userRepository: getIt<UserRepository>(),
  ),
)
```

## Feature Structure

Each feature follows this structure:
```
features/
└── feature_name/
    ├── bloc/
    │   ├── feature_bloc.dart
    │   ├── feature_event.dart
    │   └── feature_state.dart
    ├── models/
    │   └── feature_model.dart
    ├── repositories/
    │   ├── feature_repository.dart (interface)
    │   └── impl_feature_repository.dart (implementation)
    ├── screens/
    │   └── feature_screen.dart
    ├── services/ (optional)
    │   └── feature_service.dart
    ├── validators/ (optional)
    │   └── field_validator.dart
    ├── widgets/
    │   └── feature_widget.dart
    └── utils/ (optional)
        └── feature_utils.dart
```

## Current Features

### Authentication Feature
**Location**: `lib/features/authentication/`

**Capabilities**:
- Email/password authentication
- Username/password authentication (with username lookup)
- Google Sign-In (SSO)
- Facebook Sign-In (SSO)
- SSO profile completion flow
- Password reset
- User registration

**Components**:
- `AuthBloc` - Manages auth state
- `UserRepository` - Data access
- `FirebaseUserRepository` - Firebase implementation
- `GoogleAuthService` - Google SSO
- `FacebookAuthService` - Facebook SSO
- `Person` model - User entity
- Validators: Email, Password, Username, Name
- Screens: Login, SignUp, ForgotPassword, SSOProfileCompletion

## Core Components

### Internationalization (i18n)
**Location**: `lib/core/i18n/`

**Setup**:
- `LanguageController` - Manages locale changes
- `.arb` files in `lib/l10n/`
- Generated files in `lib/generated/`

**Supported Locales**:
- English (en)
- Spanish (es)
- Portuguese (pt)
- Chinese (zh)

**Usage**:
```dart
AppLocalizations.of(context)!.loginTitle
```

### Shared Services
**Location**: `lib/shared/services/`

**Current Services**:
- `TokenStorageService` - Secure token storage using flutter_secure_storage

## Navigation

### Current Approach
Using `MaterialApp` with conditional routing via `AuthGate`.

**AuthGate Logic**:
```dart
if (AuthLoading || AuthInitial) → Loading Screen
else if (AuthAuthenticated) → Home Screen
else if (AuthSSOProfileCompletionRequired) → Profile Completion
else → Login Screen
```

### Future Considerations
For complex navigation, consider:
- `go_router` package
- Named routes
- Deep linking support

## State Management Best Practices

### 1. Separation of Concerns
- UI only dispatches events and displays states
- BLoC handles all business logic
- Repository handles all data operations

### 2. Immutability
- All states and events are immutable (using const)
- Use Equatable for value equality

### 3. Single Responsibility
- Each BLoC handles one feature/domain
- Each event represents one user action
- Each state represents one UI state

### 4. Error Handling
- Catch exceptions in BLoC
- Emit failure states with user-friendly messages
- Use utility classes for error message mapping

### 5. Testing
- BLoCs are easily testable
- Mock repositories for unit tests
- Use bloc_test package

## Testing Strategy

### Unit Tests
- Test BLoCs with bloc_test
- Test repositories with mocked services
- Test validators independently
- Test models (serialization, equality)

### Widget Tests
- Test UI components
- Test BLoC integration
- Mock BLoCs with MockBloc

### Integration Tests
- Test complete flows
- Test with real repositories (test environment)

## Performance Considerations

### BLoC
- Use `transformEvents` for debouncing/throttling
- Cancel subscriptions in `close()`
- Use `emit.isDone` checks for long operations

### UI
- Use `const` constructors
- Avoid rebuilding entire trees
- Use `BlocBuilder` with `buildWhen` for selective rebuilds

### Data
- Implement caching in repositories
- Use Firestore offline persistence
- Lazy load data when possible

## Security Best Practices

1. **Never store sensitive data in code**
2. **Use environment variables for API keys**
3. **Validate all inputs** (use formz validators)
4. **Use Firebase Security Rules**
5. **Implement rate limiting** (via Firebase)
6. **Use secure storage** for tokens
7. **Handle auth state changes** properly
8. **Sign out on token expiration**

## Common Patterns

### Loading States
```dart
if (state is Loading) {
  return CircularProgressIndicator();
}
```

### Error Display
```dart
if (state is Failure) {
  return ErrorWidget(message: state.message);
}
```

### Form Submission
```dart
onPressed: () {
  if (formKey.currentState!.validate()) {
    context.read<Bloc>().add(SubmitEvent());
  }
}
```

## Resources
- Clean Architecture: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- BLoC Pattern: https://bloclibrary.dev/architecture/
- Flutter Architecture: https://docs.flutter.dev/app-architecture
