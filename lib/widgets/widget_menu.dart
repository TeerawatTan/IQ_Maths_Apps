import 'package:flutter/material.dart';

class WidgetMenu extends StatelessWidget {
  final String label;
  final Color color;
  final void Function() onPressed;
  final bool isSelected;

  const WidgetMenu({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color.fromARGB(255, 250, 221, 118)
              : Colors.white10,
          width: 2.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.amber.withAlpha((255.0 * 0.6).round()),
                  blurRadius: 10.0,
                  spreadRadius: 3.0,
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: isSelected
              ? label == "Register"
                    ? Colors.black
                    : Colors.white
              : Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'PoetsenOn',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
