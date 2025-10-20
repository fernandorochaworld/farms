import 'package:flutter/material.dart';
import '../constants/enums.dart';

class ServiceTypeSelector extends StatelessWidget {
  final ServiceType? selectedType;
  final ValueChanged<ServiceType> onChanged;

  const ServiceTypeSelector({super.key, this.selectedType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ServiceType>(
      value: selectedType,
      hint: const Text('Select Service Type'),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      items: ServiceType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.toString().split('.').last),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select a type' : null,
    );
  }
}
