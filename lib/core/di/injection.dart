import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/authentication/repositories/firebase_user_repository.dart';
import '../../features/authentication/repositories/user_repository.dart';
import '../../features/authentication/services/facebook_auth_service.dart';
import '../../features/authentication/services/google_auth_service.dart';
import '../../shared/services/token_storage_service.dart';

final getIt = GetIt.instance;

/// Setup all dependency injection for the application
/// Call this method once during app initialization
void setupDependencies() {
  // Firebase instances
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Auth services
  getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
  getIt.registerLazySingleton<FacebookAuthService>(
      () => FacebookAuthService());

  // Storage
  getIt.registerLazySingleton<TokenStorageService>(
      () => TokenStorageService());

  // Repository
  getIt.registerLazySingleton<UserRepository>(
    () => FirebaseUserRepository(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      googleAuthService: getIt<GoogleAuthService>(),
      facebookAuthService: getIt<FacebookAuthService>(),
    ),
  );
}
