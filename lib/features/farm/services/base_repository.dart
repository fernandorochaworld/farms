import 'package:cloud_firestore/cloud_firestore.dart';

/// Base repository abstract class with common error handling and utilities
///
/// This class provides shared functionality for all farm repositories including:
/// - Firestore error handling
/// - Timestamp conversion utilities
/// - Common validation patterns
/// - Standardized error messages
///
/// All farm repositories should extend this class to maintain consistency
/// across the application and reduce code duplication.
abstract class BaseRepository {
  /// The Firestore instance used by this repository
  final FirebaseFirestore firestore;

  BaseRepository({required this.firestore});

  /// Handles Firestore-specific errors and converts them to user-friendly messages
  ///
  /// Standardizes error handling across all repositories. Common Firestore
  /// errors are converted to clear, actionable messages for users.
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   await firestore.collection('farms').doc(id).set(data);
  /// } catch (e) {
  ///   throw handleFirestoreError(e, 'creating farm');
  /// }
  /// ```
  Exception handleFirestoreError(dynamic error, String operation) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return Exception(
            'Permission denied when $operation. Please check your access rights.',
          );
        case 'not-found':
          return Exception(
            'Resource not found when $operation. It may have been deleted.',
          );
        case 'already-exists':
          return Exception(
            'Resource already exists. Cannot complete $operation.',
          );
        case 'unavailable':
          return Exception(
            'Service temporarily unavailable when $operation. Please try again.',
          );
        case 'deadline-exceeded':
          return Exception(
            'Operation timed out when $operation. Please check your connection.',
          );
        case 'resource-exhausted':
          return Exception(
            'Too many requests. Please wait a moment before $operation.',
          );
        case 'cancelled':
          return Exception('Operation was cancelled when $operation.');
        case 'data-loss':
          return Exception(
            'Data may have been lost when $operation. Please verify your data.',
          );
        case 'unauthenticated':
          return Exception(
            'Authentication required for $operation. Please sign in again.',
          );
        case 'invalid-argument':
          return Exception(
            'Invalid data provided when $operation. Please check your input.',
          );
        case 'out-of-range':
          return Exception(
            'Value out of acceptable range when $operation.',
          );
        default:
          return Exception(
            'Error when $operation: ${error.message ?? error.code}',
          );
      }
    }

    // Handle non-Firebase exceptions
    return Exception(
      'Unexpected error when $operation: ${error.toString()}',
    );
  }

  /// Converts a DateTime to Firestore Timestamp
  ///
  /// Safely handles null values and ensures consistent timestamp formatting
  /// across all Firestore operations.
  ///
  /// Returns null if the input dateTime is null.
  Timestamp? toTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return Timestamp.fromDate(dateTime);
  }

  /// Converts a Firestore Timestamp to DateTime
  ///
  /// Safely handles null values and missing timestamp fields in Firestore
  /// documents.
  ///
  /// Returns null if the input timestamp is null.
  DateTime? fromTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return null;
    return timestamp.toDate();
  }

  /// Converts a Firestore Timestamp to DateTime with a default fallback
  ///
  /// Useful when a timestamp is expected but might be missing, and you
  /// want to provide a sensible default (like current time).
  ///
  /// Example:
  /// ```dart
  /// final createdAt = fromTimestampOrDefault(
  ///   data['created_at'] as Timestamp?,
  ///   DateTime.now(),
  /// );
  /// ```
  DateTime fromTimestampOrDefault(Timestamp? timestamp, DateTime defaultValue) {
    if (timestamp == null) return defaultValue;
    return timestamp.toDate();
  }

  /// Converts a DateTime to Firestore Timestamp with current time as default
  ///
  /// Useful when you want to ensure a timestamp is always set, using
  /// current time if no specific time is provided.
  Timestamp toTimestampOrNow(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now());
  }

  /// Validates that a string is not empty and meets minimum length requirements
  ///
  /// Returns null if valid, error message if invalid.
  ///
  /// Parameters:
  /// - [value]: The string to validate
  /// - [fieldName]: Name of the field for error messages
  /// - [minLength]: Minimum required length (default: 1)
  /// - [maxLength]: Maximum allowed length (optional)
  String? validateString(
    String? value,
    String fieldName, {
    int minLength = 1,
    int? maxLength,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final trimmed = value.trim();

    if (trimmed.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (maxLength != null && trimmed.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    return null;
  }

  /// Validates that a number is within acceptable range
  ///
  /// Returns null if valid, error message if invalid.
  ///
  /// Parameters:
  /// - [value]: The number to validate
  /// - [fieldName]: Name of the field for error messages
  /// - [min]: Minimum allowed value (optional)
  /// - [max]: Maximum allowed value (optional)
  String? validateNumber(
    num? value,
    String fieldName, {
    num? min,
    num? max,
  }) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (min != null && value < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && value > max) {
      return '$fieldName must not exceed $max';
    }

    return null;
  }

  /// Validates that a date is within acceptable range
  ///
  /// Returns null if valid, error message if invalid.
  ///
  /// Parameters:
  /// - [value]: The date to validate
  /// - [fieldName]: Name of the field for error messages
  /// - [minDate]: Minimum allowed date (optional)
  /// - [maxDate]: Maximum allowed date (optional)
  String? validateDate(
    DateTime? value,
    String fieldName, {
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (minDate != null && value.isBefore(minDate)) {
      return '$fieldName cannot be before ${_formatDate(minDate)}';
    }

    if (maxDate != null && value.isAfter(maxDate)) {
      return '$fieldName cannot be after ${_formatDate(maxDate)}';
    }

    return null;
  }

  /// Validates that a date range is valid (start before end)
  ///
  /// Returns null if valid, error message if invalid.
  String? validateDateRange(
    DateTime? startDate,
    DateTime? endDate,
    String startFieldName,
    String endFieldName,
  ) {
    if (startDate == null) {
      return '$startFieldName is required';
    }

    if (endDate == null) {
      return '$endFieldName is required';
    }

    if (startDate.isAfter(endDate)) {
      return '$startFieldName must be before $endFieldName';
    }

    return null;
  }

  /// Formats a date for display in error messages
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Validates that a value is not null
  ///
  /// Returns null if valid, error message if invalid.
  String? validateRequired(dynamic value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Combines multiple validation results into a single error message
  ///
  /// Returns null if all validations pass, or a combined error message
  /// if any validation fails.
  ///
  /// Example:
  /// ```dart
  /// final error = combineValidations([
  ///   validateString(name, 'Name', minLength: 3),
  ///   validateNumber(capacity, 'Capacity', min: 1),
  ///   validateDate(startDate, 'Start Date'),
  /// ]);
  /// if (error != null) throw Exception(error);
  /// ```
  String? combineValidations(List<String?> validationResults) {
    final errors = validationResults.where((e) => e != null).toList();
    if (errors.isEmpty) return null;
    return errors.join('; ');
  }

  /// Safely extracts a field from a map with type checking
  ///
  /// Returns null if field doesn't exist or is null.
  /// Throws if field exists but has wrong type.
  T? getField<T>(Map<String, dynamic> data, String fieldName) {
    final value = data[fieldName];
    if (value == null) return null;
    if (value is! T) {
      throw Exception(
        'Field $fieldName has wrong type. Expected $T but got ${value.runtimeType}',
      );
    }
    return value;
  }

  /// Safely extracts a required field from a map with type checking
  ///
  /// Throws if field doesn't exist, is null, or has wrong type.
  T getRequiredField<T>(Map<String, dynamic> data, String fieldName) {
    final value = getField<T>(data, fieldName);
    if (value == null) {
      throw Exception('Required field $fieldName is missing or null');
    }
    return value;
  }
}
