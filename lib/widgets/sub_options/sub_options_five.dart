import 'package:flutter/material.dart';
import '../setting_sub_option_button.dart';
import '../setting_form.dart';

class SubOptionsFive extends StatelessWidget {
  final void Function(String route) onNavigate;

  final String? digit1;
  final String? digit2;
  final String? display;
  final String? row;
  final String? time;
  final void Function(String label, String value) onSettingChanged;

  const SubOptionsFive({
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
      height: MediaQuery.of(context).size.height * 0.65,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("FIVE BUDDY +"),
              _buildRow(["+4", "+3", "+2", "+1"]),
              const SizedBox(height: 10),
              _buildSectionTitle("FIVE BUDDY -"),
              _buildRow(["-4", "-3", "-2", "-1"]),
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
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildRow(List<String> suffixes) {
    return Row(
      children: suffixes.map((suffix) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SubOptionButton(
            label: "Five $suffix",
            route: '/',
            color: const Color(0xFFA3DEE8),
            onPressed: () => onNavigate('/'),
          ),
        );
      }).toList(),
    );
  }
}
