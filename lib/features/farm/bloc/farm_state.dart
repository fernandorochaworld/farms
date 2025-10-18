import 'package:equatable/equatable.dart';
import '../models/farm_model.dart';

/// Base class for all farm states
abstract class FarmState extends Equatable {
  const FarmState();

  @override
  List<Object?> get props => [];
}

/// Initial state when farm status is unknown
class FarmInitial extends FarmState {
  const FarmInitial();
}

/// State when loading farms
class FarmLoading extends FarmState {
  const FarmLoading();
}

/// State when farms are loaded successfully
class FarmLoaded extends FarmState {
  final List<Farm> farms;

  const FarmLoaded({required this.farms});

  @override
  List<Object?> get props => [farms];
}

/// State when a single farm is loaded
class FarmDetailLoaded extends FarmState {
  final Farm farm;

  const FarmDetailLoaded({required this.farm});

  @override
  List<Object?> get props => [farm];
}

/// State when an error occurs
class FarmError extends FarmState {
  final String message;

  const FarmError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when a farm operation is in progress (create, update, delete)
class FarmOperationInProgress extends FarmState {
  const FarmOperationInProgress();
}

/// State when a farm operation succeeds
class FarmOperationSuccess extends FarmState {
  final Farm? farm;
  final String? message;

  const FarmOperationSuccess({this.farm, this.message});

  @override
  List<Object?> get props => [farm, message];
}

/// State when a farm operation fails
class FarmOperationFailure extends FarmState {
  final String message;

  const FarmOperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
