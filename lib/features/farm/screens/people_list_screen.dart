import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/person_bloc.dart';
import '../bloc/person_event.dart';
import '../bloc/person_state.dart';
import '../models/person_model.dart';
import '../widgets/person_card.dart';
import '../services/person_permission_checker.dart';
import '../constants/enums.dart';
import 'person_form_screen.dart';
import 'person_details_screen.dart';

/// Screen to display list of people in a farm
///
/// Features:
/// - Display all people with their roles
/// - Search by name, description, or role
/// - Filter by person type
/// - Add new person (if user has permission)
/// - Edit/Remove people (if user has permission)
/// - Pull-to-refresh
class PeopleListScreen extends StatefulWidget {
  final String farmId;
  final String farmName;
  final Person currentUser;

  const PeopleListScreen({
    super.key,
    required this.farmId,
    required this.farmName,
    required this.currentUser,
  });

  static const String routeName = '/farm/people';

  @override
  State<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  final _searchController = TextEditingController();
  String? _selectedTypeFilter;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadPeople();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadPeople() {
    context.read<PersonBloc>().add(LoadPeople(farmId: widget.farmId));
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      _loadPeople();
    } else {
      context.read<PersonBloc>().add(
            SearchPeople(farmId: widget.farmId, query: query),
          );
    }
  }

  void _handleFilter(String? personType) {
    setState(() {
      _selectedTypeFilter = personType;
    });
    context.read<PersonBloc>().add(
          FilterPeople(farmId: widget.farmId, personType: personType),
        );
  }

  Future<void> _handleRefresh() async {
    context.read<PersonBloc>().add(RefreshPeople(farmId: widget.farmId));
    // Wait for the state to update
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToAddPerson() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newContext) => BlocProvider<PersonBloc>.value(
          value: context.read<PersonBloc>(),
          child: PersonFormScreen(
            farmId: widget.farmId,
            farmName: widget.farmName,
            currentUser: widget.currentUser,
            mode: PersonFormMode.create,
          ),
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadPeople();
      }
    });
  }

  void _navigateToEditPerson(Person person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newContext) => BlocProvider<PersonBloc>.value(
          value: context.read<PersonBloc>(),
          child: PersonFormScreen(
            farmId: widget.farmId,
            farmName: widget.farmName,
            currentUser: widget.currentUser,
            mode: PersonFormMode.edit,
            person: person,
          ),
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadPeople();
      }
    });
  }

  void _navigateToPersonDetails(Person person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newContext) => BlocProvider<PersonBloc>.value(
          value: context.read<PersonBloc>(),
          child: PersonDetailsScreen(
            farmId: widget.farmId,
            farmName: widget.farmName,
            person: person,
            currentUser: widget.currentUser,
          ),
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadPeople();
      }
    });
  }

  Future<void> _confirmRemovePerson(Person person) async {
    // Check if person can be removed
    final canRemove = PersonPermissionChecker.canRemovePerson(
      widget.currentUser,
      person,
    );

    if (!canRemove) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            PersonPermissionChecker.getPermissionDeniedMessage('remove people'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Person'),
        content: Text(
          'Are you sure you want to remove ${person.name} from this farm?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<PersonBloc>().add(
            RemovePerson(
              farmId: widget.farmId,
              personId: person.id,
              currentUserId: widget.currentUser.userId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAddPerson = PersonPermissionChecker.canAddPerson(widget.currentUser);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search people...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _handleSearch,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('People'),
                  Text(
                    widget.farmName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _loadPeople();
                }
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: _handleFilter,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Types'),
              ),
              ...PersonType.values.map(
                (type) => PopupMenuItem(
                  value: type.name,
                  child: Row(
                    children: [
                      Text(PersonPermissionChecker.getPersonTypeIcon(type)),
                      const SizedBox(width: 8),
                      Text(type.label),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<PersonBloc, PersonState>(
        listener: (context, state) {
          if (state is PersonOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PersonOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PersonError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PersonLoading && !_isSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PersonError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading people',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _loadPeople,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PersonLoaded) {
            if (state.people.isEmpty) {
              return _buildEmptyState(theme);
            }

            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Column(
                children: [
                  // Filter chip if active
                  if (_selectedTypeFilter != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: theme.colorScheme.primaryContainer,
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Chip(
                            label: Text(
                              'Filter: ${PersonType.values.firstWhere((t) => t.name == _selectedTypeFilter).label}',
                            ),
                            onDeleted: () => _handleFilter(null),
                          ),
                          const Spacer(),
                          Text(
                            '${state.people.length} ${state.people.length == 1 ? 'person' : 'people'}',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),

                  // People list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.people.length,
                      itemBuilder: (context, index) {
                        final person = state.people[index];
                        return PersonCard(
                          person: person,
                          currentUser: widget.currentUser,
                          onTap: () => _navigateToPersonDetails(person),
                          onEdit: () => _navigateToEditPerson(person),
                          onRemove: () => _confirmRemovePerson(person),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: canAddPerson
          ? FloatingActionButton.extended(
              onPressed: _navigateToAddPerson,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Person'),
            )
          : null,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No people found',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _selectedTypeFilter != null
                ? 'No people with this type'
                : 'Add people to manage your farm',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
