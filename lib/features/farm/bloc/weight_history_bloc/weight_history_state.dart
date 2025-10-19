part of 'weight_history_bloc.dart';

abstract class WeightHistoryState extends Equatable {
  const WeightHistoryState();

  @override
  List<Object> get props => [];
}

class WeightHistoryInitial extends WeightHistoryState {}

class WeightHistoryLoading extends WeightHistoryState {}

class WeightHistoryLoaded extends WeightHistoryState {
  final List<WeightHistory> weightHistory;

  const WeightHistoryLoaded({required this.weightHistory});

  @override
  List<Object> get props => [weightHistory];
}

class WeightHistoryError extends WeightHistoryState {
  final String message;

  const WeightHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
