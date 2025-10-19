import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/weight_history_model.dart';

class WeightChartWidget extends StatelessWidget {
  final List<WeightHistory> weightHistory;

  const WeightChartWidget({super.key, required this.weightHistory});

  @override
  Widget build(BuildContext context) {
    if (weightHistory.length < 2) {
      return const Center(child: Text('Not enough data to display a chart.'));
    }

    final spots = weightHistory.map((record) {
      return FlSpot(record.date.millisecondsSinceEpoch.toDouble(), record.averageWeight);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Theme.of(context).primaryColor,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}
