import 'package:flutter/material.dart';
import '../constants/enums.dart';
import 'transaction_form_screen.dart';
import '../models/cattle_lot_model.dart';

class TransactionTypeSelectorScreen extends StatelessWidget {
  final CattleLot lot;

  const TransactionTypeSelectorScreen({super.key, required this.lot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: TransactionType.values.map((type) {
          return Card(
            child: ListTile(
              leading: Icon(type.icon, color: type.color),
              title: Text(type.label),
              subtitle: Text(type.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionFormScreen(lot: lot, type: type),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}


extension on TransactionType {
  IconData get icon {
    switch (this) {
      case TransactionType.buy: return Icons.add;
      case TransactionType.sell: return Icons.remove;
      case TransactionType.move: return Icons.swap_horiz;
      case TransactionType.die: return Icons.warning;
    }
  }

  Color get color {
    switch (this) {
      case TransactionType.buy: return Colors.green;
      case TransactionType.sell: return Colors.red;
      case TransactionType.move: return Colors.blue;
      case TransactionType.die: return Colors.orange;
    }
  }
}
