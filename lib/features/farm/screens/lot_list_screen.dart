
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/lot_bloc/lot_bloc.dart';
import '../models/farm_model.dart';
import '../widgets/lot_card.dart';
import 'lot_form_screen.dart';
import 'lot_details_screen.dart';

class LotListScreen extends StatefulWidget {
  final Farm farm;

  const LotListScreen({super.key, required this.farm});

  static const String routeName = '/farm/lots';

  @override
  State<LotListScreen> createState() => _LotListScreenState();
}

class _LotListScreenState extends State<LotListScreen> {
  late LotBloc _lotBloc;

  @override
  void initState() {
    super.initState();
    _lotBloc = getIt<LotBloc>()..add(LoadLots(farmId: widget.farm.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cattle Lots (${widget.farm.name})'),
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
            if (state is LotLoaded) {
              if (state.lots.isEmpty) {
                return const Center(child: Text('No lots found.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  _lotBloc.add(LoadLots(farmId: widget.farm.id));
                },
                child: ListView.builder(
                  itemCount: state.filteredLots.length,
                  itemBuilder: (context, index) {
                    final lot = state.filteredLots[index];
                    return LotCard(
                      lot: lot,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LotDetailsScreen(
                              farm: widget.farm,
                              lotId: lot.id,
                            ),
                          ),
                        ).then((_) => _lotBloc.add(LoadLots(farmId: widget.farm.id)));
                      },
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LotFormScreen(farm: widget.farm),
            ),
          ).then((_) => _lotBloc.add(LoadLots(farmId: widget.farm.id)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
