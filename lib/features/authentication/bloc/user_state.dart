import 'package:equatable/equatable.dart';
import '../models/person_model.dart';

/// Base class for all user-related states
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any user operations
class UserInitial extends UserState {
  const UserInitial();
}

/// State when user operations are in progress
class UserLoading extends UserState {
  const UserLoading();
}

/// State when user list has been loaded
class UserListLoaded extends UserState {
  final List<Person> users;

  const UserListLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

/// State when a specific user has been loaded
class UserDetailLoaded extends UserState {
  final Person user;

  const UserDetailLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when a user operation succeeds
class UserOperationSuccess extends UserState {
  final String message;

  const UserOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when a user operation fails
class UserOperationFailure extends UserState {
  final String message;

  const UserOperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
