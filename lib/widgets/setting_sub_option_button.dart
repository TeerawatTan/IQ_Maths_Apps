import 'package:flutter/material.dart';
import 'package:iq_maths_apps/widgets/widget_menu.dart';

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
    return WidgetMenu(label: label, color: color, onPressed: onPressed);
  }
}
