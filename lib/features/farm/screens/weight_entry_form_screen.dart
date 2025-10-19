import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection.dart';
import '../../authentication/widgets/custom_text_field.dart';
import '../bloc/weight_history_bloc/weight_history_bloc.dart';
import '../models/cattle_lot_model.dart';
import '../models/weight_history_model.dart';

class WeightEntryFormScreen extends StatefulWidget {
  final CattleLot lot;

  const WeightEntryFormScreen({super.key, required this.lot});

  @override
  State<WeightEntryFormScreen> createState() => _WeightEntryFormScreenState();
}

class _WeightEntryFormScreenState extends State<WeightEntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late WeightHistoryBloc _weightHistoryBloc;

  late TextEditingController _weightController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _weightHistoryBloc = getIt<WeightHistoryBloc>();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weightRecord = WeightHistory(
        id: const Uuid().v4(),
        lotId: widget.lot.id,
        farmId: widget.lot.farmId, // Assuming farmId is in CattleLot
        date: _selectedDate,
        averageWeight: double.parse(_weightController.text),
        createdAt: DateTime.now(),
        createdBy: 'system', // TODO: Get current user
      );
      _weightHistoryBloc.add(AddWeightHistory(weightHistory: weightRecord));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Weight Record'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                controller: _weightController,
                label: 'Average Weight (@)',
                keyboardType: TextInputType.number,
                validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Measurement Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
