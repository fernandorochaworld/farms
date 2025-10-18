part of 'lot_bloc.dart';

abstract class LotEvent extends Equatable {
  const LotEvent();

  @override
  List<Object?> get props => [];
}

class LoadLots extends LotEvent {
  final String farmId;

  const LoadLots({required this.farmId});

  @override
  List<Object> get props => [farmId];
}

class LoadLotDetails extends LotEvent {
  final String farmId;
  final String lotId;

  const LoadLotDetails({required this.farmId, required this.lotId});

  @override
  List<Object> get props => [farmId, lotId];
}

class CreateLot extends LotEvent {
  final CattleLot lot;
  final int initialQuantity;
  final double? initialWeight;

  const CreateLot({
    required this.lot,
    required this.initialQuantity,
    this.initialWeight,
  });

  @override
  List<Object?> get props => [lot, initialQuantity, initialWeight];
}

class UpdateLot extends LotEvent {
  final CattleLot lot;

  const UpdateLot({required this.lot});

  @override
  List<Object> get props => [lot];
}

class CloseLot extends LotEvent {
  final String farmId;
  final String lotId;

  const CloseLot({required this.farmId, required this.lotId});

  @override
  List<Object> get props => [farmId, lotId];
}

class ReopenLot extends LotEvent {
  final String farmId;
  final String lotId;

  const ReopenLot({required this.farmId, required this.lotId});

  @override
  List<Object> get props => [farmId, lotId];
}

class DeleteLot extends LotEvent {
  final String farmId;
  final String lotId;

  const DeleteLot({required this.farmId, required this.lotId});

  @override
  List<Object> get props => [farmId, lotId];
}

class SearchLots extends LotEvent {
  final String query;
  final List<CattleLot> lots;

  const SearchLots({required this.query, required this.lots});

  @override
  List<Object> get props => [query, lots];
}

class FilterLots extends LotEvent {
  final CattleType? cattleType;
  final CattleGender? gender;
  final LotStatus? status;
  final List<CattleLot> lots;

  const FilterLots({
    this.cattleType,
    this.gender,
    this.status,
    required this.lots,
  });

  @override
  List<Object?> get props => [cattleType, gender, status, lots];
}
