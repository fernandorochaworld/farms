import 'package:flutter/material.dart';
import '../constants/enums.dart';

class CattleTypeSelector extends StatelessWidget {
  final CattleType? selectedType;
  final ValueChanged<CattleType> onChanged;

  const CattleTypeSelector({
    super.key,
    this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: CattleType.values.map((type) {
        return RadioListTile<CattleType>(
          title: Text(type.label),
          subtitle: Text(type.description),
          value: type,
          groupValue: selectedType,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        );
      }).toList(),
    );
  }
}
