part of 'lot_bloc.dart';

enum LotStatus { active, closed }

abstract class LotState extends Equatable {
  const LotState();

  @override
  List<Object?> get props => [];
}

class LotInitial extends LotState {}

class LotLoading extends LotState {}

class LotLoaded extends LotState {
  final List<CattleLot> lots;
  final List<CattleLot> filteredLots;

  const LotLoaded({required this.lots, List<CattleLot>? filteredLots})
      : filteredLots = filteredLots ?? lots;

  @override
  List<Object> get props => [lots, filteredLots];
}

class LotDetailsLoaded extends LotState {
  final CattleLot lot;
  final List<WeightHistory> weightHistory;

  const LotDetailsLoaded({
    required this.lot,
    required this.weightHistory,
  });

  @override
  List<Object> get props => [lot, weightHistory];
}

class LotError extends LotState {
  final String message;

  const LotError({required this.message});

  @override
  List<Object> get props => [message];
}

class LotOperationInProgress extends LotState {}

class LotOperationSuccess extends LotState {
  final String message;

  const LotOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class LotOperationFailure extends LotState {
  final String message;

  const LotOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class LotDeleteSuccess extends LotState {}
