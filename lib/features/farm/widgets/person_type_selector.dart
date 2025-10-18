import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../services/person_permission_checker.dart';

/// Widget for selecting person type with visual options
///
/// Displays all available person types with icons, labels,
/// and descriptions to help users understand permissions.
class PersonTypeSelector extends StatelessWidget {
  final PersonType selectedType;
  final ValueChanged<PersonType> onChanged;
  final bool enabled;

  const PersonTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Person Type',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...PersonType.values.map((type) => _buildTypeOption(context, type)),
      ],
    );
  }

  Widget _buildTypeOption(BuildContext context, PersonType type) {
    final theme = Theme.of(context);
    final isSelected = type == selectedType;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: enabled ? () => onChanged(type) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                : null,
          ),
          child: Row(
            children: [
              // Radio button
              Radio<PersonType>(
                value: type,
                groupValue: selectedType,
                onChanged: enabled
                    ? (value) {
                        if (value != null) onChanged(value);
                      }
                    : null,
              ),
              const SizedBox(width: 12),

              // Icon
              Text(
                PersonPermissionChecker.getPersonTypeIcon(type),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),

              // Label and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      PersonPermissionChecker.getPermissionDescription(type),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
