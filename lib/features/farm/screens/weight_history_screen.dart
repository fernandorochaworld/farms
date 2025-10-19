import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/weight_history_bloc/weight_history_bloc.dart';
import '../models/cattle_lot_model.dart';
import '../widgets/weight_chart_widget.dart';
import '../widgets/weight_record_card.dart';
import 'weight_entry_form_screen.dart';

class WeightHistoryScreen extends StatefulWidget {
  final CattleLot lot;

  const WeightHistoryScreen({super.key, required this.lot});

  @override
  State<WeightHistoryScreen> createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends State<WeightHistoryScreen> {
  late WeightHistoryBloc _weightHistoryBloc;

  @override
  void initState() {
    super.initState();
    _weightHistoryBloc = getIt<WeightHistoryBloc>()
      ..add(LoadWeightHistory(farmId: widget.lot.farmId, lotId: widget.lot.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight History for ${widget.lot.name}'),
      ),
      body: BlocProvider.value(
        value: _weightHistoryBloc,
        child: BlocBuilder<WeightHistoryBloc, WeightHistoryState>(
          builder: (context, state) {
            if (state is WeightHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WeightHistoryError) {
              return Center(child: Text(state.message));
            }
            if (state is WeightHistoryLoaded) {
              final history = state.weightHistory;
              return Column(
                children: [
                  if (history.length >= 2)
                    SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: WeightChartWidget(weightHistory: history),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final record = history[index];
                        final previousRecord = index < history.length - 1 ? history[index + 1] : null;
                        return WeightRecordCard(record: record, previousRecord: previousRecord);
                      },
                    ),
                  ),
                ],
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
              builder: (_) => WeightEntryFormScreen(lot: widget.lot),
            ),
          ).then((_) => _weightHistoryBloc.add(LoadWeightHistory(farmId: widget.lot.farmId, lotId: widget.lot.id)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
