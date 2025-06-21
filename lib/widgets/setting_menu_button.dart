import 'package:flutter/material.dart';
import 'package:iq_maths_apps/widgets/widget_menu.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;
  final bool isSelected;

  const MenuButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: WidgetMenu(
        label: title,
        color: color,
        onPressed: onPressed,
        isSelected: isSelected,
      ),
    );
  }
}
