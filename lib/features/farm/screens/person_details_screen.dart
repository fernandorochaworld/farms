import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/person_bloc.dart';
import '../bloc/person_event.dart';
import '../bloc/person_state.dart';
import '../models/person_model.dart';
import '../services/person_permission_checker.dart';
import '../constants/enums.dart';
import 'person_form_screen.dart';

/// Screen to display detailed information about a person
///
/// Features:
/// - Display person information
/// - Show role and permissions
/// - Edit button (if user has permission)
/// - Remove button (if user has permission)
class PersonDetailsScreen extends StatefulWidget {
  final String farmId;
  final String farmName;
  final Person person;
  final Person currentUser;

  const PersonDetailsScreen({
    super.key,
    required this.farmId,
    required this.farmName,
    required this.person,
    required this.currentUser,
  });

  static const String routeName = '/farm/person/details';

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  void _navigateToEdit() {
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
            person: widget.person,
          ),
        ),
      ),
    ).then((result) {
      if (result == true) {
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _confirmRemove() async {
    final canRemove = PersonPermissionChecker.canRemovePerson(
      widget.currentUser,
      widget.person,
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
          'Are you sure you want to remove ${widget.person.name} from this farm?\n\nThis action cannot be undone.',
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
              personId: widget.person.id,
              currentUserId: widget.currentUser.userId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canEdit = PersonPermissionChecker.canEditPerson(
      widget.currentUser,
      widget.person,
    );
    final canRemove = PersonPermissionChecker.canRemovePerson(
      widget.currentUser,
      widget.person,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Person Details'),
            Text(
              widget.farmName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToEdit,
              tooltip: 'Edit',
            ),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmRemove,
              tooltip: 'Remove',
            ),
        ],
      ),
      body: BlocListener<PersonBloc, PersonState>(
        listener: (context, state) {
          if (state is PersonOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is PersonOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Person header card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: _getTypeColor(theme),
                        child: Text(
                          PersonPermissionChecker.getPersonTypeIcon(
                            widget.person.personType,
                          ),
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        widget.person.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Type and admin badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTypeChip(theme),
                          if (widget.person.isAdmin) ...[
                            const SizedBox(width: 8),
                            _buildAdminBadge(theme),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description card
              if (widget.person.description != null &&
                  widget.person.description!.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notes,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Description',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.person.description!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Permissions card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Permissions',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        PersonPermissionChecker.getPermissionDescription(
                          widget.person.personType,
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Information card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        theme,
                        'Role',
                        widget.person.personType.label,
                        Icons.badge,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        theme,
                        'Admin Status',
                        widget.person.isAdmin ? 'Yes' : 'No',
                        Icons.shield,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        theme,
                        'Added On',
                        DateFormat.yMMMd().format(widget.person.createdAt),
                        Icons.calendar_today,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTypeColor(theme).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        widget.person.personType.label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: _getTypeColor(theme),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAdminBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield,
            size: 16,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            'Admin',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(ThemeData theme) {
    return switch (widget.person.personType) {
      PersonType.owner => Colors.deepPurple,
      PersonType.manager => Colors.blue,
      PersonType.worker => Colors.green,
      PersonType.arrendatario => Colors.orange,
    };
  }
}
