import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final bool isHome;
  const AppBackground({super.key, this.isHome = false});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
        ),
        // Logo
        Positioned(
          top: 30,
          left: 20,
          child: Image.asset('assets/images/logo.png', width: 60),
        ),
        // IQM Icon (แสดงเฉพาะถ้าไม่ใช่หน้า home)
        if (!isHome)
          Positioned(
            top: 10,
            left: 100,
            child: Center(
              child: Image.asset('assets/images/iq_maths_icon.png', width: 130),
            ),
          ),
        // Owl (แสดงเฉพาะถ้าไม่ใช่หน้า home)
        if (!isHome)
          Positioned(
            bottom: 40,
            left: 20,
            child: Image.asset('assets/images/owl.png', width: 120),
          ),
      ],
    );
  }
}
