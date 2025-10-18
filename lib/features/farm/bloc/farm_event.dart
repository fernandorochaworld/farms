import 'package:equatable/equatable.dart';
import '../models/farm_model.dart';

/// Base class for all farm events
abstract class FarmEvent extends Equatable {
  const FarmEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all farms for a user
class LoadFarms extends FarmEvent {
  final String userId;

  const LoadFarms({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to load a single farm by ID
class LoadFarmById extends FarmEvent {
  final String farmId;

  const LoadFarmById({required this.farmId});

  @override
  List<Object?> get props => [farmId];
}

/// Event to create a new farm
class CreateFarm extends FarmEvent {
  final Farm farm;
  final String userId;
  final String userName;

  const CreateFarm({
    required this.farm,
    required this.userId,
    required this.userName,
  });

  @override
  List<Object?> get props => [farm, userId, userName];
}

/// Event to update an existing farm
class UpdateFarm extends FarmEvent {
  final Farm farm;

  const UpdateFarm({required this.farm});

  @override
  List<Object?> get props => [farm];
}

/// Event to delete a farm
class DeleteFarm extends FarmEvent {
  final String farmId;
  final String userId;

  const DeleteFarm({required this.farmId, required this.userId});

  @override
  List<Object?> get props => [farmId, userId];
}

/// Event to search farms
class SearchFarms extends FarmEvent {
  final String userId;
  final String query;

  const SearchFarms({required this.userId, required this.query});

  @override
  List<Object?> get props => [userId, query];
}

/// Event to filter farms
class FilterFarms extends FarmEvent {
  final String userId;
  final String? sortBy; // 'name', 'date', 'capacity'

  const FilterFarms({required this.userId, this.sortBy});

  @override
  List<Object?> get props => [userId, sortBy];
}

/// Event to refresh farms (pull-to-refresh)
class RefreshFarms extends FarmEvent {
  final String userId;

  const RefreshFarms({required this.userId});

  @override
  List<Object?> get props => [userId];
}
