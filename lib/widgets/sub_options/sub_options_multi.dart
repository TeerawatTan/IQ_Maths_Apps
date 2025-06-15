import 'package:flutter/material.dart';
import '../setting_sub_option_button.dart';
import '../setting_form.dart';

class SubOptionsMulti extends StatelessWidget {
  final void Function(String route) onNavigate;

  final String? digit1;
  final String? digit2;
  // final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsMulti({
    super.key,
    required this.onNavigate,
    required this.digit1,
    required this.digit2,
    // required this.time,
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
                label: 'Multiplication',
                route: '/Multiplication',
                color: const Color(0xFF7ED957),
                onPressed: () => onNavigate('/Multiplication'),
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
                  selectedDisplay: null,
                  selectedRow: null,
                  // selectedTime: time,
                  onChanged: onSettingChanged,
                  showDisplay: false,
                  showRow: false,
                  timeNextToDigit2: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
