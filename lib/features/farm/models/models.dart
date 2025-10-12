/// Barrel file for all farm models
///
/// This file exports all model classes used in the farm feature,
/// providing a single import point for cleaner code organization.
///
/// Usage:
/// ```dart
/// import 'package:farms/features/farm/models/models.dart';
///
/// // Now you can use all models:
/// final farm = Farm(...);
/// final lot = CattleLot(...);
/// ```

export 'cattle_lot_model.dart';
export 'farm_model.dart';
export 'farm_service_history_model.dart';
export 'goal_model.dart';
export 'person_model.dart';
export 'transaction_model.dart';
export 'weight_history_model.dart';
