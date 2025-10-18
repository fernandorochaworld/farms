import 'package:flutter/material.dart';
import '../models/farm_model.dart';

/// Summary card widget displaying farm statistics on the dashboard
class FarmSummaryCard extends StatelessWidget {
  final Farm farm;
  final int cattleCount;
  final int activeLots;
  final VoidCallback onTap;

  const FarmSummaryCard({
    super.key,
    required this.farm,
    required this.cattleCount,
    required this.activeLots,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final capacityPercent = farm.capacity > 0
        ? (cattleCount / farm.capacity * 100).clamp(0.0, 100.0).toDouble()
        : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with farm icon and name
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.agriculture,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farm.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (farm.description != null &&
                            farm.description!.isNotEmpty)
                          Text(
                            farm.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 20),

              // Statistics grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: Icons.pets,
                      label: 'Cattle',
                      value: '$cattleCount',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: Icons.category,
                      label: 'Lots',
                      value: '$activeLots',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Capacity usage section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Capacity Usage',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        '${capacityPercent.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getCapacityColor(capacityPercent),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: capacityPercent / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: _getCapacityColor(capacityPercent),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$cattleCount of ${farm.capacity} head',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
        ],
      ),
    );
  }

  Color _getCapacityColor(double percent) {
    if (percent >= 90) return Colors.red;
    if (percent >= 75) return Colors.orange;
    if (percent >= 50) return Colors.blue;
    return Colors.green;
  }
}
