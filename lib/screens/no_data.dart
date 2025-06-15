import 'package:flutter/material.dart';
import 'package:iq_maths_apps/widgets/widget_wrapper.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: buildOutlinedText("No data", fontSize: 60)),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Play Again", style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
