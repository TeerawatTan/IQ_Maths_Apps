import 'package:flutter/material.dart';

class SubOptionButton extends StatelessWidget {
  final String label;
  final String route;
  final Color color;
  final void Function() onPressed;

  const SubOptionButton({
    super.key,
    required this.label,
    required this.route,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white, width: 2),
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
    );
  }
}
