
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection.dart';
import '../../authentication/widgets/custom_text_field.dart';
import '../bloc/lot_bloc/lot_bloc.dart';
import '../constants/enums.dart';
import '../models/cattle_lot_model.dart';
import '../models/farm_model.dart';
import '../widgets/cattle_type_selector.dart';
import '../widgets/gender_selector.dart';

class LotFormScreen extends StatefulWidget {
  final Farm farm;
  final CattleLot? lot;

  const LotFormScreen({super.key, required this.farm, this.lot});

  static const String routeName = '/farm/lot/form';

  @override
  State<LotFormScreen> createState() => _LotFormScreenState();
}

class _LotFormScreenState extends State<LotFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late LotBloc _lotBloc;

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _weightController;
  CattleType? _selectedType;
  CattleGender _selectedGender = CattleGender.male;
  DateTime? _birthStart;
  DateTime? _birthEnd;

  bool get isEditMode => widget.lot != null;

  @override
  void initState() {
    super.initState();
    _lotBloc = getIt<LotBloc>();
    _nameController = TextEditingController(text: widget.lot?.name);
    _quantityController = TextEditingController();
    _weightController = TextEditingController();

    if (isEditMode) {
      _selectedType = widget.lot!.cattleType;
      _selectedGender = widget.lot!.gender;
      _birthStart = widget.lot!.birthStart;
      _birthEnd = widget.lot!.birthEnd;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<DateTime?> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _birthStart : _birthEnd) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _birthStart = picked;
        } else {
          _birthEnd = picked;
        }
      });
    }
    return picked;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final updatedLot = widget.lot!.copyWith(
          name: _nameController.text,
          cattleType: _selectedType,
          gender: _selectedGender,
          birthStart: _birthStart,
          birthEnd: _birthStart, // Keep birthEnd same as birthStart
        );
        _lotBloc.add(UpdateLot(lot: updatedLot));
      } else {
        final newLot = CattleLot(
          id: const Uuid().v4(),
          farmId: widget.farm.id,
          name: _nameController.text,
          cattleType: _selectedType!,
          gender: _selectedGender,
          birthStart: _birthStart!,
          birthEnd: _birthStart!,
          qtdAdded: 0, // Will be set by BLoC
          qtdRemoved: 0,
          startDate: DateTime.now(), // Will be set by BLoC
          createdAt: DateTime.now(),
        );
        _lotBloc.add(CreateLot(
          lot: newLot,
          initialQuantity: int.parse(_quantityController.text),
          initialWeight: (double.tryParse(_weightController.text) ?? 0.0) * 15.0,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Lot' : 'Create Lot'),
      ),
      body: BlocProvider.value(
        value: _lotBloc,
        child: BlocListener<LotBloc, LotState>(
          listener: (context, state) {
            if (state is LotDeleteSuccess) {
              Navigator.of(context).pop(true);
            } else if (state is LotOperationSuccess) {
              Navigator.of(context).pop();
            }
            if (state is LotOperationFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'Lot Name',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Cattle Type', style: TextStyle(fontWeight: FontWeight.bold)),
                  FormField<CattleType>(
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CattleTypeSelector(
                            selectedType: _selectedType,
                            onChanged: (type) {
                              setState(() => _selectedType = type as CattleType?);
                              state.didChange(type);
                            },
                          ),
                          if (state.hasError) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                    validator: (value) {
                      if (_selectedType == null) {
                        return 'Please select a cattle type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                  GenderSelector(
                    selectedGender: _selectedGender,
                    onGenderSelected: (gender) => setState(() => _selectedGender = gender as CattleGender),
                  ),
                  const SizedBox(height: 16),
                  const Text('Birth Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  FormField<DateTime>(
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text('Date'),
                            subtitle: Text(_birthStart == null
                                ? 'Select Date'
                                : DateFormat.yMd().format(_birthStart!)),
                            onTap: () async {
                              final date = await _selectDate(context, true);
                              if (date != null) {
                                state.didChange(date);
                              }
                            },
                          ),
                          if (state.hasError) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                    validator: (value) {
                      if (_birthStart == null) {
                        return 'Please select a birth date';
                      }
                      return null;
                    },
                  ),
                  if (!isEditMode) ...[
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _quantityController,
                      label: 'Initial Quantity',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter a quantity';
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _weightController,
                      label: 'Average Weight (@)',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Average weight is required';
                        }
                        final weight = double.tryParse(value.trim());
                        if (weight == null) {
                          return 'Weight must be a valid number';
                        }
                        if (weight <= 0) {
                          return 'Weight must be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEditMode ? 'Save Changes' : 'Create Lot'),
                  ),
                  if (isEditMode) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.lot?.currentQuantity == 0
                          ? () {
                              _lotBloc.add(CloseLot(
                                  farmId: widget.farm.id, lotId: widget.lot!.id));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Close Lot'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => _showDeleteConfirmation(context),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Delete Lot'),
                    ),
                  ],
                ],
              ),
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
        title: const Text('Delete Lot'),
        content: const Text(
            'Are you sure you want to delete this lot? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _lotBloc.add(DeleteLot(farmId: widget.farm.id, lotId: widget.lot!.id));
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
