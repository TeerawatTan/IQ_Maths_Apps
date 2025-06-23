import 'package:flutter/material.dart';
import 'setting_dropdown.dart';

class SettingForm extends StatefulWidget {
  final String? selectedDigit1;
  final String? selectedDigit2;
  final String? selectedDisplay;
  final String? selectedRow;
  final String? selectedTime;

  final void Function(String label, String value) onChanged;

  final bool showDisplay;
  final bool showRow;
  final bool showTime;
  final String? onScreen;

  const SettingForm({
    super.key,
    required this.selectedDigit1,
    required this.selectedDigit2,
    required this.selectedDisplay,
    required this.selectedRow,
    this.selectedTime,
    required this.onChanged,
    this.showDisplay = true,
    this.showRow = true,
    required this.showTime,
    this.onScreen,
  });

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  List<Map<String, String>> _digitOptions() => [
    {'label': '1', 'value': '1'},
    {'label': '2', 'value': '2'},
    {'label': '3', 'value': '3'},
    {'label': '4', 'value': '4'},
    {'label': '5', 'value': '5'},
    {'label': '6', 'value': '6'},
  ];

  List<Map<String, String>> _displayOptions() => [
    {'label': 'Flash card', 'value': 'Flash card'},
    {'label': 'Show all', 'value': 'Show all'},
  ];

  List<Map<String, String>> _rowOptions() => [
    // {'label': '3', 'value': '3'},
    {'label': '4', 'value': '4'},
    {'label': '5', 'value': '5'},
    {'label': '6', 'value': '6'},
    {'label': '7', 'value': '7'},
    {'label': '8', 'value': '8'},
    {'label': '9', 'value': '9'},
    {'label': '10', 'value': '10'},
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

  List<Map<String, String>> _filteredDigitOptions() {
    List<Map<String, String>> list = [];
    if (widget.onScreen == 'Random Exercise') {
      list = _digitOptions();
    } else if (widget.onScreen == 'Multiplication' ||
        widget.onScreen == 'Division') {
      list = _digitOptions().where((option) {
        int? value = int.tryParse(option['value'] ?? '');
        return value != null && value >= 1 && value <= 5;
      }).toList();
    } else {
      list = _digitOptions().where((option) {
        int? value = int.tryParse(option['value'] ?? '');
        return value != null && value >= 1 && value <= 2;
      }).toList();
    }
    return list;
  }

  List<Map<String, String>> _filteredRowOptions() {
    List<Map<String, String>> list = [];
    if (widget.onScreen == 'Random Exercise') {
      list = _rowOptions();
    } else {
      list = _rowOptions().where((option) {
        int? value = int.tryParse(option['value'] ?? '');
        return value != null && value >= 4 && value <= 6;
      }).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SettingDropdown(
              label: "Digit 1",
              options: _filteredDigitOptions(),
              selectedValue: widget.selectedDigit1,
              onChanged: (v) => widget.onChanged("Digit 1", v ?? ''),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            SettingDropdown(
              label: "Digit 2",
              options: _filteredDigitOptions(),
              selectedValue: widget.selectedDigit2,
              onChanged: (v) => widget.onChanged("Digit 2", v ?? ''),
            ),
            const SizedBox(width: 10),
            if (!widget.showRow && widget.showDisplay && widget.showTime)
              SettingDropdown(
                label: "Time",
                options: _timeOptions(),
                selectedValue: widget.selectedTime,
                onChanged: (v) => widget.onChanged("Time", v ?? ''),
              ),
            if (widget.showDisplay)
              SettingDropdown(
                label: "Display",
                options: _displayOptions(),
                selectedValue: widget.selectedDisplay,
                onChanged: (v) => widget.onChanged("Display", v ?? ''),
              ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            if (widget.showRow)
              SettingDropdown(
                label: "Row",
                options: _filteredRowOptions(),
                selectedValue: widget.selectedRow,
                onChanged: (v) => widget.onChanged("Row", v ?? ''),
              ),
            if (widget.showRow) const SizedBox(width: 10),
            if (widget.showRow && widget.showTime)
              SettingDropdown(
                label: "Time",
                options: _timeOptions(),
                selectedValue: widget.selectedTime,
                onChanged: (v) => widget.onChanged("Time", v ?? ''),
              ),
          ],
        ),
      ],
    );
  }
}
