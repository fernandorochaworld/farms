import '../models/farm_model.dart';
import '../models/transaction_model.dart' as farm_transaction;
import '../repositories/cattle_lot_repository.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/person_repository.dart';

/// Summary data for a farm
class FarmSummary {
  final int totalCattle;
  final int activeLots;
  final List<farm_transaction.Transaction> recentTransactions;
  final double capacityUsagePercent;
  final int totalMembers;

  const FarmSummary({
    required this.totalCattle,
    required this.activeLots,
    required this.recentTransactions,
    required this.capacityUsagePercent,
    required this.totalMembers,
  });
}

/// Service for calculating farm summary statistics
class FarmSummaryService {
  final CattleLotRepository _lotRepository;
  final TransactionRepository _transactionRepository;
  final PersonRepository _personRepository;

  FarmSummaryService({
    required CattleLotRepository lotRepository,
    required TransactionRepository transactionRepository,
    required PersonRepository personRepository,
  })  : _lotRepository = lotRepository,
        _transactionRepository = transactionRepository,
        _personRepository = personRepository;

  /// Get summary data for a specific farm
  Future<FarmSummary> getSummary(Farm farm) async {
    try {
      // Get all lots for the farm
      final lots = await _lotRepository.getByFarmId(farm.id);

      // Calculate total cattle count
      final totalCattle = lots.fold<int>(
        0,
        (sum, lot) => sum + lot.currentQuantity,
      );

      // Count active lots
      final activeLots = lots.where((lot) => lot.isActive).length;

      // Get recent transactions (last 5)
      final allTransactions = await _transactionRepository.getAllByFarmId(farm.id);
      final recentTransactions = allTransactions.take(5).toList();

      // Calculate capacity usage percentage
      final capacityUsagePercent = farm.capacity > 0
          ? (totalCattle / farm.capacity * 100).clamp(0.0, 100.0).toDouble()
          : 0.0;

      // Get total member count
      final members = await _personRepository.getByFarmId(farm.id);
      final totalMembers = members.length;

      return FarmSummary(
        totalCattle: totalCattle,
        activeLots: activeLots,
        recentTransactions: recentTransactions,
        capacityUsagePercent: capacityUsagePercent,
        totalMembers: totalMembers,
      );
    } catch (e) {
      // Return empty summary on error
      return const FarmSummary(
        totalCattle: 0,
        activeLots: 0,
        recentTransactions: [],
        capacityUsagePercent: 0.0,
        totalMembers: 0,
      );
    }
  }

  /// Get summaries for multiple farms
  Future<Map<String, FarmSummary>> getSummaries(List<Farm> farms) async {
    final summaries = <String, FarmSummary>{};

    for (final farm in farms) {
      summaries[farm.id] = await getSummary(farm);
    }

    return summaries;
  }

  /// Get total cattle count across all farms for a user
  Future<int> getTotalCattleForUser(List<Farm> farms) async {
    int total = 0;

    for (final farm in farms) {
      final summary = await getSummary(farm);
      total += summary.totalCattle;
    }

    return total;
  }

  /// Get total active lots across all farms for a user
  Future<int> getTotalActiveLotsForUser(List<Farm> farms) async {
    int total = 0;

    for (final farm in farms) {
      final summary = await getSummary(farm);
      total += summary.activeLots;
    }

    return total;
  }
}
