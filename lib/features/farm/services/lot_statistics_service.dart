import '../models/cattle_lot_model.dart';
import '../models/transaction_model.dart' as farm_transaction;
import '../constants/enums.dart';

class LotStatistics {
  final int totalAdded;
  final int totalRemoved;
  final int currentQuantity;
  final int transactionCount;
  final int daysActive;
  final int buyCount;
  final int sellCount;
  final int dieCount;
  final int moveCount;
  final double mortalityRate;

  LotStatistics({
    required this.totalAdded,
    required this.totalRemoved,
    required this.currentQuantity,
    required this.transactionCount,
    required this.daysActive,
    required this.buyCount,
    required this.sellCount,
    required this.dieCount,
    required this.moveCount,
    required this.mortalityRate,
  });
}

class LotStatisticsService {
  LotStatistics calculate(CattleLot lot, List<farm_transaction.Transaction> transactions) {
    final totalAdded = lot.qtdAdded;
    final totalRemoved = lot.qtdRemoved;
    final currentQuantity = lot.currentQuantity;

    final daysActive = (lot.endDate ?? DateTime.now()).difference(lot.startDate).inDays;

    int buyCount = 0;
    int sellCount = 0;
    int dieCount = 0;
    int moveCount = 0;

    for (final t in transactions) {
      switch (t.type) {
        case TransactionType.buy:
          buyCount++;
          break;
        case TransactionType.sell:
          sellCount++;
          break;
        case TransactionType.die:
          dieCount++;
          break;
        case TransactionType.move:
          moveCount++;
          break;
      }
    }

    final mortalityRate = totalAdded > 0 ? (dieCount / totalAdded) * 100 : 0.0;

    return LotStatistics(
      totalAdded: totalAdded,
      totalRemoved: totalRemoved,
      currentQuantity: currentQuantity,
      transactionCount: transactions.length,
      daysActive: daysActive,
      buyCount: buyCount,
      sellCount: sellCount,
      dieCount: dieCount,
      moveCount: moveCount,
      mortalityRate: mortalityRate,
    );
  }
}
