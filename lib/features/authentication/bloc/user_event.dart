import 'package:equatable/equatable.dart';

/// Base class for all user-related events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all users
class LoadAllUsers extends UserEvent {
  const LoadAllUsers();
}

/// Event to search users by email
class SearchUsersByEmail extends UserEvent {
  final String email;

  const SearchUsersByEmail({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to create a new user
class CreateUser extends UserEvent {
  final String email;
  final String name;
  final String password;

  const CreateUser({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, password];
}

/// Event to load a specific user by ID
class LoadUserById extends UserEvent {
  final String userId;

  const LoadUserById({required this.userId});

  @override
  List<Object?> get props => [userId];
}
