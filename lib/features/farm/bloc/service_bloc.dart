import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../models/farm_service_history_model.dart';
import '../repositories/farm_service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final FarmServiceRepository _serviceRepository;
  final Uuid _uuid;

  ServiceBloc({
    required FarmServiceRepository serviceRepository,
    Uuid? uuid,
  })  : _serviceRepository = serviceRepository,
        _uuid = uuid ?? const Uuid(),
        super(ServiceInitial()) {
    on<LoadServices>(_onLoadServices);
    on<AddService>(_onAddService);
    on<UpdateService>(_onUpdateService);
    on<DeleteService>(_onDeleteService);
  }

  Future<void> _onLoadServices(LoadServices event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    try {
      final services = await _serviceRepository.getByFarmId(event.farmId);
      emit(ServiceLoaded(services: services));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
    }
  }

  Future<void> _onAddService(AddService event, Emitter<ServiceState> emit) async {
    try {
      await _serviceRepository.create(event.service.farmId, event.service);
      add(LoadServices(farmId: event.service.farmId));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
    }
  }

  Future<void> _onUpdateService(UpdateService event, Emitter<ServiceState> emit) async {
    try {
      await _serviceRepository.update(event.service.farmId, event.service);
      add(LoadServices(farmId: event.service.farmId));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
    }
  }

  Future<void> _onDeleteService(DeleteService event, Emitter<ServiceState> emit) async {
    try {
      await _serviceRepository.delete(event.service.farmId, event.service.id);
      add(LoadServices(farmId: event.service.farmId));
    } catch (e) {
      emit(ServiceError(message: e.toString()));
    }
  }
}