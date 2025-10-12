/// Validation service with common validation rules and error message generation
///
/// This service provides centralized validation logic for the farm feature,
/// ensuring consistent validation across the application.
///
/// All validation methods return null if valid, or an error message string if invalid.
class ValidationService {
  ValidationService._(); // Private constructor to prevent instantiation

  // ============================================================================
  // STRING VALIDATIONS
  // ============================================================================

  /// Validates a farm name
  ///
  /// Rules:
  /// - Required (not null or empty)
  /// - Minimum 3 characters
  /// - Maximum 100 characters
  /// - No leading/trailing whitespace after trim
  static String? validateFarmName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Farm name is required';
    }

    final trimmed = name.trim();

    if (trimmed.length < 3) {
      return 'Farm name must be at least 3 characters';
    }

    if (trimmed.length > 100) {
      return 'Farm name must not exceed 100 characters';
    }

    return null;
  }

  /// Validates a farm description
  ///
  /// Rules:
  /// - Optional (can be null or empty)
  /// - Maximum 500 characters
  static String? validateFarmDescription(String? description) {
    if (description == null || description.isEmpty) {
      return null; // Optional field
    }

    if (description.length > 500) {
      return 'Description must not exceed 500 characters';
    }

    return null;
  }

  /// Validates a person/user name
  ///
  /// Rules:
  /// - Required
  /// - Minimum 2 characters
  /// - Maximum 100 characters
  static String? validatePersonName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }

    final trimmed = name.trim();

    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (trimmed.length > 100) {
      return 'Name must not exceed 100 characters';
    }

    return null;
  }

  /// Validates a cattle lot name
  ///
  /// Rules:
  /// - Required
  /// - Minimum 2 characters
  /// - Maximum 50 characters
  static String? validateLotName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Lot name is required';
    }

    final trimmed = name.trim();

    if (trimmed.length < 2) {
      return 'Lot name must be at least 2 characters';
    }

    if (trimmed.length > 50) {
      return 'Lot name must not exceed 50 characters';
    }

    return null;
  }

  /// Validates a general text field with custom rules
  ///
  /// Parameters:
  /// - [value]: The text to validate
  /// - [fieldName]: Name of the field for error messages
  /// - [required]: Whether the field is required
  /// - [minLength]: Minimum length (default: 1)
  /// - [maxLength]: Maximum length (optional)
  static String? validateText(
    String? value,
    String fieldName, {
    bool required = true,
    int minLength = 1,
    int? maxLength,
  }) {
    if (value == null || value.trim().isEmpty) {
      if (required) {
        return '$fieldName is required';
      }
      return null; // Optional field
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

  // ============================================================================
  // NUMBER VALIDATIONS
  // ============================================================================

  /// Validates farm capacity
  ///
  /// Rules:
  /// - Required
  /// - Must be greater than 0
  /// - Maximum 100,000 (reasonable farm size)
  static String? validateCapacity(int? capacity) {
    if (capacity == null) {
      return 'Capacity is required';
    }

    if (capacity <= 0) {
      return 'Capacity must be greater than 0';
    }

    if (capacity > 100000) {
      return 'Capacity seems unreasonably high (max: 100,000)';
    }

    return null;
  }

  /// Validates cattle quantity
  ///
  /// Rules:
  /// - Required
  /// - Must be greater than 0
  /// - Maximum 10,000 per lot
  static String? validateQuantity(int? quantity) {
    if (quantity == null) {
      return 'Quantity is required';
    }

    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }

    if (quantity > 10000) {
      return 'Quantity per lot cannot exceed 10,000';
    }

    return null;
  }

  /// Validates weight in kilograms
  ///
  /// Rules:
  /// - Required
  /// - Must be greater than 0
  /// - Maximum 2000 kg (reasonable for cattle)
  static String? validateWeight(double? weight) {
    if (weight == null) {
      return 'Weight is required';
    }

    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }

    if (weight > 2000) {
      return 'Weight seems unreasonably high (max: 2000 kg)';
    }

    return null;
  }

  /// Validates a monetary value
  ///
  /// Rules:
  /// - Required
  /// - Must be greater than or equal to 0
  /// - Maximum 1 billion (reasonable transaction limit)
  static String? validateMonetaryValue(double? value) {
    if (value == null) {
      return 'Value is required';
    }

    if (value < 0) {
      return 'Value cannot be negative';
    }

    if (value > 1000000000) {
      return 'Value exceeds maximum allowed (1 billion)';
    }

    return null;
  }

  /// Validates a number within a custom range
  ///
  /// Parameters:
  /// - [value]: The number to validate
  /// - [fieldName]: Name of the field for error messages
  /// - [min]: Minimum allowed value (optional)
  /// - [max]: Maximum allowed value (optional)
  /// - [required]: Whether the field is required
  static String? validateNumber(
    num? value,
    String fieldName, {
    num? min,
    num? max,
    bool required = true,
  }) {
    if (value == null) {
      if (required) {
        return '$fieldName is required';
      }
      return null;
    }

    if (min != null && value < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && value > max) {
      return '$fieldName must not exceed $max';
    }

    return null;
  }

  // ============================================================================
  // DATE VALIDATIONS
  // ============================================================================

  /// Validates that a date is not null and not in the future
  ///
  /// Common for historical records like transactions.
  static String? validatePastDate(DateTime? date, String fieldName) {
    if (date == null) {
      return '$fieldName is required';
    }

    final now = DateTime.now();
    if (date.isAfter(now)) {
      return '$fieldName cannot be in the future';
    }

    return null;
  }

  /// Validates that a date is not null and not in the past
  ///
  /// Common for goals and future events.
  static String? validateFutureDate(DateTime? date, String fieldName) {
    if (date == null) {
      return '$fieldName is required';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isBefore(today)) {
      return '$fieldName cannot be in the past';
    }

    return null;
  }

  /// Validates a date range (start must be before or equal to end)
  ///
  /// Parameters:
  /// - [startDate]: The start date
  /// - [endDate]: The end date
  /// - [startFieldName]: Name of start field for error messages
  /// - [endFieldName]: Name of end field for error messages
  /// - [allowEqual]: Whether start and end can be the same date (default: true)
  static String? validateDateRange(
    DateTime? startDate,
    DateTime? endDate,
    String startFieldName,
    String endFieldName, {
    bool allowEqual = true,
  }) {
    if (startDate == null) {
      return '$startFieldName is required';
    }

    if (endDate == null) {
      return '$endFieldName is required';
    }

    if (allowEqual) {
      if (startDate.isAfter(endDate)) {
        return '$startFieldName must be before or equal to $endFieldName';
      }
    } else {
      if (!startDate.isBefore(endDate)) {
        return '$startFieldName must be before $endFieldName';
      }
    }

    return null;
  }

  /// Validates birth date range for cattle lots
  ///
  /// Rules:
  /// - Both dates required
  /// - Start must be before end
  /// - Neither can be in the future
  /// - Range cannot exceed 5 years
  static String? validateBirthDateRange(
    DateTime? birthStart,
    DateTime? birthEnd,
  ) {
    final rangeError = validateDateRange(
      birthStart,
      birthEnd,
      'Birth start date',
      'Birth end date',
    );
    if (rangeError != null) return rangeError;

    // Check if either date is in the future
    final now = DateTime.now();
    if (birthStart!.isAfter(now)) {
      return 'Birth start date cannot be in the future';
    }
    if (birthEnd!.isAfter(now)) {
      return 'Birth end date cannot be in the future';
    }

    // Check if range is reasonable (max 5 years)
    final difference = birthEnd.difference(birthStart).inDays;
    if (difference > 1825) {
      // 5 years ≈ 1825 days
      return 'Birth date range cannot exceed 5 years';
    }

    return null;
  }

  /// Validates a goal date range
  ///
  /// Rules:
  /// - Both dates required
  /// - Definition date cannot be in the future
  /// - Goal date must be after definition date
  /// - Goal date must be in the future (or today)
  static String? validateGoalDates(
    DateTime? definitionDate,
    DateTime? goalDate,
  ) {
    if (definitionDate == null) {
      return 'Definition date is required';
    }

    if (goalDate == null) {
      return 'Goal date is required';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Definition date cannot be in the future
    if (definitionDate.isAfter(now)) {
      return 'Definition date cannot be in the future';
    }

    // Goal date must be after definition date
    if (!goalDate.isAfter(definitionDate)) {
      return 'Goal date must be after definition date';
    }

    // Goal date should be in the future or today
    final goalDateOnly = DateTime(goalDate.year, goalDate.month, goalDate.day);
    if (goalDateOnly.isBefore(today)) {
      return 'Goal date should not be in the past';
    }

    return null;
  }

  // ============================================================================
  // COMPLEX VALIDATIONS
  // ============================================================================

  /// Validates transaction data consistency
  ///
  /// Rules:
  /// - Quantity must be valid
  /// - For buy/sell: value is required
  /// - For move: related transaction ID is required
  /// - Weight should be positive if provided
  static String? validateTransaction({
    required int? quantity,
    required String transactionType,
    double? value,
    double? averageWeight,
    String? relatedTransactionId,
  }) {
    final quantityError = validateQuantity(quantity);
    if (quantityError != null) return quantityError;

    // Buy and Sell require value
    if (transactionType == 'buy' || transactionType == 'sell') {
      if (value == null || value <= 0) {
        return 'Value is required for ${transactionType} transactions';
      }
    }

    // Move requires related transaction ID
    if (transactionType == 'move') {
      if (relatedTransactionId == null || relatedTransactionId.isEmpty) {
        return 'Related transaction ID is required for move transactions';
      }
    }

    // Validate weight if provided
    if (averageWeight != null && averageWeight <= 0) {
      return 'Average weight must be greater than 0';
    }

    return null;
  }

  /// Validates goal progress
  ///
  /// Checks if the goal's birth quantity matches the expected progress
  /// based on lot history.
  static String? validateGoalProgress({
    required int birthQuantity,
    required int actualBirthQuantity,
  }) {
    if (birthQuantity < 0) {
      return 'Birth quantity cannot be negative';
    }

    if (actualBirthQuantity < 0) {
      return 'Actual birth quantity cannot be negative';
    }

    // Note: We don't enforce that actual matches expected,
    // as this is tracked but not an error condition

    return null;
  }

  /// Validates lot capacity against farm capacity
  ///
  /// Ensures that the total cattle across all lots doesn't exceed farm capacity.
  static String? validateLotAgainstFarmCapacity({
    required int lotQuantity,
    required int currentFarmTotal,
    required int farmCapacity,
    int? previousLotQuantity,
  }) {
    // Calculate what the new total would be
    final previousQuantity = previousLotQuantity ?? 0;
    final newTotal = currentFarmTotal - previousQuantity + lotQuantity;

    if (newTotal > farmCapacity) {
      final available = farmCapacity - (currentFarmTotal - previousQuantity);
      return 'Farm capacity exceeded. Available capacity: $available';
    }

    return null;
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Combines multiple validation results
  ///
  /// Returns null if all validations pass, or a combined error message
  /// if any validation fails.
  static String? combineValidations(List<String?> validationResults) {
    final errors = validationResults.where((e) => e != null).toList();
    if (errors.isEmpty) return null;
    return errors.join('; ');
  }

  /// Validates required field (not null)
  static String? validateRequired(dynamic value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates email format
  ///
  /// Basic email validation using regex.
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }

    return null;
  }

  /// Validates phone number format (Brazilian format)
  ///
  /// Accepts formats: (11) 91234-5678, 11912345678, etc.
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return null; // Optional field
    }

    // Remove common formatting characters
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Brazilian phone: 10-11 digits (DDD + number)
    if (cleaned.length < 10 || cleaned.length > 11) {
      return 'Phone number must have 10-11 digits';
    }

    return null;
  }
}
