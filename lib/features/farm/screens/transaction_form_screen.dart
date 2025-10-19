import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection.dart';
import '../../authentication/widgets/custom_text_field.dart';
import '../bloc/transaction_bloc/transaction_bloc.dart';
import '../constants/enums.dart';
import '../models/cattle_lot_model.dart';
import '../models/transaction_model.dart' as model;

class TransactionFormScreen extends StatefulWidget {
  final CattleLot lot;
  final TransactionType type;

  const TransactionFormScreen({super.key, required this.lot, required this.type});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TransactionBloc _transactionBloc;

  late TextEditingController _quantityController;
  late TextEditingController _weightController;
  late TextEditingController _valueController;
  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _transactionBloc = getIt<TransactionBloc>();
    _quantityController = TextEditingController();
    _weightController = TextEditingController();
    _valueController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _weightController.dispose();
    _valueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final transaction = model.Transaction(
        id: const Uuid().v4(),
        lotId: widget.lot.id,
        farmId: widget.lot.farmId,
        type: widget.type,
        quantity: int.parse(_quantityController.text),
        averageWeight: double.tryParse(_weightController.text) ?? 0,
        value: double.tryParse(_valueController.text) ?? 0,
        description: _descriptionController.text,
        date: _selectedDate,
        createdAt: DateTime.now(),
        createdBy: 'system', // TODO: Get current user
      );
      _transactionBloc.add(CreateTransaction(transaction: transaction));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New ${widget.type.label} Transaction'),
      ),
      body: BlocProvider.value(
        value: _transactionBloc,
        child: BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionOperationSuccess) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            if (state is TransactionOperationFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _quantityController,
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _weightController,
                    label: 'Average Weight (@)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _valueController,
                    label: 'Total Value',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Transaction Date'),
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
                    child: const Text('Add Transaction'),
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
