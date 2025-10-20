import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/farm_service_history_model.dart';
import 'service_form_screen.dart';
import '../models/farm_model.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final FarmServiceHistory service;
  final Farm farm;

  const ServiceDetailsScreen({super.key, required this.service, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceFormScreen(farm: farm, service: service),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.description, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(context, Icons.category, 'Type', service.serviceType.toString().split('.').last),
                    const Divider(),
                    _buildInfoRow(context, Icons.calendar_today, 'Date', DateFormat.yMMMd().format(service.date)),
                    const Divider(),
                    _buildInfoRow(context, Icons.attach_money, 'Cost', service.value.toStringAsFixed(2)),
                    const Divider(),
                    _buildInfoRow(context, Icons.info, 'Status', service.status.toString().split('.').last),
                  ],
                ),
              ),
            ),
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
