import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/farm_service_history_model.dart';

class ServiceCard extends StatelessWidget {
  final FarmServiceHistory service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(service.serviceType.toString().split('.').last),
        subtitle: Text(
          '${service.description} - ${NumberFormat.simpleCurrency().format(service.value)}',
        ),
        trailing: Text(DateFormat.yMMMd().format(service.date)),
      ),
    );
  }
}
