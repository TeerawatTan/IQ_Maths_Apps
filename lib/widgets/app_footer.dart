import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final bool isSmallScreen;
  const AppFooter({super.key, this.isSmallScreen = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSmallScreen ? 32 : 35,
      color: Colors.blue[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: isSmallScreen ? 10 : 16),
            child: Text(
              "Intelligent Quick Maths (IQM)",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
              "v.1.0.0",
              style: TextStyle(
                color: Colors.white10,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
