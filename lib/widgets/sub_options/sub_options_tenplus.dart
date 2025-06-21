import 'package:flutter/material.dart';
import '../setting_sub_option_button.dart';
import '../setting_form.dart';

class SubOptionsTenPlus extends StatelessWidget {
  final void Function(String label) onSubOptionSelected;
  final String? selectedSubOptionLabel;
  final String? digit1;
  final String? digit2;
  final String? display;
  final String? row;
  final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsTenPlus({
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
        _buildSectionTitle("TEN COUPLE +"),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _generateTenCouplePlusButtons(),
        ),
        const SizedBox(height: 10),
        _buildSectionTitle("FIVE & TEN COUPLE +"),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _generateFiveTenCouplePlusButtons(),
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
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.blueAccent,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ฟังก์ชันใหม่สำหรับ TEN COUPLE +
  List<Widget> _generateTenCouplePlusButtons() {
    List<String> suffixes = [];
    for (int i = 9; i >= 1; i--) {
      // Loop จาก 9 ลงไปถึง 1
      suffixes.add("Ten +$i");
    }
    suffixes.add("Random Lesson Ten +"); // เพิ่มปุ่ม Random เข้าไปท้ายสุด
    return _buildRow(suffixes);
  }

  // ฟังก์ชันใหม่สำหรับ FIVE & TEN COUPLE +
  List<Widget> _generateFiveTenCouplePlusButtons() {
    List<String> suffixes = [];
    for (int i = 9; i >= 6; i--) {
      // Loop จาก 9 ลงไปถึง 6
      suffixes.add("Five&Ten +$i");
    }
    suffixes.add("Random Lesson Five&Ten +"); // เพิ่มปุ่ม Random เข้าไปท้ายสุด
    return _buildRow(suffixes);
  }

  List<Widget> _buildRow(List<String> suffixes) {
    return suffixes.map((suffix) {
      bool isSelected = selectedSubOptionLabel == suffix;
      return SubOptionButton(
        label: suffix,
        color: suffix.startsWith("Ten")
            ? const Color(0xFF5271FF)
            : suffix.startsWith("Five&Ten")
            ? const Color(0xFF51E4D6)
            : suffix == "Random Lesson Ten +" ||
                  suffix == "Random Lesson Five&Ten +"
            ? Colors.red
            : Colors.white,
        onPressed: () => onSubOptionSelected(suffix),
        isHighlighted: isSelected,
      );
    }).toList();
  }
}
