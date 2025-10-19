part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}

class LoadGoals extends GoalEvent {
  final String farmId;

  const LoadGoals({required this.farmId});

  @override
  List<Object> get props => [farmId];
}

class AddGoal extends GoalEvent {
  final Goal goal;

  const AddGoal({required this.goal});

  @override
  List<Object> get props => [goal];
}

class UpdateGoal extends GoalEvent {
  final Goal goal;

  const UpdateGoal({required this.goal});

  @override
  List<Object> get props => [goal];
}

class DeleteGoal extends GoalEvent {
  final Goal goal;

  const DeleteGoal({required this.goal});

  @override
  List<Object> get props => [goal];
}
