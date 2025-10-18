import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/cattle_lot_model.dart';
import '../../models/transaction_model.dart' as farm_transaction;
import '../../models/weight_history_model.dart';
import '../../repositories/cattle_lot_repository.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/weight_history_repository.dart';
import '../../constants/enums.dart';

part 'lot_event.dart';
part 'lot_state.dart';

class LotBloc extends Bloc<LotEvent, LotState> {
  final CattleLotRepository _lotRepository;
  final TransactionRepository _transactionRepository;
  final WeightHistoryRepository _weightHistoryRepository;
  final Uuid _uuid;

  LotBloc({
    required CattleLotRepository lotRepository,
    required TransactionRepository transactionRepository,
    required WeightHistoryRepository weightHistoryRepository,
    Uuid? uuid,
  })  : _lotRepository = lotRepository,
        _transactionRepository = transactionRepository,
        _weightHistoryRepository = weightHistoryRepository,
        _uuid = uuid ?? const Uuid(),
        super(LotInitial()) {
    on<LoadLots>(_onLoadLots);
    on<LoadLotDetails>(_onLoadLotDetails);
    on<CreateLot>(_onCreateLot);
    on<UpdateLot>(_onUpdateLot);
    on<CloseLot>(_onCloseLot);
    on<ReopenLot>(_onReopenLot);
    on<DeleteLot>(_onDeleteLot);
    on<SearchLots>(_onSearchLots);
    on<FilterLots>(_onFilterLots);
  }

  Future<void> _onLoadLots(LoadLots event, Emitter<LotState> emit) async {
    emit(LotLoading());
    try {
      final lots = await _lotRepository.getByFarmId(event.farmId);
      emit(LotLoaded(lots: lots));
    } catch (e) {
      emit(LotError(message: 'Failed to load lots: ${e.toString()}'));
    }
  }

  Future<void> _onLoadLotDetails(
      LoadLotDetails event, Emitter<LotState> emit) async {
    emit(LotLoading());
    try {
      final lot = await _lotRepository.getById(event.farmId, event.lotId);
      // TODO: Load transactions and weight history
      emit(LotDetailsLoaded(lot: lot));
    } catch (e) {
      emit(LotError(message: 'Failed to load lot details: ${e.toString()}'));
    }
  }

  Future<void> _onCreateLot(CreateLot event, Emitter<LotState> emit) async {
    emit(LotOperationInProgress());
    try {
      final now = DateTime.now();
      final lotId = _uuid.v4();

      final newLot = event.lot.copyWith(
        id: lotId,
        qtdAdded: event.initialQuantity,
        qtdRemoved: 0,
        startDate: now,
        createdAt: now,
      );

      // Create initial transaction
      final initialTransaction = farm_transaction.Transaction(
        id: _uuid.v4(),
        farmId: newLot.farmId,
        lotId: lotId,
        type: TransactionType.buy,
        date: now,
        quantity: event.initialQuantity,
        averageWeight: event.initialWeight ?? 0,
        value: 0,
        description: 'Initial lot creation',
        createdAt: now,
        createdBy: 'system', // TODO: Replace with actual user ID
      );

      await _lotRepository.create(newLot.farmId, newLot);
      await _transactionRepository.create(
          newLot.farmId, lotId, initialTransaction);

      // Create initial weight history if provided
      if (event.initialWeight != null && event.initialWeight! > 0) {
        final weightRecord = WeightHistory(
          id: _uuid.v4(),
          lotId: lotId,
          averageWeight: event.initialWeight!,
          date: now,
          createdAt: now,
          createdBy: 'system', // TODO: Replace with actual user ID
        );
        await _weightHistoryRepository.create(
            newLot.farmId, lotId, weightRecord);
      }

      emit(const LotOperationSuccess(message: 'Lot created successfully'));
    } catch (e) {
      emit(LotOperationFailure(
          message: 'Failed to create lot: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateLot(UpdateLot event, Emitter<LotState> emit) async {
    emit(LotOperationInProgress());
    try {
      final updatedLot = event.lot.copyWith(updatedAt: DateTime.now());
      await _lotRepository.update(updatedLot.farmId, updatedLot);
      emit(const LotOperationSuccess(message: 'Lot updated successfully'));
    } catch (e) {
      emit(LotOperationFailure(
          message: 'Failed to update lot: ${e.toString()}'));
    }
  }

  Future<void> _onCloseLot(CloseLot event, Emitter<LotState> emit) async {
    emit(LotOperationInProgress());
    try {
      final lot = await _lotRepository.getById(event.farmId, event.lotId);
      final updatedLot = lot.copyWith(endDate: DateTime.now());
      await _lotRepository.update(event.farmId, updatedLot);
      emit(const LotOperationSuccess(message: 'Lot closed successfully'));
    } catch (e) {
      emit(LotOperationFailure(
          message: 'Failed to close lot: ${e.toString()}'));
    }
  }

  Future<void> _onReopenLot(ReopenLot event, Emitter<LotState> emit) async {
    emit(LotOperationInProgress());
    try {
      final lot = await _lotRepository.getById(event.farmId, event.lotId);
      final updatedLot = lot.copyWith(endDate: null);
      await _lotRepository.update(event.farmId, updatedLot);
      emit(const LotOperationSuccess(message: 'Lot reopened successfully'));
    } catch (e) {
      emit(LotOperationFailure(
          message: 'Failed to reopen lot: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteLot(DeleteLot event, Emitter<LotState> emit) async {
    emit(LotOperationInProgress());
    try {
      final transactions = await _transactionRepository.getByLotId(event.farmId, event.lotId);
      if (transactions.length > 1) {
        emit(const LotOperationFailure(message: 'Cannot delete a lot with existing transactions.'));
        return;
      }

      await _lotRepository.delete(event.farmId, event.lotId);
      emit(LotDeleteSuccess());
    } catch (e) {
      emit(LotOperationFailure(
          message: 'Failed to delete lot: ${e.toString()}'));
    }
  }

  void _onSearchLots(SearchLots event, Emitter<LotState> emit) {
    final filtered = event.lots
        .where((lot) =>
            lot.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(LotLoaded(lots: event.lots, filteredLots: filtered));
  }

  void _onFilterLots(FilterLots event, Emitter<LotState> emit) {
    var filtered = event.lots;

    if (event.cattleType != null) {
      filtered =
          filtered.where((lot) => lot.cattleType == event.cattleType).toList();
    }
    if (event.gender != null) {
      filtered = filtered.where((lot) => lot.gender == event.gender).toList();
    }
    if (event.status != null) {
      if (event.status == LotStatus.active) {
        filtered = filtered.where((lot) => lot.isActive).toList();
      } else {
        filtered = filtered.where((lot) => lot.isClosed).toList();
      }
    }

    emit(LotLoaded(lots: event.lots, filteredLots: filtered));
  }
}
