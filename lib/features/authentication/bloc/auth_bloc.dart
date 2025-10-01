import 'dart:async';

import 'package:bloc/bloc.dart';

import '../models/person_model.dart';
import '../repositories/user_repository.dart';
import '../utils/auth_error_messages.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state and events
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  StreamSubscription<Person?>? _authStateSubscription;

  AuthBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const AuthInitial()) {
    // Register event handlers
    on<AuthStatusRequested>(_onAuthStatusRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthFacebookSignInRequested>(_onAuthFacebookSignInRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthUserChanged>(_onAuthUserChanged);

    // Listen to authentication state changes
    _authStateSubscription = _userRepository.authStateChanges().listen(
          (user) => add(AuthUserChanged(user)),
        );
  }

  /// Handle authentication status check
  Future<void> _onAuthStatusRequested(
    AuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle email/password login
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _userRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(AuthErrorMessages.getErrorMessage(e)));
    }
  }

  /// Handle user registration
  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _userRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        name: event.name,
        username: event.username,
        description: event.description,
        isOwner: event.isOwner,
        isWorker: event.isWorker,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(AuthErrorMessages.getErrorMessage(e)));
    }
  }

  /// Handle Google Sign-In
  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _userRepository.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      final errorMessage = AuthErrorMessages.getErrorMessage(e);
      // Don't show error for user cancellation
      if (errorMessage.isEmpty) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthFailure(errorMessage));
      }
    }
  }

  /// Handle Facebook Sign-In
  Future<void> _onAuthFacebookSignInRequested(
    AuthFacebookSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _userRepository.signInWithFacebook();
      emit(AuthAuthenticated(user));
    } catch (e) {
      final errorMessage = AuthErrorMessages.getErrorMessage(e);
      // Don't show error for user cancellation
      if (errorMessage.isEmpty) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthFailure(errorMessage));
      }
    }
  }

  /// Handle logout
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _userRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(AuthErrorMessages.getErrorMessage(e)));
    }
  }

  /// Handle password reset request
  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _userRepository.sendPasswordResetEmail(event.email);
      emit(const AuthPasswordResetSent());
    } catch (e) {
      emit(AuthFailure(AuthErrorMessages.getErrorMessage(e)));
    }
  }

  /// Handle authentication state changes from repository
  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
