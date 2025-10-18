import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../services/person_permission_checker.dart';
import '../constants/enums.dart';

/// Card widget to display person information in a list
///
/// Shows person's name, type, admin status, and provides
/// actions for edit and remove if user has permissions.
class PersonCard extends StatelessWidget {
  final Person person;
  final Person? currentUser;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const PersonCard({
    super.key,
    required this.person,
    this.currentUser,
    this.onTap,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canEdit = currentUser != null &&
        PersonPermissionChecker.canEditPerson(currentUser!, person);
    final canRemove = currentUser != null &&
        PersonPermissionChecker.canRemovePerson(currentUser!, person);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: _getTypeColor(context),
                child: Text(
                  PersonPermissionChecker.getPersonTypeIcon(person.personType),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),

              // Person info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      person.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Type and admin badges
                    Row(
                      children: [
                        _buildTypeChip(context),
                        if (person.isAdmin) ...[
                          const SizedBox(width: 8),
                          _buildAdminBadge(context),
                        ],
                      ],
                    ),

                    // Description if available
                    if (person.description != null &&
                        person.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        person.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              if (canEdit || canRemove) ...[
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'remove' && onRemove != null) {
                      onRemove!();
                    }
                  },
                  itemBuilder: (context) => [
                    if (canEdit)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    if (canRemove)
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Remove', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build the person type chip
  Widget _buildTypeChip(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(context).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        person.personType.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: _getTypeColor(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build the admin badge
  Widget _buildAdminBadge(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield,
            size: 12,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            'Admin',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Get color based on person type
  Color _getTypeColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (person.personType) {
      case PersonType.owner:
        return Colors.deepPurple;
      case PersonType.manager:
        return Colors.blue;
      case PersonType.worker:
        return Colors.green;
      case PersonType.arrendatario:
        return Colors.orange;
    }
  }
}
