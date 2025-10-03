/// Utility class for converting authentication errors to user-friendly messages
class AuthErrorMessages {
  /// Converts an error object to a user-friendly error message
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('user not found')) {
      return 'Invalid email, username, or password';
    } else if (errorString.contains('wrong password') ||
        errorString.contains('invalid password')) {
      return 'Invalid email, username, or password';
    } else if (errorString.contains('username not found')) {
      return 'Invalid email, username, or password';
    } else if (errorString.contains('email already in use')) {
      return 'An account already exists with this email';
    } else if (errorString.contains('username already taken')) {
      return 'This username is already taken';
    } else if (errorString.contains('weak password')) {
      return 'Password must be at least 8 characters with uppercase, lowercase, and numbers';
    } else if (errorString.contains('invalid email')) {
      return 'Please enter a valid email address';
    } else if (errorString.contains('network')) {
      return 'Network error. Please check your connection';
    } else if (errorString.contains('too many requests') ||
        errorString.contains('too many attempts')) {
      return 'Too many attempts. Please try again later';
    } else if (errorString.contains('cancelled')) {
      return ''; // Don't show error for user cancellation
    } else if (errorString.contains('user-disabled') ||
        errorString.contains('account has been disabled')) {
      return 'This account has been disabled';
    } else if (errorString.contains('operation-not-allowed')) {
      return 'Operation not allowed. Please contact support';
    } else {
      return 'An error occurred. Please try again';
    }
  }
}
