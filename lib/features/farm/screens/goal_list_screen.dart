import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/goal_bloc.dart';
import '../models/farm_model.dart';
import '../widgets/goal_card.dart';
import 'goal_form_screen.dart';
import 'goal_details_screen.dart';

class GoalListScreen extends StatefulWidget {
  final Farm farm;

  const GoalListScreen({super.key, required this.farm});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  late GoalBloc _goalBloc;

  @override
  void initState() {
    super.initState();
    _goalBloc = getIt<GoalBloc>()..add(LoadGoals(farmId: widget.farm.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: BlocProvider.value(
        value: _goalBloc,
        child: BlocBuilder<GoalBloc, GoalState>(
          builder: (context, state) {
            if (state is GoalLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GoalError) {
              return Center(child: Text(state.message));
            }
            if (state is GoalLoaded) {
              if (state.goals.isEmpty) {
                return const Center(child: Text('No goals found.'));
              }
              return ListView.builder(
                itemCount: state.goals.length,
                itemBuilder: (context, index) {
                  final goal = state.goals[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GoalDetailsScreen(goal: goal),
                      ),
                    ),
                    child: GoalCard(goal: goal),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GoalFormScreen(farm: widget.farm),
            ),
          ).then((_) => _goalBloc.add(LoadGoals(farmId: widget.farm.id)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
