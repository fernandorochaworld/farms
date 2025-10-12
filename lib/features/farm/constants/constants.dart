/// Barrel file for all farm constants
///
/// This file exports all constant definitions used in the farm feature,
/// including enums, Firestore paths, and field names.
///
/// Usage:
/// ```dart
/// import 'package:farms/features/farm/constants/constants.dart';
///
/// // Now you can use all constants:
/// final path = FirestorePaths.farmDocument(farmId);
/// final type = PersonType.owner;
/// ```
library;

export 'enums.dart';
export 'firestore_paths.dart';
