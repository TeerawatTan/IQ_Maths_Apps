import 'package:flutter/material.dart';

class SettingDropdown extends StatelessWidget {
  final String label;
  final List<Map<String, String>> options;
  final String? selectedValue;
  final void Function(String?)? onChanged;

  const SettingDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 126, 217, 87),
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: (selectedValue == null || selectedValue!.isEmpty)
              ? null
              : selectedValue,
          hint: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
