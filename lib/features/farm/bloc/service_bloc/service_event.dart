part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadServices extends ServiceEvent {
  final String farmId;

  const LoadServices({required this.farmId});

  @override
  List<Object> get props => [farmId];
}

class AddService extends ServiceEvent {
  final FarmServiceHistory service;

  const AddService({required this.service});

  @override
  List<Object> get props => [service];
}

class UpdateService extends ServiceEvent {
  final FarmServiceHistory service;

  const UpdateService({required this.service});

  @override
  List<Object> get props => [service];
}

class DeleteService extends ServiceEvent {
  final FarmServiceHistory service;

  const DeleteService({required this.service});

  @override
  List<Object> get props => [service];
}
