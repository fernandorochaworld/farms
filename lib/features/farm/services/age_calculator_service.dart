import '../constants/enums.dart';

class AgeCalculator {
  static AgeRange calculateAgeRange(
    DateTime birthStart,
    DateTime birthEnd, [
    DateTime? referenceDate,
  ]) {
    final ref = referenceDate ?? DateTime.now();

    final minMonths = _monthsBetween(birthEnd, ref);
    final maxMonths = _monthsBetween(birthStart, ref);

    return AgeRange(min: minMonths, max: maxMonths);
  }

  static int _monthsBetween(DateTime start, DateTime end) {
    final months = (end.year - start.year) * 12 + end.month - start.month;
    return months < 0 ? 0 : months;
  }

  static String formatAgeRange(AgeRange age) {
    if (age.min == age.max) {
      return _formatAge(age.min);
    }
    return '${_formatAge(age.min)} - ${_formatAge(age.max)}';
  }

  static String _formatAge(int months) {
    if (months < 12) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    }
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    return '$years years, $remainingMonths months';
  }

  static CattleType suggestCattleType(int ageInMonths) {
    if (ageInMonths <= 12) return CattleType.bezerro;
    if (ageInMonths <= 24) return CattleType.novilho;
    if (ageInMonths <= 36) return CattleType.boi3anos;
    if (ageInMonths <= 48) return CattleType.boi4anos;
    return CattleType.boi5maisAnos;
  }

  static bool validateTypeMatchesAge(CattleType type, int ageInMonths) {
    return type == suggestCattleType(ageInMonths);
  }
}

class AgeRange {
  final int min;
  final int max;

  AgeRange({required this.min, required this.max});
}
