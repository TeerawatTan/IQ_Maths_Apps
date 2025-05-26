import 'package:flutter/material.dart';

class LowerScreen extends StatefulWidget {
  const LowerScreen({super.key});

  @override
  State<LowerScreen> createState() => _LowerScreenState();
}

class _LowerScreenState extends State<LowerScreen> {
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Image.asset('assets/images/logo.png', width: 60),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Color(0xFFFF7393),
                side: BorderSide(color: Colors.white, width: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Lower',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Image.asset('assets/images/maths_icon5.png', width: 100),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/images/iq_maths_icon.png', width: 150),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "3",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "-2",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "3",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFFFCC33), // Yellow background
                  borderRadius: BorderRadius.circular(50), // Rounded pill shape
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFB300), // Slight drop shadow
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'Ans',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 3,
                            color: Colors.black,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                        // cursorColor: Colors.black,
                        showCursor: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.lightBlueAccent,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Intelligent Quick Maths (IQM)",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        isSoundOn ? "Sound ON" : "Sound OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/sound_icon.png',
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 6),
                      Switch(
                        value: isSoundOn,
                        onChanged: (value) {
                          setState(() {
                            isSoundOn = value;
                          });
                        },
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
