import 'package:flutter/material.dart';
import '../setting_sub_option_button.dart';
import '../setting_form.dart';

class SubOptionsLP extends StatelessWidget {
  final void Function(String route) onNavigate;

  final String? digit1;
  final String? digit2;
  final String? display;
  final String? row;
  final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsLP({
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SubOptionButton(
                label: 'Lower',
                route: '/Lower',
                color: const Color(0xFFFA7D9D),
                onPressed: () => onNavigate('/Lower'),
              ),
              const SizedBox(width: 40),
              SubOptionButton(
                label: 'Upper',
                route: '/Upper',
                color: const Color(0xFFFA7D9D),
                onPressed: () => onNavigate('/Upper'),
              ),
              const SizedBox(width: 40),
              SubOptionButton(
                label: 'Lower&Upper',
                route: '/LowerAndUpper',
                color: const Color(0xFFFA7D9D),
                onPressed: () => onNavigate('/LowerAndUpper'),
              ),
            ],
          ),
          const SizedBox(height: 15),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
