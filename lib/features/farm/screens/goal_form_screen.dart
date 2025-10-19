import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection.dart';
import '../../authentication/widgets/custom_text_field.dart';
import '../bloc/goal_bloc.dart';
import '../models/farm_model.dart';
import '../models/goal_model.dart';
import '../constants/enums.dart';

class GoalFormScreen extends StatefulWidget {
  final Farm farm;

  const GoalFormScreen({super.key, required this.farm});

  @override
  State<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends State<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late GoalBloc _goalBloc;

  late TextEditingController _descriptionController;
  late TextEditingController _weightController;
  late TextEditingController _quantityController;
  DateTime _definitionDate = DateTime.now();
  DateTime _goalDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    _goalBloc = getIt<GoalBloc>();
    _descriptionController = TextEditingController();
    _weightController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _weightController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final goal = Goal(
        id: const Uuid().v4(),
        farmId: widget.farm.id,
        description: _descriptionController.text,
        definitionDate: _definitionDate,
        goalDate: _goalDate,
        averageWeight: double.tryParse(_weightController.text),
        birthQuantity: int.tryParse(_quantityController.text),
        status: GoalStatus.active,
        createdAt: DateTime.now(),
      );
      _goalBloc.add(AddGoal(goal: goal));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Goal'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _weightController,
                label: 'Average Weight Target (@)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _quantityController,
                label: 'Birth Quantity Target',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Definition Date'),
                subtitle: Text(DateFormat.yMMMd().format(_definitionDate)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _definitionDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _definitionDate = picked);
                  }
                },
              ),
              ListTile(
                title: const Text('Goal Date'),
                subtitle: Text(DateFormat.yMMMd().format(_goalDate)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _goalDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) {
                    setState(() => _goalDate = picked);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
