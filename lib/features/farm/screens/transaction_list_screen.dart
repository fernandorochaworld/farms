import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/transaction_bloc/transaction_bloc.dart';
import '../models/cattle_lot_model.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_type_selector_screen.dart';

class TransactionListScreen extends StatefulWidget {
  final CattleLot lot;

  const TransactionListScreen({super.key, required this.lot});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();
    _transactionBloc = getIt<TransactionBloc>()
      ..add(LoadTransactions(farmId: widget.lot.farmId, lotId: widget.lot.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions for ${widget.lot.name}'),
      ),
      body: BlocProvider.value(
        value: _transactionBloc,
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TransactionOperationFailure) {
              return Center(child: Text(state.message));
            }
            if (state is TransactionLoaded) {
              if (state.transactions.isEmpty) {
                return const Center(child: Text('No transactions found.'));
              }
              return ListView.builder(
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  return TransactionTile(transaction: state.transactions[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionTypeSelectorScreen(lot: widget.lot),
            ),
          ).then((_) => _transactionBloc.add(LoadTransactions(farmId: widget.lot.farmId, lotId: widget.lot.id)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
