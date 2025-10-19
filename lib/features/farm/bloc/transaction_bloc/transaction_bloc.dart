import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../models/transaction_model.dart' as model;
import '../../repositories/transaction_repository.dart';
import '../../services/transaction_service.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;
  final TransactionService _transactionService;
  final Uuid _uuid;

  TransactionBloc({
    required TransactionRepository transactionRepository,
    required TransactionService transactionService,
    Uuid? uuid,
  })  : _transactionRepository = transactionRepository,
        _transactionService = transactionService,
        _uuid = uuid ?? const Uuid(),
        super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<CreateTransaction>(_onCreateTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final transactions =
          await _transactionRepository.getByLotId(event.farmId, event.lotId);
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onCreateTransaction(
      CreateTransaction event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      await _transactionService.createTransaction(event.transaction);
      emit(const TransactionOperationSuccess(message: 'Transaction created'));
    } catch (e) {
      emit(TransactionOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
      UpdateTransaction event, Emitter<TransactionState> emit) async {
    // Implement update logic, including quantity adjustments
  }

  Future<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<TransactionState> emit) async {
    // Implement delete logic, including quantity adjustments
  }
}
