import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../repositories/user_repository.dart';
import '../models/person_model.dart';
import 'user_event.dart';
import 'user_state.dart';

/// BLoC for managing user operations
///
/// Handles:
/// - Loading all users
/// - Searching users by email
/// - Creating new users
/// - Loading specific user details
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const UserInitial()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<SearchUsersByEmail>(_onSearchUsersByEmail);
    on<CreateUser>(_onCreateUser);
    on<LoadUserById>(_onLoadUserById);
  }

  Future<void> _onLoadAllUsers(
    LoadAllUsers event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(const UserLoading());
      final users = await _userRepository.getAllUsers();
      emit(UserListLoaded(users: users));
    } catch (e) {
      emit(UserOperationFailure(message: 'Failed to load users: ${e.toString()}'));
    }
  }

  Future<void> _onSearchUsersByEmail(
    SearchUsersByEmail event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(const UserLoading());
      final users = await _userRepository.searchUsersByEmail(event.email);
      emit(UserListLoaded(users: users));
    } catch (e) {
      emit(UserOperationFailure(
          message: 'Failed to search users: ${e.toString()}'));
    }
  }

  Future<void> _onCreateUser(
    CreateUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(const UserLoading());

      // Create user in Firebase Auth
      final userCredential = await firebase_auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user == null) {
        emit(const UserOperationFailure(message: 'Failed to create user'));
        return;
      }

      // Update display name
      await userCredential.user!.updateDisplayName(event.name);

      // Create user document in Firestore
      final newUser = Person(
        id: userCredential.user!.uid,
        email: event.email,
        name: event.name,
        username: event.email.split('@').first,
        createdAt: DateTime.now(),
      );

      await _userRepository.createUser(newUser);

      emit(const UserOperationSuccess(message: 'User created successfully'));
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Failed to create user';
      if (e.code == 'email-already-in-use') {
        message = 'Email is already in use';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      emit(UserOperationFailure(message: message));
    } catch (e) {
      emit(UserOperationFailure(message: 'Failed to create user: ${e.toString()}'));
    }
  }

  Future<void> _onLoadUserById(
    LoadUserById event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(const UserLoading());
      final user = await _userRepository.getUserById(event.userId);
      if (user != null) {
        emit(UserDetailLoaded(user: user));
      } else {
        emit(const UserOperationFailure(message: 'User not found'));
      }
    } catch (e) {
      emit(UserOperationFailure(message: 'Failed to load user: ${e.toString()}'));
    }
  }
}
