import 'package:flutter/material.dart';
import '../models/cattle_lot_model.dart';
import '../constants/enums.dart';

class LotCard extends StatelessWidget {
  final CattleLot lot;
  final VoidCallback? onTap;

  const LotCard({
    super.key,
    required this.lot,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      lot.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusIcon(context),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildChip(context, lot.cattleType.label, lot.cattleType.icon),
                  const SizedBox(width: 8),
                  _buildChip(context, lot.gender.label, lot.gender.icon),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.pets, size: 20, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text(
                    '${lot.currentQuantity} head',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (lot.isClosed) ...[
                    const SizedBox(width: 12),
                    Text(
                      '(Closed)',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    return Icon(
      lot.isActive ? Icons.check_circle : Icons.cancel,
      color: lot.isActive ? Colors.green.shade600 : Colors.grey.shade600,
      size: 20,
    );
  }

  Widget _buildChip(BuildContext context, String label, IconData icon) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.only(left: 4, right: 8),
      visualDensity: VisualDensity.compact,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}
