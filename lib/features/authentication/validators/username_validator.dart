import 'package:formz/formz.dart';

/// Validation errors for Username input
enum UsernameValidationError {
  /// Username field is empty
  empty,

  /// Username is too short (less than 3 characters)
  tooShort,

  /// Username contains invalid characters
  invalid,
}

/// Form input for a username field
class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) {
      return UsernameValidationError.empty;
    } else if (value.length < 3) {
      return UsernameValidationError.tooShort;
    } else if (!_usernameRegex.hasMatch(value)) {
      return UsernameValidationError.invalid;
    }
    return null;
  }

  /// Get error message for the current validation error
  String? get errorMessage {
    if (isPure || isValid) return null;

    switch (error) {
      case UsernameValidationError.empty:
        return 'Username is required';
      case UsernameValidationError.tooShort:
        return 'Username must be at least 3 characters';
      case UsernameValidationError.invalid:
        return 'Username can only contain letters, numbers, and underscores';
      default:
        return null;
    }
  }
}
