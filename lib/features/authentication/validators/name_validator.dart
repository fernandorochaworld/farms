import 'package:formz/formz.dart';

/// Validation errors for Name input
enum NameValidationError {
  /// Name field is empty
  empty,

  /// Name is too short
  tooShort,
}

/// Form input for a name field
class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return NameValidationError.empty;
    } else if (trimmed.length < 2) {
      return NameValidationError.tooShort;
    }
    return null;
  }

  /// Get error message for the current validation error
  String? get errorMessage {
    if (isPure || isValid) return null;

    switch (error) {
      case NameValidationError.empty:
        return 'Name is required';
      case NameValidationError.tooShort:
        return 'Name must be at least 2 characters';
      default:
        return null;
    }
  }
}
