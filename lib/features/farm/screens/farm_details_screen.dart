import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/di/injection.dart';
import '../bloc/farm_bloc.dart';
import '../bloc/farm_event.dart';
import '../bloc/farm_state.dart';
import '../bloc/person_bloc.dart';
import '../models/farm_model.dart';
import '../models/person_model.dart' as farm_person;
import '../repositories/person_repository.dart';
import '../services/farm_summary_service.dart';
import 'farm_edit_screen.dart';
import 'people_list_screen.dart';
import 'lot_list_screen.dart';

/// Screen displaying detailed information about a specific farm
class FarmDetailsScreen extends StatefulWidget {
  final String farmId;

  const FarmDetailsScreen({
    super.key,
    required this.farmId,
  });

  static const String routeName = '/farm/details';

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  FarmSummary? _summary;
  String? _loadedFarmId;

  @override
  void initState() {
    super.initState();
    _loadFarm();
  }

  void _loadFarm() {
    final currentState = context.read<FarmBloc>().state;
    // Only load if we're not already showing this specific farm
    if (currentState is! FarmDetailLoaded ||
        (currentState as FarmDetailLoaded).farm.id != widget.farmId) {
      context.read<FarmBloc>().add(LoadFarmById(farmId: widget.farmId));
    }
  }

  Future<void> _loadSummary(Farm farm) async {
    // Only load summary once per farm
    if (_loadedFarmId == farm.id) return;

    _loadedFarmId = farm.id;
    final summaryService = getIt<FarmSummaryService>();
    final summary = await summaryService.getSummary(farm);
    if (mounted) {
      setState(() {
        _summary = summary;
      });
    }
  }

  Future<void> _navigateToManagePeople(BuildContext context, Farm farm) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get current user's person record for this farm
      final personRepository = getIt<PersonRepository>();
      final currentUserPerson = await personRepository.getByUserIdInFarm(
        farm.id,
        user.uid,
      );

      if (currentUserPerson != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider<PersonBloc>(
              create: (context) => getIt<PersonBloc>(),
              child: PeopleListScreen(
                farmId: farm.id,
                farmName: farm.name,
                currentUser: currentUserPerson,
              ),
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be a member of this farm to manage people'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDelete(Farm farm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Farm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${farm.name}"?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This will also delete:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text('• All cattle lots'),
            const Text('• All people associated with this farm'),
            const Text('• All transactions'),
            const Text('• All goals and services'),
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                // Navigate back to farm list after deletion
                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Details'),
        elevation: 0,
        actions: [
          BlocBuilder<FarmBloc, FarmState>(
            builder: (context, state) {
              if (state is FarmDetailLoaded) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => BlocProvider.value(
                            value: context.read<FarmBloc>(),
                            child: FarmEditScreen(farm: state.farm),
                          ),
                        ),
                      );
                      // .then((updated) {
                      //   if (updated == true) {
                      //     context
                      //         .read<FarmBloc>()
                      //         .add(LoadFarmById(farmId: widget.farmId));
                      //   }
                      // });
                    } else if (value == 'delete') {
                      _handleDelete(state.farm);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
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
          }
        },
        builder: (context, state) {
          if (state is FarmLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FarmDetailLoaded) {
            final farm = state.farm;

            // Load summary
            _loadSummary(farm);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Farm Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.agriculture,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    farm.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (farm.description != null &&
                                      farm.description!.isNotEmpty)
                                    Text(
                                      farm.description!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Overview Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildStatRow(
                                  icon: Icons.pets,
                                  label: 'Total Cattle',
                                  value: '${_summary?.totalCattle ?? 0} head',
                                  color: Colors.green,
                                ),
                                const Divider(),
                                _buildStatRow(
                                  icon: Icons.category,
                                  label: 'Active Lots',
                                  value: '${_summary?.activeLots ?? 0}',
                                  color: Colors.blue,
                                ),
                                const Divider(),
                                _buildStatRow(
                                  icon: Icons.storage,
                                  label: 'Capacity',
                                  value:
                                      '${_summary?.capacityUsagePercent.toStringAsFixed(0) ?? 0}%',
                                  color: Colors.orange,
                                ),
                                const Divider(),
                                _buildStatRow(
                                  icon: Icons.people,
                                  label: 'People',
                                  value: '${_summary?.totalMembers ?? 0}',
                                  color: Colors.purple,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quick Actions Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Navigate to add transaction
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Transaction'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Navigate to add lot
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Lot'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sections',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionTile(
                          icon: Icons.category,
                          title: 'Cattle Lots',
                          subtitle: '${_summary?.activeLots ?? 0} active',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LotListScreen(farm: farm),
                              ),
                            );
                          },
                        ),
                        _buildSectionTile(
                          icon: Icons.people,
                          title: 'People',
                          subtitle: '${_summary?.totalMembers ?? 0} members',
                          onTap: () => _navigateToManagePeople(context, farm),
                        ),
                        _buildSectionTile(
                          icon: Icons.history,
                          title: 'Transactions',
                          subtitle: 'Recent activity',
                          onTap: () {
                            // TODO: Navigate to transactions
                          },
                        ),
                        _buildSectionTile(
                          icon: Icons.flag,
                          title: 'Goals',
                          subtitle: 'Track your goals',
                          onTap: () {
                            // TODO: Navigate to goals
                          },
                        ),
                        _buildSectionTile(
                          icon: Icons.medical_services,
                          title: 'Services History',
                          subtitle: 'Health & services',
                          onTap: () {
                            // TODO: Navigate to services
                          },
                        ),
                        _buildSectionTile(
                          icon: Icons.assessment,
                          title: 'Reports',
                          subtitle: 'Analytics & insights',
                          onTap: () {
                            // TODO: Navigate to reports
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Farm not found'),
          );
        },
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
