import 'package:flutter/material.dart';
import 'package:iq_maths_apps/widgets/widget_menu.dart';

class SubOptionButton extends StatelessWidget {
  final String label;
  final Color color;
  final void Function() onPressed;
  final bool isHighlighted;

  const SubOptionButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetMenu(
      label: label,
      color: color,
      onPressed: onPressed,
      isSelected: isHighlighted,
    );
  }
}
