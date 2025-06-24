import 'package:flutter/material.dart';
import '../setting_sub_option_button.dart';
import '../setting_form.dart';

class SubOptionsFive extends StatelessWidget {
  final void Function(String label) onSubOptionSelected;
  final String? selectedSubOptionLabel;
  final String? digit1;
  final String? digit2;
  final String? display;
  final String? row;
  final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsFive({
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
        _buildSectionTitle("FIVE BUDDY +"),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _generateFiveBuddyPlusButtons(),
        ),
        const SizedBox(height: 10),
        _buildSectionTitle("FIVE BUDDY -"),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _generateFiveBuddyMinusButtons(),
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

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  List<Widget> _buildRow(List<String> suffixes) {
    return suffixes.map((suffix) {
      bool isSelected = selectedSubOptionLabel == suffix;
      return SubOptionButton(
        label: suffix,
        color: suffix.startsWith("Five") ? const Color(0xFFA3DEE8) : Colors.red,
        onPressed: () => onSubOptionSelected(suffix),
        isHighlighted: isSelected,
      );
    }).toList();
  }

  // ฟังก์ชันใหม่สำหรับ FIVE BUDDY +
  List<Widget> _generateFiveBuddyPlusButtons() {
    List<String> suffixes = [];
    for (int i = 4; i >= 1; i--) {
      suffixes.add("Five +$i");
    }
    suffixes.add("Random Lesson Five +");
    return _buildRow(suffixes);
  }

  // ฟังก์ชันใหม่สำหรับ FIVE BUDDY -
  List<Widget> _generateFiveBuddyMinusButtons() {
    List<String> suffixes = [];
    for (int i = 4; i >= 1; i--) {
      suffixes.add("Five -$i");
    }
    suffixes.add("Random Lesson Five -");
    return _buildRow(suffixes);
  }
}
