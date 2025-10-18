import 'package:equatable/equatable.dart';
import '../models/person_model.dart';
import '../../authentication/models/person_model.dart' as auth;

/// Base class for all person-related states
abstract class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object?> get props => [];
}

/// Initial state when PersonBloc is created
class PersonInitial extends PersonState {
  const PersonInitial();
}

/// State when loading people
class PersonLoading extends PersonState {
  const PersonLoading();
}

/// State when people are successfully loaded
class PersonLoaded extends PersonState {
  final List<Person> people;

  const PersonLoaded({required this.people});

  @override
  List<Object?> get props => [people];
}

/// State when a single person's details are loaded
class PersonDetailLoaded extends PersonState {
  final Person person;

  const PersonDetailLoaded({required this.person});

  @override
  List<Object?> get props => [person];
}

/// State when an error occurs
class PersonError extends PersonState {
  final String message;

  const PersonError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when a person operation is in progress (create, update, delete)
class PersonOperationInProgress extends PersonState {
  const PersonOperationInProgress();
}

/// State when a person operation succeeds
class PersonOperationSuccess extends PersonState {
  final String message;
  final Person? person;

  const PersonOperationSuccess({
    required this.message,
    this.person,
  });

  @override
  List<Object?> get props => [message, person];
}

/// State when a person operation fails
class PersonOperationFailure extends PersonState {
  final String message;

  const PersonOperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when user search results are available
class UserSearchResults extends PersonState {
  final List<auth.Person> users;

  const UserSearchResults({required this.users});

  @override
  List<Object?> get props => [users];
}

/// State when checking if a person can be removed
class PersonRemovalCheck extends PersonState {
  final bool canRemove;
  final String? reason;

  const PersonRemovalCheck({
    required this.canRemove,
    this.reason,
  });

  @override
  List<Object?> get props => [canRemove, reason];
}
