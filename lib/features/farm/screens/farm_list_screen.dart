import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/di/injection.dart';
import '../bloc/farm_bloc.dart';
import '../bloc/farm_event.dart';
import '../bloc/farm_state.dart';
import '../models/farm_model.dart';
import '../services/farm_summary_service.dart';
import '../widgets/farm_card.dart';
import 'farm_create_screen.dart';
import 'farm_edit_screen.dart';
import 'farm_details_screen.dart';

/// Screen displaying a list of all farms for the current user
class FarmListScreen extends StatefulWidget {
  const FarmListScreen({super.key});

  static const String routeName = '/farms';

  @override
  State<FarmListScreen> createState() => _FarmListScreenState();
}

class _FarmListScreenState extends State<FarmListScreen> {
  final _searchController = TextEditingController();
  String _sortBy = 'date'; // 'name', 'date', 'capacity'
  Map<String, FarmSummary> _summaries = {};

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFarms() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<FarmBloc>().add(LoadFarms(userId: user.uid));
    }
  }

  void _handleSearch(String query) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (query.trim().isEmpty) {
        context.read<FarmBloc>().add(LoadFarms(userId: user.uid));
      } else {
        context.read<FarmBloc>().add(SearchFarms(userId: user.uid, query: query));
      }
    }
  }

  void _handleSort(String? sortBy) {
    if (sortBy != null) {
      setState(() {
        _sortBy = sortBy;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.read<FarmBloc>().add(FilterFarms(userId: user.uid, sortBy: sortBy));
      }
    }
  }

  void _handleRefresh() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<FarmBloc>().add(RefreshFarms(userId: user.uid));
    }
  }

  void _handleDelete(Farm farm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Farm'),
        content: Text(
          'Are you sure you want to delete "${farm.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                context.read<FarmBloc>().add(
                      DeleteFarm(farmId: farm.id, userId: user.uid),
                    );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadSummaries(List<Farm> farms) async {
    final summaryService = getIt<FarmSummaryService>();
    final summaries = await summaryService.getSummaries(farms);
    if (mounted) {
      setState(() {
        _summaries = summaries;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Farms'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: _handleSort,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_by_alpha,
                      size: 20,
                      color: _sortBy == 'name' ? Colors.green : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Name',
                      style: TextStyle(
                        color: _sortBy == 'name' ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 20,
                      color: _sortBy == 'date' ? Colors.green : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Date',
                      style: TextStyle(
                        color: _sortBy == 'date' ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'capacity',
                child: Row(
                  children: [
                    Icon(
                      Icons.storage,
                      size: 20,
                      color: _sortBy == 'capacity' ? Colors.green : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Capacity',
                      style: TextStyle(
                        color: _sortBy == 'capacity' ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search farms...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _handleSearch,
            ),
          ),

          // Farm list
          Expanded(
            child: BlocConsumer<FarmBloc, FarmState>(
              listener: (context, state) {
                if (state is FarmOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message ?? 'Operation successful'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (state is FarmError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 4),
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
                  if (state.farms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.agriculture_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No farms found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first farm to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Load summaries when farms are loaded
                  _loadSummaries(state.farms);

                  return RefreshIndicator(
                    onRefresh: () async {
                      _handleRefresh();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: state.farms.length,
                      itemBuilder: (context, index) {
                        final farm = state.farms[index];
                        final summary = _summaries[farm.id];
                        final cattleCount = summary?.totalCattle ?? 0;

                        return FarmCard(
                          farm: farm,
                          cattleCount: cattleCount,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (newContext) => BlocProvider.value(
                                  value: context.read<FarmBloc>(),
                                  child: FarmDetailsScreen(farmId: farm.id),
                                ),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (newContext) => BlocProvider.value(
                                  value: context.read<FarmBloc>(),
                                  child: FarmEditScreen(farm: farm),
                                ),
                              ),
                            );
                          },
                          onDelete: () => _handleDelete(farm),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        label: const Text('Create Farm'),
      ),
    );
  }
}
