import 'package:flutter/material.dart';
import '../setting_sub_option_button.dart';
import '../setting_form.dart';

class SubOptionsDiv extends StatelessWidget {
  final void Function(String label) onSubOptionSelected;
  final String? selectedSubOptionLabel;
  final String? digit1;
  final String? digit2;
  // final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsDiv({
    super.key,
    required this.onSubOptionSelected,
    required this.selectedSubOptionLabel,
    required this.digit1,
    required this.digit2,
    // required this.time,
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
            _buildButton('Division'),
            _buildButton('DivisionRandomTable'),
          ],
        ),
        const SizedBox(height: 15),
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
                  selectedDisplay: null,
                  selectedRow: null,
                  // selectedTime: time,
                  onChanged: onSettingChanged,
                  showDisplay: false,
                  showRow: false,
                  showTime: false,
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
      color: const Color(0xFFC4A5FF),
      onPressed: () => onSubOptionSelected(label),
      isHighlighted: isSelected,
    );
  }
}
