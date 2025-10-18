import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bloc/farm_bloc.dart';
import '../bloc/farm_event.dart';
import '../bloc/farm_state.dart';
import '../models/farm_model.dart';
import '../../authentication/widgets/custom_text_field.dart';

/// Screen for creating a new farm
class FarmCreateScreen extends StatefulWidget {
  const FarmCreateScreen({super.key});

  static const String routeName = '/farm/create';

  @override
  State<FarmCreateScreen> createState() => _FarmCreateScreenState();
}

class _FarmCreateScreenState extends State<FarmCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
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
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final farm = Farm(
        id: '', // Firestore will generate this
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : '',
        capacity: int.parse(_capacityController.text.trim()),
        createdBy: user.uid,
        createdAt: DateTime.now(),
      );

      context.read<FarmBloc>().add(
            CreateFarm(
              farm: farm,
              userId: user.uid,
              userName: user.displayName ?? user.email ?? 'Farm Owner',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Farm'),
        elevation: 0,
      ),
      body: BlocConsumer<FarmBloc, FarmState>(
        listener: (context, state) {
          if (state is FarmOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Farm created successfully'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is FarmOperationFailure) {
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
                      Icons.agriculture,
                      size: 60,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create a New Farm',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the details of your farm',
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

                    // Submit Button
                    ElevatedButton(
                      onPressed:
                          isLoading || !_isFormValid ? null : _handleSubmit,
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
                                  'Creating...',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : const Text(
                              'Create Farm',
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
