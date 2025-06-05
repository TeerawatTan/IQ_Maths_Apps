import 'package:flutter/material.dart';
import 'setting_dropdown.dart';

class SettingForm extends StatelessWidget {
  final String? selectedDigit1;
  final String? selectedDigit2;
  final String? selectedDisplay;
  final String? selectedRow;
  final String? selectedTime;

  final void Function(String label, String value) onChanged;

  final bool showDisplay;
  final bool showRow;
  final bool timeNextToDigit2;

  const SettingForm({
    super.key,
    required this.selectedDigit1,
    required this.selectedDigit2,
    required this.selectedDisplay,
    required this.selectedRow,
    required this.selectedTime,
    required this.onChanged,
    this.showDisplay = true,
    this.showRow = true,
    this.timeNextToDigit2 = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SettingDropdown(
              label: "Digit 1",
              options: _digitOptions(),
              selectedValue: selectedDigit1,
              onChanged: (v) => onChanged("Digit 1", v ?? ''),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            SettingDropdown(
              label: "Digit 2",
              options: _digitOptions(),
              selectedValue: selectedDigit2,
              onChanged: (v) => onChanged("Digit 2", v ?? ''),
            ),
            const SizedBox(width: 10),
            if (timeNextToDigit2)
              SettingDropdown(
                label: "Time",
                options: _timeOptions(),
                selectedValue: selectedTime,
                onChanged: (v) => onChanged("Time", v ?? ''),
              ),
            if (showDisplay)
              SettingDropdown(
                label: "Display",
                options: _displayOptions(),
                selectedValue: selectedDisplay,
                onChanged: (v) => onChanged("Display", v ?? ''),
              ),
          ],
        ),

        const SizedBox(height: 10),

        if (!timeNextToDigit2)
          Row(
            children: [
              if (showRow)
                SettingDropdown(
                  label: "Row",
                  options: _rowOptions(),
                  selectedValue: selectedRow,
                  onChanged: (v) => onChanged("Row", v ?? ''),
                ),
              if (showRow) const SizedBox(width: 10),
              SettingDropdown(
                label: "Time",
                options: _timeOptions(),
                selectedValue: selectedTime,
                onChanged: (v) => onChanged("Time", v ?? ''),
              ),
            ],
          ),
      ],
    );
  }

  List<Map<String, String>> _digitOptions() => [
    {'label': '1', 'value': '1'},
    {'label': '2', 'value': '2'},
    {'label': '3', 'value': '3'},
  ];

  List<Map<String, String>> _displayOptions() => [
    {'label': 'Flash card', 'value': 'Flash card'},
    {'label': 'Show all', 'value': 'Show all'},
  ];

  List<Map<String, String>> _rowOptions() => [
    {'label': '3', 'value': '3'},
    {'label': '4', 'value': '4'},
    {'label': '5', 'value': '5'},
    {'label': '6', 'value': '6'},
  ];

  List<Map<String, String>> _timeOptions() => [
    {'label': '1', 'value': '1'},
    {'label': '2', 'value': '2'},
    {'label': '3', 'value': '3'},
    {'label': '4', 'value': '4'},
    {'label': '5', 'value': '5'},
    {'label': '10', 'value': '10'},
    {'label': '15', 'value': '15'},
    {'label': '30', 'value': '30'},
    {'label': '60', 'value': '60'},
  ];
}
