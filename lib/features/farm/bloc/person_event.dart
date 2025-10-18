import 'package:equatable/equatable.dart';
import '../models/person_model.dart';

/// Base class for all person-related events
abstract class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all people for a farm
class LoadPeople extends PersonEvent {
  final String farmId;

  const LoadPeople({required this.farmId});

  @override
  List<Object?> get props => [farmId];
}

/// Event to load a single person by ID
class LoadPersonDetails extends PersonEvent {
  final String farmId;
  final String personId;

  const LoadPersonDetails({
    required this.farmId,
    required this.personId,
  });

  @override
  List<Object?> get props => [farmId, personId];
}

/// Event to create a new person
class CreatePerson extends PersonEvent {
  final String farmId;
  final Person person;

  const CreatePerson({
    required this.farmId,
    required this.person,
  });

  @override
  List<Object?> get props => [farmId, person];
}

/// Event to update an existing person
class UpdatePerson extends PersonEvent {
  final String farmId;
  final Person person;

  const UpdatePerson({
    required this.farmId,
    required this.person,
  });

  @override
  List<Object?> get props => [farmId, person];
}

/// Event to remove a person from the farm
class RemovePerson extends PersonEvent {
  final String farmId;
  final String personId;
  final String currentUserId;

  const RemovePerson({
    required this.farmId,
    required this.personId,
    required this.currentUserId,
  });

  @override
  List<Object?> get props => [farmId, personId, currentUserId];
}

/// Event to search users by email
class SearchUsers extends PersonEvent {
  final String email;

  const SearchUsers({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to search people within a farm
class SearchPeople extends PersonEvent {
  final String farmId;
  final String query;

  const SearchPeople({
    required this.farmId,
    required this.query,
  });

  @override
  List<Object?> get props => [farmId, query];
}

/// Event to filter people by person type
class FilterPeople extends PersonEvent {
  final String farmId;
  final String? personType;

  const FilterPeople({
    required this.farmId,
    this.personType,
  });

  @override
  List<Object?> get props => [farmId, personType];
}

/// Event to refresh people list (pull-to-refresh)
class RefreshPeople extends PersonEvent {
  final String farmId;

  const RefreshPeople({required this.farmId});

  @override
  List<Object?> get props => [farmId];
}

/// Event to check if a person can be removed
class CheckCanRemovePerson extends PersonEvent {
  final String farmId;
  final String personId;

  const CheckCanRemovePerson({
    required this.farmId,
    required this.personId,
  });

  @override
  List<Object?> get props => [farmId, personId];
}
