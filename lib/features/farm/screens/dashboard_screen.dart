import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/di/injection.dart';
import '../../../core/i18n/language_controller.dart';
import '../../../generated/app_localizations.dart';
import '../../authentication/bloc/auth_bloc.dart';
import '../../authentication/bloc/auth_event.dart';
import '../../authentication/bloc/user_bloc.dart';
import '../bloc/farm_bloc.dart';
import '../bloc/farm_event.dart';
import '../bloc/farm_state.dart';
import '../models/farm_model.dart';
import '../services/farm_summary_service.dart';
import '../widgets/farm_summary_card.dart';
import 'farm_create_screen.dart';
import 'farm_details_screen.dart';
import 'farm_list_screen.dart';
import '../../authentication/screens/user_list_screen.dart';

/// Main dashboard screen showing farm summaries
class DashboardScreen extends StatefulWidget {
  final LanguageController languageController;

  const DashboardScreen({
    super.key,
    required this.languageController,
  });

  static const String routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  Map<String, FarmSummary> _summaries = {};
  List<String>? _loadedFarmIds;
  FarmBloc? _farmBloc;
  RouteObserver<ModalRoute<void>>? _routeObserver;

  @override
  void initState() {
    super.initState();
    _loadFarmsIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save reference to FarmBloc for use in lifecycle callbacks
    _farmBloc = context.read<FarmBloc>();

    final navigator = Navigator.of(context);
    if (navigator.widget.observers.isNotEmpty) {
      _routeObserver = navigator.widget.observers.whereType<RouteObserver<ModalRoute<void>>>().firstOrNull;
      _routeObserver?.subscribe(this, ModalRoute.of(context)!);
    }
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // When returning to this screen (e.g., from details)
    // Use saved reference instead of accessing context
    _farmBloc?.add(const RestoreCachedFarms());
    if (mounted) {
      _loadFarmsIfNeeded();
    }
  }

  void _loadFarmsIfNeeded() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentState = context.read<FarmBloc>().state;
      // Only load farms if not already loaded or in error state
      if (currentState is FarmInitial || currentState is FarmError) {
        context.read<FarmBloc>().add(LoadFarms(userId: user.uid));
      }
    }
  }

  void _loadFarms() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<FarmBloc>().add(LoadFarms(userId: user.uid));
    }
  }

  void _handleRefresh() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<FarmBloc>().add(RefreshFarms(userId: user.uid));
    }
  }

  Future<void> _loadSummaries(List<Farm> farms) async {
    // Check if we already loaded summaries for these exact farms
    final currentFarmIds = farms.map((f) => f.id).toList()..sort();
    final loadedIds = _loadedFarmIds ?? [];

    if (_loadedFarmIds != null &&
        currentFarmIds.length == loadedIds.length &&
        currentFarmIds.every((id) => loadedIds.contains(id))) {
      return; // Already loaded summaries for these farms
    }

    _loadedFarmIds = currentFarmIds;
    final summaryService = getIt<FarmSummaryService>();
    final summaries = await summaryService.getSummaries(farms);
    if (mounted) {
      setState(() {
        _summaries = summaries;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@').first ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'View All Farms',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: context.read<FarmBloc>(),
                    child: const FarmListScreen(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Manage Users',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<UserBloc>(
                    create: (context) => getIt<UserBloc>(),
                    child: const UserListScreen(),
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            tooltip: 'User Menu',
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              } else if (value.startsWith('lang_')) {
                final languageCode = value.substring(5);
                widget.languageController.changeLanguage(languageCode);
              }
            },
            itemBuilder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.languageSettings,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'lang_en',
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.english),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'lang_es',
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.spanish),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'lang_pt',
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.portuguese),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'lang_zh',
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.mandarin),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocConsumer<FarmBloc, FarmState>(
        listener: (context, state) {
          if (state is FarmError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          } else if (state is FarmOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Operation successful'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FarmLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FarmLoaded) {
            // Load summaries when farms are loaded
            _loadSummaries(state.farms);

            if (state.farms.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _handleRefresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade700,
                            Colors.green.shade500,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, $userName!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You have ${state.farms.length} ${state.farms.length == 1 ? 'farm' : 'farms'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Stats
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildQuickStatCard(
                              icon: Icons.pets,
                              label: 'Total Cattle',
                              value: _getTotalCattle().toString(),
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickStatCard(
                              icon: Icons.category,
                              label: 'Active Lots',
                              value: _getTotalActiveLots().toString(),
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Create Farm Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (newContext) => BlocProvider.value(
                                  value: context.read<FarmBloc>(),
                                  child: const FarmCreateScreen(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create New Farm'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section Header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Your Farms',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Farm Summary Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: state.farms.length,
                      itemBuilder: (context, index) {
                        final farm = state.farms[index];
                        final summary = _summaries[farm.id];

                        return FarmSummaryCard(
                          farm: farm,
                          cattleCount: summary?.totalCattle ?? 0,
                          activeLots: summary?.activeLots ?? 0,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (newContext) => BlocProvider.value(
                                  value: context.read<FarmBloc>(),
                                  child: FarmDetailsScreen(farmId: farm.id),
                                ),
                              ),
                            );
                            // Restore cached farms when returning from detail screen
                            if (mounted) {
                              context.read<FarmBloc>().add(const RestoreCachedFarms());
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.agriculture_outlined,
              size: 120,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Farm Manager',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'You don\'t have any farms yet.\nCreate your first farm to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (newContext) => BlocProvider.value(
                      value: context.read<FarmBloc>(),
                      child: const FarmCreateScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Farm'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  int _getTotalCattle() {
    return _summaries.values.fold<int>(
      0,
      (sum, summary) => sum + summary.totalCattle,
    );
  }

  int _getTotalActiveLots() {
    return _summaries.values.fold<int>(
      0,
      (sum, summary) => sum + summary.activeLots,
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
