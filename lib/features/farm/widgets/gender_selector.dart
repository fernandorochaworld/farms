import 'package:flutter/material.dart';
import '../constants/enums.dart';

class GenderSelector extends StatelessWidget {
  final CattleGender selectedGender;
  final ValueChanged<CattleGender> onGenderSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<CattleGender>(
      segments: const [
        ButtonSegment(
          value: CattleGender.male,
          label: Text('Male'),
          icon: Icon(Icons.male),
        ),
        ButtonSegment(
          value: CattleGender.female,
          label: Text('Female'),
          icon: Icon(Icons.female),
        ),
        ButtonSegment(
          value: CattleGender.mixed,
          label: Text('Mixed'),
          icon: Icon(Icons.compost),
        ),
      ],
      selected: {selectedGender},
      onSelectionChanged: (newSelection) {
        onGenderSelected(newSelection.first);
      },
    );
  }
}
