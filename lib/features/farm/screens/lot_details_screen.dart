
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/lot_bloc/lot_bloc.dart';
import '../models/farm_model.dart';
import '../models/cattle_lot_model.dart';
import '../models/weight_history_model.dart';
import '../services/age_calculator_service.dart';
import '../constants/enums.dart';
import 'lot_form_screen.dart';
import 'transaction_list_screen.dart';
import 'weight_history_screen.dart';

class LotDetailsScreen extends StatefulWidget {
  final Farm farm;
  final String lotId;

  const LotDetailsScreen({super.key, required this.farm, required this.lotId});

  static const String routeName = '/farm/lot/details';

  @override
  State<LotDetailsScreen> createState() => _LotDetailsScreenState();
}

class _LotDetailsScreenState extends State<LotDetailsScreen> {
  late LotBloc _lotBloc;

  @override
  void initState() {
    super.initState();
    _lotBloc = getIt<LotBloc>()
      ..add(LoadLotDetails(farmId: widget.farm.id, lotId: widget.lotId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lot Details'),
        actions: [
          BlocBuilder<LotBloc, LotState>(
            bloc: _lotBloc,
            builder: (context, state) {
              if (state is LotDetailsLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LotFormScreen(
                          farm: widget.farm,
                          lot: state.lot,
                        ),
                      ),
                    ).then((deleted) {
                      if (deleted == true) {
                        Navigator.of(context).pop();
                      } else {
                        _lotBloc.add(LoadLotDetails(farmId: widget.farm.id, lotId: widget.lotId));
                      }
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _lotBloc,
        child: BlocBuilder<LotBloc, LotState>(
          builder: (context, state) {
            if (state is LotLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LotError) {
              return Center(child: Text(state.message));
            }
            if (state is LotDetailsLoaded) {
              final lot = state.lot;
              final ageRange = AgeCalculator.formatAgeRange(lot.ageRange);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lot.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    _buildInfoCard(context, lot, ageRange, state.weightHistory),
                    const SizedBox(height: 16),
                    // Placeholder for statistics
                    Text('Statistics', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransactionListScreen(lot: lot),
                          ),
                        );
                      },
                      child: const Text('View Transactions'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WeightHistoryScreen(lot: lot),
                          ),
                        );
                      },
                      child: const Text('View Weight History'),
                    ),
                    const SizedBox(height: 16),
                    // Placeholder for transactions
                    Text('Transactions', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, CattleLot lot, String ageRange, List<WeightHistory> weightHistory) {
    final latestWeight = weightHistory.isNotEmpty ? weightHistory.first.averageWeight : 0.0;
    final initialWeight = weightHistory.isNotEmpty ? weightHistory.last.averageWeight : 0.0;
    final weightGain = latestWeight - initialWeight;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(context, Icons.pets, 'Current Quantity', '${lot.currentQuantity} head'),
            const Divider(),
            _buildInfoRow(context, Icons.tag, 'Status', lot.isActive ? 'Active' : 'Closed'),
            const Divider(),
            _buildInfoRow(context, lot.cattleType.icon, 'Type', lot.cattleType.label),
            const Divider(),
            _buildInfoRow(context, lot.gender.icon, 'Gender', lot.gender.label),
            const Divider(),
            _buildInfoRow(context, Icons.cake, 'Age Range', ageRange),
            const Divider(),
            _buildInfoRow(context, Icons.timer, 'Days Active', '${lot.daysActive} days'),
            const Divider(),
            _buildInfoRow(context, Icons.monitor_weight, 'Latest Weight', '${latestWeight.toStringAsFixed(2)} @'),
            const Divider(),
            _buildInfoRow(context, Icons.trending_up, 'Weight Gain', '${weightGain.toStringAsFixed(2)} @'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
