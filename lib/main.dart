import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/i18n/language_controller.dart';
import 'features/authentication/bloc/auth_bloc.dart';
import 'features/authentication/bloc/auth_event.dart';
import 'features/authentication/bloc/auth_state.dart';
import 'features/authentication/repositories/user_repository.dart';
import 'features/authentication/screens/login_screen.dart';
import 'features/authentication/screens/sso_profile_completion_screen.dart';
import 'features/farm/bloc/farm_bloc.dart';
import 'features/farm/screens/dashboard_screen.dart';
import 'firebase_options.dart';
import 'generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup dependency injection
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageController _languageController = LanguageController();

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        userRepository: getIt<UserRepository>(),
      )..add(const AuthStatusRequested()),
      child: AnimatedBuilder(
        animation: _languageController,
        builder: (context, child) {
          return MaterialApp(
            title: 'Farms',
            navigatorObservers: [RouteObserver<ModalRoute<void>>()],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('pt'),
              Locale('zh'),
            ],
            locale: _languageController.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
            home: AuthGate(languageController: _languageController),
          );
        },
      ),
    );
  }
}

/// Authentication gate that routes to appropriate screen based on auth state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.languageController});

  final LanguageController languageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          // Show loading screen while checking auth status
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          // User is authenticated, show dashboard screen
          return BlocProvider<FarmBloc>(
            create: (context) => getIt<FarmBloc>(),
            child: DashboardScreen(languageController: languageController),
          );
        } else if (state is AuthSSOProfileCompletionRequired) {
          // SSO user needs to complete profile
          return SSOProfileCompletionScreen(
            userId: state.userId,
            email: state.email,
            name: state.name,
            photoURL: state.photoURL,
          );
        } else {
          // User is not authenticated, show login screen
          return const LoginScreen();
        }
      },
    );
  }
}
