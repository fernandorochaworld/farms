import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/farm_bloc.dart';
import '../bloc/farm_event.dart';
import '../bloc/farm_state.dart';
import '../models/farm_model.dart';
import '../../authentication/widgets/custom_text_field.dart';

/// Screen for editing an existing farm
class FarmEditScreen extends StatefulWidget {
  final Farm farm;

  const FarmEditScreen({
    super.key,
    required this.farm,
  });

  static const String routeName = '/farm/edit';

  @override
  State<FarmEditScreen> createState() => _FarmEditScreenState();
}

class _FarmEditScreenState extends State<FarmEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _capacityController;
  bool _isFormValid = false;
  bool _hasChanges = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.farm.name);
    _descriptionController =
        TextEditingController(text: widget.farm.description ?? '');
    _capacityController =
        TextEditingController(text: widget.farm.capacity.toString());

    _nameController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _capacityController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final capacity = int.tryParse(_capacityController.text.trim());

    setState(() {
      _isFormValid = name.length >= 3 && capacity != null && capacity > 0;

      // Check if any changes were made
      _hasChanges = name != widget.farm.name ||
          _descriptionController.text.trim() !=
              (widget.farm.description ?? '') ||
          capacity != widget.farm.capacity;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _hasChanges) {
      final updatedFarm = widget.farm.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        capacity: int.parse(_capacityController.text.trim()),
        updatedAt: DateTime.now(),
      );

      context.read<FarmBloc>().add(UpdateFarm(farm: updatedFarm));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Farm'),
        elevation: 0,
      ),
      body: BlocConsumer<FarmBloc, FarmState>(
        listener: (context, state) {
          if (state is FarmOperationInProgress) {
            setState(() => _isSubmitting = true);
          } else if (state is FarmLoaded && _isSubmitting) {
            // Farm was updated successfully and list was reloaded
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Farm updated successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is FarmOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Farm updated successfully'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is FarmOperationFailure) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is FarmOperationInProgress;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Icon(
                      Icons.edit,
                      size: 60,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Edit Farm Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Update the information for your farm',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Farm Name Field
                    CustomTextField(
                      controller: _nameController,
                      label: 'Farm Name *',
                      hint: 'Enter farm name',
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.business),
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Farm name is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Farm name must be at least 3 characters';
                        }
                        if (value.trim().length > 100) {
                          return 'Farm name must not exceed 100 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Enter farm description (optional)',
                      keyboardType: TextInputType.multiline,
                      prefixIcon: const Icon(Icons.description),
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value != null && value.trim().length > 500) {
                          return 'Description must not exceed 500 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Capacity Field
                    CustomTextField(
                      controller: _capacityController,
                      label: 'Capacity (head) *',
                      hint: 'Enter maximum capacity',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.numbers),
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Capacity is required';
                        }
                        final capacity = int.tryParse(value.trim());
                        if (capacity == null) {
                          return 'Capacity must be a valid number';
                        }
                        if (capacity <= 0) {
                          return 'Capacity must be greater than 0';
                        }
                        if (capacity > 100000) {
                          return 'Capacity must not exceed 100,000';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Update Button
                    ElevatedButton(
                      onPressed: isLoading || !_isFormValid || !_hasChanges
                          ? null
                          : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Updating...',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : const Text(
                              'Update Farm',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Cancel Button
                    OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    // Show a message if no changes were made
                    if (_isFormValid && !_hasChanges)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'No changes detected',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
