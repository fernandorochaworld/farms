import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/person_model.dart';
import '../repositories/farm_repository.dart';
import '../repositories/person_repository.dart';
import '../constants/enums.dart';
import 'farm_event.dart';
import 'farm_state.dart';

/// BLoC for managing farm-related operations
class FarmBloc extends Bloc<FarmEvent, FarmState> {
  final FarmRepository _farmRepository;
  final PersonRepository _personRepository;

  FarmBloc({
    required FarmRepository farmRepository,
    required PersonRepository personRepository,
  })  : _farmRepository = farmRepository,
        _personRepository = personRepository,
        super(const FarmInitial()) {
    on<LoadFarms>(_onLoadFarms);
    on<LoadFarmById>(_onLoadFarmById);
    on<CreateFarm>(_onCreateFarm);
    on<UpdateFarm>(_onUpdateFarm);
    on<DeleteFarm>(_onDeleteFarm);
    on<SearchFarms>(_onSearchFarms);
    on<FilterFarms>(_onFilterFarms);
    on<RefreshFarms>(_onRefreshFarms);
  }

  /// Handle loading all farms for a user
  Future<void> _onLoadFarms(
    LoadFarms event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmLoading());
    try {
      final farms = await _farmRepository.getByUserId(event.userId);
      emit(FarmLoaded(farms: farms));
    } catch (e) {
      emit(FarmError(message: e.toString()));
    }
  }

  /// Handle loading a single farm by ID
  Future<void> _onLoadFarmById(
    LoadFarmById event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmLoading());
    try {
      final farm = await _farmRepository.getById(event.farmId);
      emit(FarmDetailLoaded(farm: farm));
    } catch (e) {
      emit(FarmError(message: e.toString()));
    }
  }

  /// Handle creating a new farm
  Future<void> _onCreateFarm(
    CreateFarm event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmOperationInProgress());
    try {
      // Generate a new ID for the farm if not provided
      final farmId = event.farm.id.isEmpty
          ? _farmRepository.generateId()
          : event.farm.id;

      // Create farm with generated ID
      final farmWithId = event.farm.copyWith(id: farmId);
      final createdFarm = await _farmRepository.create(farmWithId);

      // Generate a new ID for the person
      final personId = _personRepository.generateId(createdFarm.id);

      // Automatically create Person record (Owner, admin)
      final person = Person(
        id: personId,
        farmId: createdFarm.id,
        userId: event.userId,
        name: event.userName,
        personType: PersonType.owner,
        isAdmin: true,
        createdAt: DateTime.now(),
      );

      await _personRepository.create(createdFarm.id, person);

      emit(FarmOperationSuccess(
        farm: createdFarm,
        message: 'Farm created successfully',
      ));

      // Reload farms list
      add(LoadFarms(userId: event.userId));
    } catch (e) {
      emit(FarmOperationFailure(message: e.toString()));
    }
  }

  /// Handle updating an existing farm
  Future<void> _onUpdateFarm(
    UpdateFarm event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmOperationInProgress());
    try {
      await _farmRepository.update(event.farm);
      emit(FarmOperationSuccess(
        farm: event.farm,
        message: 'Farm updated successfully',
      ));
    } catch (e) {
      emit(FarmOperationFailure(message: e.toString()));
    }
  }

  /// Handle deleting a farm
  Future<void> _onDeleteFarm(
    DeleteFarm event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmOperationInProgress());
    try {
      await _farmRepository.delete(event.farmId);
      emit(const FarmOperationSuccess(message: 'Farm deleted successfully'));

      // Reload farms list
      add(LoadFarms(userId: event.userId));
    } catch (e) {
      emit(FarmOperationFailure(message: e.toString()));
    }
  }

  /// Handle searching farms
  Future<void> _onSearchFarms(
    SearchFarms event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmLoading());
    try {
      final farms = await _farmRepository.getByUserId(event.userId);

      // Filter farms by search query
      final filteredFarms = farms.where((farm) {
        final query = event.query.toLowerCase();
        return farm.name.toLowerCase().contains(query) ||
            (farm.description?.toLowerCase().contains(query) ?? false);
      }).toList();

      emit(FarmLoaded(farms: filteredFarms));
    } catch (e) {
      emit(FarmError(message: e.toString()));
    }
  }

  /// Handle filtering farms
  Future<void> _onFilterFarms(
    FilterFarms event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmLoading());
    try {
      final farms = await _farmRepository.getByUserId(event.userId);

      // Sort farms based on filter
      final sortedFarms = List.of(farms);
      switch (event.sortBy) {
        case 'name':
          sortedFarms.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'date':
          sortedFarms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'capacity':
          sortedFarms.sort((a, b) => b.capacity.compareTo(a.capacity));
          break;
        default:
          // Default to date sorting
          sortedFarms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      emit(FarmLoaded(farms: sortedFarms));
    } catch (e) {
      emit(FarmError(message: e.toString()));
    }
  }

  /// Handle refreshing farms (pull-to-refresh)
  Future<void> _onRefreshFarms(
    RefreshFarms event,
    Emitter<FarmState> emit,
  ) async {
    try {
      final farms = await _farmRepository.getByUserId(event.userId);
      emit(FarmLoaded(farms: farms));
    } catch (e) {
      emit(FarmError(message: e.toString()));
    }
  }
}
