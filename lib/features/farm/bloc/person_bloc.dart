import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/person_model.dart';
import '../repositories/person_repository.dart';
import '../constants/enums.dart';
import 'person_event.dart';
import 'person_state.dart';
import '../../authentication/repositories/user_repository.dart';

/// BLoC for managing person-related operations
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository _personRepository;
  final UserRepository _userRepository;

  PersonBloc({
    required PersonRepository personRepository,
    required UserRepository userRepository,
  })  : _personRepository = personRepository,
        _userRepository = userRepository,
        super(const PersonInitial()) {
    on<LoadPeople>(_onLoadPeople);
    on<LoadPersonDetails>(_onLoadPersonDetails);
    on<CreatePerson>(_onCreatePerson);
    on<UpdatePerson>(_onUpdatePerson);
    on<RemovePerson>(_onRemovePerson);
    on<SearchUsers>(_onSearchUsers);
    on<SearchPeople>(_onSearchPeople);
    on<FilterPeople>(_onFilterPeople);
    on<RefreshPeople>(_onRefreshPeople);
    on<CheckCanRemovePerson>(_onCheckCanRemovePerson);
  }

  /// Handle loading all people for a farm
  Future<void> _onLoadPeople(
    LoadPeople event,
    Emitter<PersonState> emit,
  ) async {
    emit(const PersonLoading());
    try {
      final people = await _personRepository.getByFarmId(event.farmId);
      emit(PersonLoaded(people: people));
    } catch (e) {
      emit(PersonError(message: e.toString()));
    }
  }

  /// Handle loading a single person by ID
  Future<void> _onLoadPersonDetails(
    LoadPersonDetails event,
    Emitter<PersonState> emit,
  ) async {
    emit(const PersonLoading());
    try {
      final person = await _personRepository.getById(
        event.farmId,
        event.personId,
      );
      emit(PersonDetailLoaded(person: person));
    } catch (e) {
      emit(PersonError(message: e.toString()));
    }
  }

  /// Handle creating a new person
  Future<void> _onCreatePerson(
    CreatePerson event,
    Emitter<PersonState> emit,
  ) async {
    emit(const PersonOperationInProgress());
    try {
      // Validate person data
      final validationError = event.person.validate();
      if (validationError != null) {
        emit(PersonOperationFailure(message: validationError));
        return;
      }

      // Check if user is already a member of this farm
      final existingPerson = await _personRepository.getByUserIdInFarm(
        event.farmId,
        event.person.userId,
      );

      if (existingPerson != null) {
        emit(const PersonOperationFailure(
          message: 'User is already a member of this farm',
        ));
        return;
      }

      // Generate ID if not provided
      final personId = event.person.id.isEmpty
          ? _personRepository.generateId(event.farmId)
          : event.person.id;

      // Create person with generated ID
      final personWithId = event.person.copyWith(id: personId);
      final createdPerson = await _personRepository.create(
        event.farmId,
        personWithId,
      );

      emit(PersonOperationSuccess(
        person: createdPerson,
        message: 'Person added successfully',
      ));

      // Reload people list
      add(LoadPeople(farmId: event.farmId));
    } catch (e) {
      emit(PersonOperationFailure(message: e.toString()));
    }
  }

  /// Handle updating an existing person
  Future<void> _onUpdatePerson(
    UpdatePerson event,
    Emitter<PersonState> emit,
  ) async {
    emit(const PersonOperationInProgress());
    try {
      // Validate person data
      final validationError = event.person.validate();
      if (validationError != null) {
        emit(PersonOperationFailure(message: validationError));
        return;
      }

      // If changing from owner to another type, ensure at least one owner remains
      final currentPerson = await _personRepository.getById(
        event.farmId,
        event.person.id,
      );

      if (currentPerson.personType == PersonType.owner &&
          event.person.personType != PersonType.owner) {
        final allPeople = await _personRepository.getByFarmId(event.farmId);
        final ownerCount = allPeople
            .where((p) => p.personType == PersonType.owner)
            .length;

        if (ownerCount <= 1) {
          emit(const PersonOperationFailure(
            message: 'Cannot change type: at least one owner is required',
          ));
          return;
        }
      }

      await _personRepository.update(event.farmId, event.person);
      emit(PersonOperationSuccess(
        person: event.person,
        message: 'Person updated successfully',
      ));

      // Reload people list
      add(LoadPeople(farmId: event.farmId));
    } catch (e) {
      emit(PersonOperationFailure(message: e.toString()));
    }
  }

  /// Handle removing a person from the farm
  Future<void> _onRemovePerson(
    RemovePerson event,
    Emitter<PersonState> emit,
  ) async {
    emit(const PersonOperationInProgress());
    try {
      // Get the person to be removed
      final person = await _personRepository.getById(
        event.farmId,
        event.personId,
      );

      // Check if person is an owner
      if (person.personType == PersonType.owner) {
        final allPeople = await _personRepository.getByFarmId(event.farmId);
        final ownerCount = allPeople
            .where((p) => p.personType == PersonType.owner)
            .length;

        if (ownerCount <= 1) {
          emit(const PersonOperationFailure(
            message: 'Cannot remove: at least one owner is required',
          ));
          return;
        }
      }

      await _personRepository.delete(event.farmId, event.personId);
      emit(const PersonOperationSuccess(message: 'Person removed successfully'));

      // Reload people list
      add(LoadPeople(farmId: event.farmId));
    } catch (e) {
      emit(PersonOperationFailure(message: e.toString()));
    }
  }

  /// Handle searching users by email
  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<PersonState> emit,
  ) async {
    if (event.email.trim().isEmpty) {
      emit(const UserSearchResults(users: []));
      return;
    }

    try {
      final users = await _userRepository.searchUsersByEmail(event.email);
      emit(UserSearchResults(users: users));
    } catch (e) {
      emit(PersonError(message: e.toString()));
    }
  }

  /// Handle searching people within a farm
  Future<void> _onSearchPeople(
    SearchPeople event,
    Emitter<PersonState> emit,
  ) async {
    emit(const PersonLoading());
    try {
      final people = await _personRepository.getByFarmId(event.farmId);

      // Filter people by search query
      final filteredPeople = people.where((person) {
        final query = event.query.toLowerCase();
        return person.name.toLowerCase().contains(query) ||
            (person.description?.toLowerCase().contains(query) ?? false) ||
            person.personType.label.toLowerCase().contains(query);
      }).toList();

      emit(PersonLoaded(people: filteredPeople));
    } catch (e) {
      emit(PersonError(message: e.toString()));
    }
  }

  /// Handle filtering people by person type
  Future<void> _onFilterPeople(
    FilterPeople event,
    Emitter<PersonState> emit,
  ) async {
    emit(const PersonLoading());
    try {
      final people = await _personRepository.getByFarmId(event.farmId);

      // Filter people by type if specified
      final filteredPeople = event.personType == null
          ? people
          : people.where((person) {
              return person.personType.name == event.personType;
            }).toList();

      emit(PersonLoaded(people: filteredPeople));
    } catch (e) {
      emit(PersonError(message: e.toString()));
    }
  }

  /// Handle refreshing people list (pull-to-refresh)
  Future<void> _onRefreshPeople(
    RefreshPeople event,
    Emitter<PersonState> emit,
  ) async {
    try {
      final people = await _personRepository.getByFarmId(event.farmId);
      emit(PersonLoaded(people: people));
    } catch (e) {
      emit(PersonError(message: e.toString()));
    }
  }

  /// Handle checking if a person can be removed
  Future<void> _onCheckCanRemovePerson(
    CheckCanRemovePerson event,
    Emitter<PersonState> emit,
  ) async {
    try {
      final person = await _personRepository.getById(
        event.farmId,
        event.personId,
      );

      // Check if person is the last owner
      if (person.personType == PersonType.owner) {
        final allPeople = await _personRepository.getByFarmId(event.farmId);
        final ownerCount = allPeople
            .where((p) => p.personType == PersonType.owner)
            .length;

        if (ownerCount <= 1) {
          emit(const PersonRemovalCheck(
            canRemove: false,
            reason: 'Cannot remove the last owner',
          ));
          return;
        }
      }

      emit(const PersonRemovalCheck(canRemove: true));
    } catch (e) {
      emit(PersonError(message: e.toString()));
    }
  }
}
