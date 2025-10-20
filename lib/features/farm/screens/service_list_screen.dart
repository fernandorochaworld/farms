import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/service_bloc.dart';
import '../models/farm_model.dart';
import '../widgets/service_card.dart';
import 'service_form_screen.dart';
import 'service_details_screen.dart';

class ServiceListScreen extends StatefulWidget {
  final Farm farm;

  const ServiceListScreen({super.key, required this.farm});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();
    _serviceBloc = getIt<ServiceBloc>()..add(LoadServices(farmId: widget.farm.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: BlocProvider.value(
        value: _serviceBloc,
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ServiceError) {
              return Center(child: Text(state.message));
            }
            if (state is ServiceLoaded) {
              if (state.services.isEmpty) {
                return const Center(child: Text('No services found.'));
              }
              return ListView.builder(
                itemCount: state.services.length,
                itemBuilder: (context, index) {
                  final service = state.services[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailsScreen(service: service, farm: widget.farm),
                      ),
                    ),
                    child: ServiceCard(service: service),
                  );
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
              builder: (_) => ServiceFormScreen(farm: widget.farm),
            ),
          ).then((_) => _serviceBloc.add(LoadServices(farmId: widget.farm.id)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
