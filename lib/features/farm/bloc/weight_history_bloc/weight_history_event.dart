part of 'weight_history_bloc.dart';

abstract class WeightHistoryEvent extends Equatable {
  const WeightHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadWeightHistory extends WeightHistoryEvent {
  final String farmId;
  final String lotId;

  const LoadWeightHistory({required this.farmId, required this.lotId});

  @override
  List<Object> get props => [farmId, lotId];
}

class AddWeightHistory extends WeightHistoryEvent {
  final WeightHistory weightHistory;

  const AddWeightHistory({required this.weightHistory});

  @override
  List<Object> get props => [weightHistory];
}
