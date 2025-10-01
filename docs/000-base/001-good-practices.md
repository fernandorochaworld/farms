# Flutter/Dart Best Practices

## Project Structure

### Feature-First Organization
- Group all feature files in a single folder (UI, logic, widgets)
- Only share truly reusable code (models, services, utilities)
- Each feature contains: `screens/`, `widgets/`, `controllers/` or `blocs/`

```
lib/
├── features/
│   ├── authentication/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── controllers/
│   ├── profile/
│   └── dashboard/
├── shared/
│   ├── models/
│   ├── services/
│   ├── widgets/
│   └── utils/
└── core/
    ├── config/
    ├── constants/
    └── theme/
```

## Clean Code Principles

### Naming Conventions
- Use clear, descriptive names
- Classes: `PascalCase` (e.g., `UserProfile`)
- Files: `snake_case` (e.g., `user_profile.dart`)
- Variables/functions: `camelCase` (e.g., `getUserData`)
- Constants: `lowerCamelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants

### Code Organization
- One class per file (exceptions: small helper classes)
- Keep functions small and focused (single responsibility)
- Maximum 200-300 lines per file
- Extract complex widgets into separate files
- Use meaningful comments only where necessary

### DRY Principle
- Avoid code duplication
- Extract reusable widgets
- Create utility functions for common operations
- Use mixins for shared behavior

## Architecture Patterns

### State Management
- Choose one: BLoC, Provider, Riverpod, or GetX
- Keep business logic separate from UI
- Use immutable state objects
- Handle loading, success, and error states explicitly

### Separation of Concerns
- **Presentation Layer**: Widgets and screens
- **Business Logic Layer**: Controllers, BLoCs, or ViewModels
- **Data Layer**: Repositories and data sources
- **Services**: Firebase, API clients, local storage

### Dependency Injection
- Use `get_it` or `provider` for DI
- Register dependencies at app startup
- Avoid tight coupling between layers

## Firebase Integration

### Authentication Best Practices
- Store tokens securely (never in plain text)
- Implement proper error handling for auth failures
- Use Firebase Auth state listeners
- Handle token refresh automatically
- Implement sign-out functionality properly

### Google & Facebook Sign-In
- Check platform availability (iOS/Android/Web)
- Handle cancellation gracefully
- Verify credentials server-side when needed
- Request minimal necessary permissions
- Provide fallback authentication methods

### Firestore
- Use typed models with `fromJson`/`toJson`
- Implement proper indexes for queries
- Use batch writes for multiple operations
- Handle offline persistence
- Validate data before writing

### Security
- Never commit API keys or sensitive data
- Use environment variables for configuration
- Implement Firebase Security Rules
- Validate user input on both client and server
- Use HTTPS for all network requests

## Code Quality

### Error Handling
- Use try-catch blocks appropriately
- Show user-friendly error messages
- Log errors for debugging
- Handle network failures gracefully
- Provide retry mechanisms

### Null Safety
- Enable null safety in `pubspec.yaml`
- Use `late` keyword sparingly
- Prefer `??` and `?.` operators
- Avoid `!` operator when possible

### Testing
- Write unit tests for business logic
- Create widget tests for UI components
- Test authentication flows
- Mock Firebase services in tests
- Aim for >70% code coverage

### Performance
- Use `const` constructors where possible
- Avoid rebuilding widgets unnecessarily
- Optimize images and assets
- Implement pagination for large lists
- Use `ListView.builder` for dynamic lists
- Profile app regularly with DevTools

## Version Control

### Git Practices
- Write meaningful commit messages
- Use feature branches
- Keep commits small and focused
- Never commit sensitive data
- Use `.gitignore` for generated files

### Code Review
- Review before merging
- Check for code duplication
- Verify error handling
- Ensure tests pass

## Documentation

### Code Documentation
- Document complex logic
- Add doc comments to public APIs
- Keep README updated
- Document environment setup
- Maintain changelog

### Inline Comments
- Explain "why", not "what"
- Remove commented-out code
- Keep comments concise
- Update comments when code changes

## Formatting & Linting

### Tools
- Run `dart format` before commits
- Configure `analysis_options.yaml`
- Use Flutter lints package
- Enable all recommended rules
- Fix warnings and hints

### Consistency
- Follow Flutter style guide
- Use consistent file organization
- Maintain consistent naming
- Keep formatting automated
