part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final String farmId;
  final String lotId;

  const LoadTransactions({required this.farmId, required this.lotId});

  @override
  List<Object> get props => [farmId, lotId];
}

class CreateTransaction extends TransactionEvent {
  final model.Transaction transaction;

  const CreateTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  final model.Transaction transaction;

  const UpdateTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final model.Transaction transaction;

  const DeleteTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}
