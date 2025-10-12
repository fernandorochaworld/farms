/// Barrel file for all farm repositories
///
/// This file exports all repository interfaces and implementations
/// used in the farm feature, providing a single import point for
/// cleaner code organization.
///
/// Usage:
/// ```dart
/// import 'package:farms/features/farm/repositories/repositories.dart';
///
/// // Now you can use all repository interfaces:
/// final FarmRepository farmRepo = FirebaseFarmRepository(...);
/// final PersonRepository personRepo = FirebasePersonRepository(...);
/// ```

// Repository Interfaces
export 'cattle_lot_repository.dart';
export 'farm_repository.dart';
export 'farm_service_repository.dart';
export 'goal_repository.dart';
export 'person_repository.dart';
export 'transaction_repository.dart';
export 'weight_history_repository.dart';

// Repository Implementations
export 'firebase_cattle_lot_repository.dart';
export 'firebase_farm_repository.dart';
export 'firebase_farm_service_repository.dart';
export 'firebase_goal_repository.dart';
export 'firebase_person_repository.dart';
export 'firebase_transaction_repository.dart';
export 'firebase_weight_history_repository.dart';
