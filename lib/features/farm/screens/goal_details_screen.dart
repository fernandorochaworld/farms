import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/goal_model.dart';

class GoalDetailsScreen extends StatelessWidget {
  final Goal goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(goal.description, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(context, Icons.flag, 'Status', goal.status.toString().split('.').last),
                    const Divider(),
                    _buildInfoRow(context, Icons.calendar_today, 'Start Date', DateFormat.yMMMd().format(goal.definitionDate)),
                    const Divider(),
                    _buildInfoRow(context, Icons.calendar_today, 'Goal Date', DateFormat.yMMMd().format(goal.goalDate)),
                    if (goal.averageWeight != null) ...[
                      const Divider(),
                      _buildInfoRow(context, Icons.monitor_weight, 'Weight Target', '${goal.averageWeight} @'),
                    ],
                    if (goal.birthQuantity != null) ...[
                      const Divider(),
                      _buildInfoRow(context, Icons.pets, 'Birth Target', '${goal.birthQuantity} births'),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
