import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/authentication/repositories/firebase_user_repository.dart';
import '../../features/authentication/repositories/user_repository.dart';
import '../../features/authentication/services/facebook_auth_service.dart';
import '../../features/authentication/services/google_auth_service.dart';
import '../../features/farm/repositories/cattle_lot_repository.dart';
import '../../features/farm/repositories/farm_repository.dart';
import '../../features/farm/repositories/farm_service_repository.dart';
import '../../features/farm/repositories/firebase_cattle_lot_repository.dart';
import '../../features/farm/repositories/firebase_farm_repository.dart';
import '../../features/farm/repositories/firebase_farm_service_repository.dart';
import '../../features/farm/repositories/firebase_goal_repository.dart';
import '../../features/farm/repositories/firebase_person_repository.dart';
import '../../features/farm/repositories/firebase_transaction_repository.dart';
import '../../features/farm/repositories/firebase_weight_history_repository.dart';
import '../../features/farm/repositories/goal_repository.dart';
import '../../features/farm/repositories/person_repository.dart';
import '../../features/farm/repositories/transaction_repository.dart';
import '../../features/farm/repositories/weight_history_repository.dart';
import '../../features/farm/services/firestore_service.dart';
import '../../features/farm/services/farm_summary_service.dart';
import '../../features/farm/bloc/farm_bloc.dart';
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

  // Firestore service helper
  getIt.registerLazySingleton<FirestoreService>(
    () => FirestoreService(firestore: getIt<FirebaseFirestore>()),
  );

  // Authentication Repository
  getIt.registerLazySingleton<UserRepository>(
    () => FirebaseUserRepository(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      googleAuthService: getIt<GoogleAuthService>(),
      facebookAuthService: getIt<FacebookAuthService>(),
    ),
  );

  // ============================================================================
  // Farm Feature Repositories
  // ============================================================================

  // Farm Repository
  getIt.registerLazySingleton<FarmRepository>(
    () => FirebaseFarmRepository(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Person Repository
  getIt.registerLazySingleton<PersonRepository>(
    () => FirebasePersonRepository(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Cattle Lot Repository
  getIt.registerLazySingleton<CattleLotRepository>(
    () => FirebaseCattleLotRepository(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Transaction Repository
  getIt.registerLazySingleton<TransactionRepository>(
    () => FirebaseTransactionRepository(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Weight History Repository
  getIt.registerLazySingleton<WeightHistoryRepository>(
    () => FirebaseWeightHistoryRepository(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Goal Repository
  getIt.registerLazySingleton<GoalRepository>(
    () => FirebaseGoalRepository(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Farm Service Repository
  getIt.registerLazySingleton<FarmServiceRepository>(
    () => FirebaseFarmServiceRepository(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // ============================================================================
  // Farm Feature Services
  // ============================================================================

  // Farm Summary Service
  getIt.registerLazySingleton<FarmSummaryService>(
    () => FarmSummaryService(
      lotRepository: getIt<CattleLotRepository>(),
      transactionRepository: getIt<TransactionRepository>(),
    ),
  );

  // ============================================================================
  // Farm Feature BLoCs
  // ============================================================================

  // Farm BLoC - using factory so each screen gets a new instance
  getIt.registerFactory<FarmBloc>(
    () => FarmBloc(
      farmRepository: getIt<FarmRepository>(),
      personRepository: getIt<PersonRepository>(),
    ),
  );
}
