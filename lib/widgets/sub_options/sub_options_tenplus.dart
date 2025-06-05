import 'package:flutter/material.dart';
import '../setting_sub_option_button.dart';
import '../setting_form.dart';

class SubOptionsTenPlus extends StatelessWidget {
  final void Function(String route) onNavigate;

  final String? digit1;
  final String? digit2;
  final String? display;
  final String? row;
  final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsTenPlus({
    super.key,
    required this.onNavigate,
    required this.digit1,
    required this.digit2,
    required this.display,
    required this.row,
    required this.time,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("TEN COUPLE +"),
              _buildRow(["+9", "+8", "+7", "+6", "+5"]),
              _buildRow(["+4", "+3", "+2", "+1", "Random"]),
              const SizedBox(height: 10),
              _buildSectionTitle("FIVE & TEN COUPLE +"),
              _buildRow(["+9", "+8", "+7", "+6", "Random"]),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Setting",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildRow(List<String> suffixes) {
    return Row(
      children: suffixes.map((suffix) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SubOptionButton(
            label: suffix == "Random" ? "Random Lesson" : "Ten $suffix",
            route: '/',
            color: suffix == "Random" ? Colors.red : const Color(0xFF5271FF),
            onPressed: () => onNavigate('/'),
          ),
        );
      }).toList(),
    );
  }
}
