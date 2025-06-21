import 'package:flutter/material.dart';
import 'package:iq_maths_apps/widgets/setting_form.dart';
import 'package:iq_maths_apps/widgets/setting_sub_option_button.dart';

class SubOptionsLP extends StatelessWidget {
  final void Function(String label) onSubOptionSelected;
  final String? selectedSubOptionLabel;
  final String? digit1;
  final String? digit2;
  final String? display;
  final String? row;
  final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsLP({
    super.key,
    required this.onSubOptionSelected,
    required this.selectedSubOptionLabel,
    required this.digit1,
    required this.digit2,
    required this.display,
    required this.row,
    required this.time,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildButton('Lower'),
            _buildButton('Upper'),
            _buildButton('Lower&Upper'),
          ],
        ),
        const SizedBox(height: 15),
        // Setting Section
        if (selectedSubOptionLabel != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Setting",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                SettingForm(
                  selectedDigit1: digit1,
                  selectedDigit2: digit2,
                  selectedDisplay: display,
                  selectedRow: row,
                  selectedTime: time,
                  onChanged: onSettingChanged,
                  showDisplay: true,
                  showRow: true,
                  showTime: true,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildButton(String label) {
    bool isSelected = selectedSubOptionLabel == label;
    return SubOptionButton(
      label: label,
      color: const Color(0xFFFA7D9D),
      onPressed: () => onSubOptionSelected(label),
      isHighlighted: isSelected,
    );
  }
}
