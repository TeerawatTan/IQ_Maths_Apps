import 'package:flutter/material.dart';
import 'setting_dropdown.dart';

class SettingRow extends StatelessWidget {
  final List<Map<String, dynamic>> dropdowns;

  const SettingRow({super.key, required this.dropdowns});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: dropdowns.map((dropdown) {
        return SettingDropdown(
          label: dropdown['label'],
          options: dropdown['options'],
          selectedValue: dropdown['selectedValue'],
          onChanged: dropdown['onChanged'],
        );
      }).toList(),
    );
  }
}
