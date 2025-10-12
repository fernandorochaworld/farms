/// Enums for Farm Management System - Feature 004
///
/// This file contains all enum definitions used across the farm feature.
/// Following Flutter/Dart naming conventions and best practices.

/// Person types with different permission levels
/// - owner: Full control over farm and all operations
/// - manager: Manage operations, lots, and transactions
/// - worker: Add transactions and basic lot operations
/// - arrendatario: Limited access - view and add transactions only
enum PersonType {
  owner,
  manager,
  worker,
  arrendatario,
}

/// Extension to add display labels for PersonType
extension PersonTypeExtension on PersonType {
  String get label {
    switch (this) {
      case PersonType.owner:
        return 'Owner';
      case PersonType.manager:
        return 'Manager';
      case PersonType.worker:
        return 'Worker';
      case PersonType.arrendatario:
        return 'Arrendatario';
    }
  }

  String toJson() => name;

  static PersonType fromJson(String json) {
    return PersonType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => PersonType.worker,
    );
  }
}

/// Cattle types based on age classification
/// - bezerro: até 1 ano (up to 1 year)
/// - novilho: até 2 anos (up to 2 years)
/// - boi3anos: até 3 anos (up to 3 years)
/// - boi4anos: até 4 anos (up to 4 years)
/// - boi5maisAnos: 5 anos ou mais (5 years or more)
enum CattleType {
  bezerro,
  novilho,
  boi3anos,
  boi4anos,
  boi5maisAnos,
}

/// Extension to add display labels and descriptions for CattleType
extension CattleTypeExtension on CattleType {
  String get label {
    switch (this) {
      case CattleType.bezerro:
        return 'Bezerro';
      case CattleType.novilho:
        return 'Novilho';
      case CattleType.boi3anos:
        return 'Boi 3 anos';
      case CattleType.boi4anos:
        return 'Boi 4 anos';
      case CattleType.boi5maisAnos:
        return 'Boi 5+ anos';
    }
  }

  String get description {
    switch (this) {
      case CattleType.bezerro:
        return 'Até 1 ano de idade';
      case CattleType.novilho:
        return 'Até 2 anos de idade';
      case CattleType.boi3anos:
        return 'Até 3 anos de idade';
      case CattleType.boi4anos:
        return 'Até 4 anos de idade';
      case CattleType.boi5maisAnos:
        return '5 anos ou mais';
    }
  }

  int get maxAgeInMonths {
    switch (this) {
      case CattleType.bezerro:
        return 12;
      case CattleType.novilho:
        return 24;
      case CattleType.boi3anos:
        return 36;
      case CattleType.boi4anos:
        return 48;
      case CattleType.boi5maisAnos:
        return 999; // No upper limit
    }
  }

  String toJson() => name;

  static CattleType fromJson(String json) {
    return CattleType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => CattleType.bezerro,
    );
  }
}

/// Cattle gender classification
/// - male: Male cattle
/// - female: Female cattle
/// - mixed: Mixed gender lot
enum CattleGender {
  male,
  female,
  mixed,
}

/// Extension to add display labels for CattleGender
extension CattleGenderExtension on CattleGender {
  String get label {
    switch (this) {
      case CattleGender.male:
        return 'Male';
      case CattleGender.female:
        return 'Female';
      case CattleGender.mixed:
        return 'Mixed';
    }
  }

  String get symbol {
    switch (this) {
      case CattleGender.male:
        return '♂';
      case CattleGender.female:
        return '♀';
      case CattleGender.mixed:
        return '⚥';
    }
  }

  String toJson() => name;

  static CattleGender fromJson(String json) {
    return CattleGender.values.firstWhere(
      (type) => type.name == json,
      orElse: () => CattleGender.mixed,
    );
  }
}

/// Transaction types for cattle movement and operations
/// - buy: Purchase cattle and add to a lot
/// - sell: Sell cattle and remove from a lot
/// - move: Transfer cattle between lots (within same farm)
/// - die: Record cattle mortality
enum TransactionType {
  buy,
  sell,
  move,
  die,
}

/// Extension to add display labels and properties for TransactionType
extension TransactionTypeExtension on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.buy:
        return 'Buy';
      case TransactionType.sell:
        return 'Sell';
      case TransactionType.move:
        return 'Move';
      case TransactionType.die:
        return 'Die';
    }
  }

  String get description {
    switch (this) {
      case TransactionType.buy:
        return 'Purchase new cattle';
      case TransactionType.sell:
        return 'Sell cattle';
      case TransactionType.move:
        return 'Transfer between lots';
      case TransactionType.die:
        return 'Record mortality';
    }
  }

  /// Returns true if this transaction type increases lot quantity
  bool get addsQuantity {
    return this == TransactionType.buy;
  }

  /// Returns true if this transaction type decreases lot quantity
  bool get removesQuantity {
    return this == TransactionType.sell || this == TransactionType.die;
  }

  String toJson() => name;

  static TransactionType fromJson(String json) {
    return TransactionType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => TransactionType.buy,
    );
  }
}

/// Goal status tracking
/// - active: Goal in progress
/// - completed: Goal achieved
/// - overdue: Past deadline without completion
/// - cancelled: Manually cancelled
enum GoalStatus {
  active,
  completed,
  overdue,
  cancelled,
}

/// Extension to add display labels for GoalStatus
extension GoalStatusExtension on GoalStatus {
  String get label {
    switch (this) {
      case GoalStatus.active:
        return 'Active';
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.overdue:
        return 'Overdue';
      case GoalStatus.cancelled:
        return 'Cancelled';
    }
  }

  String toJson() => name;

  static GoalStatus fromJson(String json) {
    return GoalStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => GoalStatus.active,
    );
  }
}

/// Farm service types for tracking maintenance and care activities
/// - vaccination: Vaccination services
/// - veterinary: Veterinary care and consultations
/// - feeding: Feed supply and management
/// - medicalTreatment: Medical treatments and procedures
/// - deworming: Deworming treatments
/// - other: Other farm services
enum ServiceType {
  vaccination,
  veterinary,
  feeding,
  medicalTreatment,
  deworming,
  other,
}

/// Extension to add display labels for ServiceType
extension ServiceTypeExtension on ServiceType {
  String get label {
    switch (this) {
      case ServiceType.vaccination:
        return 'Vaccination';
      case ServiceType.veterinary:
        return 'Veterinary';
      case ServiceType.feeding:
        return 'Feeding';
      case ServiceType.medicalTreatment:
        return 'Medical Treatment';
      case ServiceType.deworming:
        return 'Deworming';
      case ServiceType.other:
        return 'Other';
    }
  }

  String toJson() => name;

  static ServiceType fromJson(String json) {
    return ServiceType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => ServiceType.other,
    );
  }
}
