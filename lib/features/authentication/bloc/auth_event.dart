import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check initial authentication status
class AuthStatusRequested extends AuthEvent {
  const AuthStatusRequested();
}

/// Event for email/password login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event for user registration
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String username;
  final String? description;
  final bool isOwner;
  final bool isWorker;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.username,
    this.description,
    this.isOwner = false,
    this.isWorker = false,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        username,
        description,
        isOwner,
        isWorker,
      ];
}

/// Event for Google Sign-In
class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

/// Event for Facebook Sign-In
class AuthFacebookSignInRequested extends AuthEvent {
  const AuthFacebookSignInRequested();
}

/// Event for signing out
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event for password reset email
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event for completing SSO user profile
class AuthSSOProfileCompletionRequested extends AuthEvent {
  final String userId;
  final String email;
  final String name;
  final String username;
  final String? description;
  final bool isOwner;
  final bool isWorker;
  final String? photoURL;

  const AuthSSOProfileCompletionRequested({
    required this.userId,
    required this.email,
    required this.name,
    required this.username,
    this.description,
    required this.isOwner,
    required this.isWorker,
    this.photoURL,
  });

  @override
  List<Object?> get props => [
        userId,
        email,
        name,
        username,
        description,
        isOwner,
        isWorker,
        photoURL,
      ];
}

/// Event when authentication state changes
class AuthUserChanged extends AuthEvent {
  final dynamic user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}
