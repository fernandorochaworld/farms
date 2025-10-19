import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../models/goal_model.dart';
import '../repositories/goal_repository.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalRepository _goalRepository;
  final Uuid _uuid;

  GoalBloc({
    required GoalRepository goalRepository,
    Uuid? uuid,
  })  : _goalRepository = goalRepository,
        _uuid = uuid ?? const Uuid(),
        super(GoalInitial()) {
    on<LoadGoals>(_onLoadGoals);
    on<AddGoal>(_onAddGoal);
    on<UpdateGoal>(_onUpdateGoal);
    on<DeleteGoal>(_onDeleteGoal);
  }

  Future<void> _onLoadGoals(LoadGoals event, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    try {
      final goals = await _goalRepository.getByFarmId(event.farmId);
      emit(GoalLoaded(goals: goals));
    } catch (e) {
      emit(GoalError(message: e.toString()));
    }
  }

  Future<void> _onAddGoal(AddGoal event, Emitter<GoalState> emit) async {
    try {
      await _goalRepository.create(event.goal.farmId, event.goal);
      add(LoadGoals(farmId: event.goal.farmId));
    } catch (e) {
      emit(GoalError(message: e.toString()));
    }
  }

  Future<void> _onUpdateGoal(UpdateGoal event, Emitter<GoalState> emit) async {
    try {
      await _goalRepository.update(event.goal.farmId, event.goal);
      add(LoadGoals(farmId: event.goal.farmId));
    } catch (e) {
      emit(GoalError(message: e.toString()));
    }
  }

  Future<void> _onDeleteGoal(DeleteGoal event, Emitter<GoalState> emit) async {
    try {
      await _goalRepository.delete(event.goal.farmId, event.goal.id);
      add(LoadGoals(farmId: event.goal.farmId));
    } catch (e) {
      emit(GoalError(message: e.toString()));
    }
  }
}
