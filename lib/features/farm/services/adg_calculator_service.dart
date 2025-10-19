import '../models/weight_history_model.dart';

class ADGCalculator {
  // Calculates Average Daily Gain between two points
  static double calculateADG(WeightHistory start, WeightHistory end) {
    final weightGain = end.averageWeight - start.averageWeight;
    final days = end.date.difference(start.date).inDays;
    if (days <= 0) return 0.0;
    return weightGain / days;
  }

  // Calculates ADG for a whole list of records
  static double calculateOverallADG(List<WeightHistory> history) {
    if (history.length < 2) return 0.0;
    history.sort((a, b) => a.date.compareTo(b.date));
    return calculateADG(history.first, history.last);
  }
}
