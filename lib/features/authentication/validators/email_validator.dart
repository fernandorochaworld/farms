import 'package:formz/formz.dart';

/// Validation errors for Email input
enum EmailValidationError {
  /// Email field is empty
  empty,

  /// Email format is invalid
  invalid,
}

/// Form input for an email field
class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!_emailRegex.hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }

  /// Get error message for the current validation error
  String? get errorMessage {
    if (isPure || isValid) return null;

    switch (error) {
      case EmailValidationError.empty:
        return 'Email is required';
      case EmailValidationError.invalid:
        return 'Please enter a valid email address';
      default:
        return null;
    }
  }
}
