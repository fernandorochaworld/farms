import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weight_history_model.dart';

class WeightRecordCard extends StatelessWidget {
  final WeightHistory record;
  final WeightHistory? previousRecord;

  const WeightRecordCard({super.key, required this.record, this.previousRecord});

  @override
  Widget build(BuildContext context) {
    double? weightChange;
    if (previousRecord != null) {
      weightChange = record.averageWeight - previousRecord!.averageWeight;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(DateFormat.yMMMd().format(record.date)),
        subtitle: Text('${record.averageWeight.toStringAsFixed(2)} @'),
        trailing: weightChange != null
            ? Text(
                '${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(2)} @',
                style: TextStyle(
                  color: weightChange >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
