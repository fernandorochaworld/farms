import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../models/weight_history_model.dart';
import '../../repositories/weight_history_repository.dart';

part 'weight_history_event.dart';
part 'weight_history_state.dart';

class WeightHistoryBloc extends Bloc<WeightHistoryEvent, WeightHistoryState> {
  final WeightHistoryRepository _weightHistoryRepository;
  final Uuid _uuid;

  WeightHistoryBloc({
    required WeightHistoryRepository weightHistoryRepository,
    Uuid? uuid,
  })  : _weightHistoryRepository = weightHistoryRepository,
        _uuid = uuid ?? const Uuid(),
        super(WeightHistoryInitial()) {
    on<LoadWeightHistory>(_onLoadWeightHistory);
    on<AddWeightHistory>(_onAddWeightHistory);
  }

  Future<void> _onLoadWeightHistory(
      LoadWeightHistory event, Emitter<WeightHistoryState> emit) async {
    emit(WeightHistoryLoading());
    try {
      final history = await _weightHistoryRepository.getByLotId(event.farmId, event.lotId);
      emit(WeightHistoryLoaded(weightHistory: history));
    } catch (e) {
      emit(WeightHistoryError(message: e.toString()));
    }
  }

  Future<void> _onAddWeightHistory(
      AddWeightHistory event, Emitter<WeightHistoryState> emit) async {
    try {
      await _weightHistoryRepository.create(event.weightHistory.farmId, event.weightHistory.lotId, event.weightHistory);
      add(LoadWeightHistory(farmId: event.weightHistory.farmId, lotId: event.weightHistory.lotId));
    } catch (e) {
      emit(WeightHistoryError(message: e.toString()));
    }
  }
}
