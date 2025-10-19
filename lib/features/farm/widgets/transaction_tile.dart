import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart' as model;
import '../constants/enums.dart';

class TransactionTile extends StatelessWidget {
  final model.Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type.addsQuantity;
    final color = isCredit ? Colors.green : Colors.red;
    final icon = isCredit ? Icons.add : Icons.remove;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(transaction.type.label),
        subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isCredit ? '+' : '-'}${transaction.quantity} head',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            if (transaction.value > 0)
              Text(NumberFormat.simpleCurrency().format(transaction.value)),
          ],
        ),
      ),
    );
  }
}
