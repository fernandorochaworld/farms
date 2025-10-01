import 'package:formz/formz.dart';

/// Validation errors for Password input
enum PasswordValidationError {
  /// Password field is empty
  empty,

  /// Password is too short (less than 8 characters)
  tooShort,

  /// Password doesn't meet strength requirements
  weak,
}

/// Form input for a password field
class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.tooShort;
    } else if (!_isStrongPassword(value)) {
      return PasswordValidationError.weak;
    }
    return null;
  }

  /// Checks if password meets strength requirements
  /// Must contain: uppercase, lowercase, and number
  bool _isStrongPassword(String value) {
    return value.contains(RegExp(r'[A-Z]')) &&
        value.contains(RegExp(r'[a-z]')) &&
        value.contains(RegExp(r'[0-9]'));
  }

  /// Get error message for the current validation error
  String? get errorMessage {
    if (isPure || isValid) return null;

    switch (error) {
      case PasswordValidationError.empty:
        return 'Password is required';
      case PasswordValidationError.tooShort:
        return 'Password must be at least 8 characters';
      case PasswordValidationError.weak:
        return 'Password must contain uppercase, lowercase, and number';
      default:
        return null;
    }
  }
}
