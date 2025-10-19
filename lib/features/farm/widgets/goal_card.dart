import 'package:flutter/material.dart';
import '../models/goal_model.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(goal.description, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // TODO: Implement progress calculation and display
            LinearProgressIndicator(value: 0.5), // Placeholder
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Target: ${goal.goalDate.toLocal().toString().split(' ')[0]}'),
                Text(goal.status.toString().split('.').last), // Placeholder
              ],
            )
          ],
        ),
      ),
    );
  }
}
