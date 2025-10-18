
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

  Future<void> _selectDate(BuildContext context, bool isStart) async {
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
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final updatedLot = widget.lot!.copyWith(
          name: _nameController.text,
          cattleType: _selectedType,
          gender: _selectedGender,
          birthStart: _birthStart,
          birthEnd: _birthEnd,
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
          birthEnd: _birthEnd!,
          qtdAdded: 0, // Will be set by BLoC
          qtdRemoved: 0,
          startDate: DateTime.now(), // Will be set by BLoC
          createdAt: DateTime.now(),
        );
        _lotBloc.add(CreateLot(
          lot: newLot,
          initialQuantity: int.parse(_quantityController.text),
          initialWeight: double.tryParse(_weightController.text),
        ));
      }
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
            if (state is LotOperationSuccess) {
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
                  CattleTypeSelector(
                    selectedType: _selectedType,
                    onChanged: (type) => setState(() => _selectedType = type as CattleType?),
                  ),
                  if (_selectedType == null)
                    const Text('Please select a type', style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                  GenderSelector(
                    selectedGender: _selectedGender,
                    onGenderSelected: (gender) => setState(() => _selectedGender = gender as CattleGender),
                  ),
                  const SizedBox(height: 16),
                  const Text('Birth Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Start'),
                          subtitle: Text(_birthStart == null
                              ? 'Select Date'
                              : DateFormat.yMd().format(_birthStart!)),
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('End'),
                          subtitle: Text(_birthEnd == null
                              ? 'Select Date'
                              : DateFormat.yMd().format(_birthEnd!)),
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
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
                      label: 'Average Weight (kg, optional)',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEditMode ? 'Save Changes' : 'Create Lot'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
