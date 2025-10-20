import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection.dart';
import '../../authentication/widgets/custom_text_field.dart';
import '../bloc/service_bloc.dart';
import '../constants/enums.dart';
import '../models/farm_model.dart';
import '../models/farm_service_history_model.dart';
import '../widgets/service_type_selector.dart';

class ServiceFormScreen extends StatefulWidget {
  final Farm farm;
  final FarmServiceHistory? service;

  const ServiceFormScreen({super.key, required this.farm, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ServiceBloc _serviceBloc;

  ServiceType? _selectedType;
  DateTime _selectedDate = DateTime.now();
  late TextEditingController _costController;
  late TextEditingController _descriptionController;
  ServiceStatus _selectedStatus = ServiceStatus.toDo;

  bool get isEditMode => widget.service != null;

  @override
  void initState() {
    super.initState();
    _serviceBloc = getIt<ServiceBloc>();
    
    if (isEditMode) {
      final service = widget.service!;
      _selectedType = service.serviceType;
      _selectedDate = service.date;
      _costController = TextEditingController(text: service.value.toString());
      _descriptionController = TextEditingController(text: service.description);
      _selectedStatus = service.status;
    } else {
      _costController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _costController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final updatedService = widget.service!.copyWith(
          serviceType: _selectedType,
          date: _selectedDate,
          value: double.tryParse(_costController.text) ?? 0.0,
          description: _descriptionController.text,
          status: _selectedStatus,
        );
        _serviceBloc.add(UpdateService(service: updatedService));
      } else {
        final newService = FarmServiceHistory(
          id: const Uuid().v4(),
          farmId: widget.farm.id,
          serviceType: _selectedType!,
          date: _selectedDate,
          value: double.tryParse(_costController.text) ?? 0.0,
          description: _descriptionController.text,
          status: _selectedStatus,
          createdAt: DateTime.now(),
          createdBy: 'system', // TODO: Get current user
        );
        _serviceBloc.add(AddService(service: newService));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Service' : 'New Service'),
      ),
      body: BlocListener<ServiceBloc, ServiceState>(
        bloc: _serviceBloc,
        listener: (context, state) {
          if (state is ServiceDeleteSuccess) {
            Navigator.of(context).pop('deleted');
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ServiceTypeSelector(
                  selectedType: _selectedType,
                  onChanged: (type) => setState(() => _selectedType = type),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _costController,
                  label: 'Cost',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Service Date'),
                  subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ServiceStatus>(
                  value: _selectedStatus,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedStatus = value);
                    }
                  },
                  items: ServiceStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(isEditMode ? 'Update Service' : 'Add Service'),
                ),
                if (isEditMode) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Builder(builder: (context) {
                    final canDelete = DateTime.now().difference(widget.service!.createdAt).inDays < 3;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton.icon(
                          onPressed: canDelete ? () => _showDeleteConfirmation(context) : null,
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete Service'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You can only delete a service within 3 days of its creation.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text(
            'Are you sure you want to delete this service? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _serviceBloc.add(DeleteService(service: widget.service!));
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
