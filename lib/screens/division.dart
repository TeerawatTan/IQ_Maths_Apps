import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';

class DivisionScreen extends StatefulWidget {
  final MathsSetting setting;

  const DivisionScreen({super.key, required this.setting});

  @override
  State<DivisionScreen> createState() => _DivisionScreenState();
}

class _DivisionScreenState extends State<DivisionScreen> {
  int currentStep = 0;

  bool showAnswer = false;
  bool isSoundOn = true;
  bool isPaused = false;
  bool waitingToShowAnswer = false;
  bool isLoading = true;
  List<List<int>> divisionProblems = [];

  @override
  void initState() {
    super.initState();
    _GenerateNumbers();
  }

  void _GenerateNumbers() async {
    setState(() => isLoading = true);
    divisionProblems = await _generateRandomNumbers();
    setState(() {
      currentStep = 0;
      showAnswer = false;
      isLoading = false;
    });
  }

  Future<List<List<int>>> _generateRandomNumbers() async {
    final digit1 = int.tryParse(widget.setting.digit1) ?? 2;
    final digit2 = int.tryParse(widget.setting.digit2) ?? 1;
    final count = 10;

    final minDividend = pow(10, digit1 - 1).toInt();
    final maxDividend = pow(10, digit1).toInt() - 1;
    final minDivisor = pow(10, digit2 - 1).toInt();
    final maxDivisor = pow(10, digit2).toInt() - 1;
    final random = Random();

    List<List<int>> results = [];
    int attempt = 0;

    while (results.length < count && attempt < count * 20) {
      attempt++;
      int divisor = random.nextInt(maxDivisor - minDivisor + 1) + minDivisor;
      int quotient = random.nextInt(9) + 1;
      int dividend = divisor * quotient;

      if (dividend >= minDividend && dividend <= maxDividend) {
        results.add([dividend, divisor]);
      }
    }

    while (results.length < count) {
      results.add([minDividend, minDivisor]);
    }

    return results;
  }

  void _startFlashCard() {
    final time = 1.5;
    Future.delayed(Duration(milliseconds: (time * 1000).toInt()), () {
      if (!mounted || isPaused) return;

      _nextStep();

      if (currentStep < divisionProblems.length && !isPaused) {
        _startFlashCard();
      }
    });
  }

  void _nextStep() {
    setState(() {
      if (waitingToShowAnswer) {
        showAnswer = true;
        waitingToShowAnswer = false;
      } else if (currentStep < divisionProblems.length) {
        currentStep++;
        if (currentStep == divisionProblems.length) {
          waitingToShowAnswer = true;
        }
      }
    });
  }

  void _restart() {
    setState(() {
      currentStep = 0;
      showAnswer = false;
      waitingToShowAnswer = false;
      _GenerateNumbers();
    });
  }

  int getCurrentAnswer() {
    final p = divisionProblems[currentStep];
    return p[0] ~/ p[1];
  }

  Widget buildOutlinedText(
    String text, {
    double fontSize = 60,
    double strokeWidthRatio = 0.2,
    Color strokeColor = Colors.black,
    Color fillColor = Colors.white,
  }) {
    final strokeWidth = fontSize * strokeWidthRatio;
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            height: 1.3,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor
              ..strokeJoin = StrokeJoin.round,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            height: 1.3,
            color: fillColor,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Image.asset('assets/images/logo.png', width: 60),
          ),
          Positioned(
            top: 110,
            left: 20,
            child: Image.asset('assets/images/division.png', width: 170),
          ),
          Positioned(
            top: 10,
            left: 100,
            child: Center(
              child: Image.asset('assets/images/iq_maths_icon.png', width: 130),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Image.asset('assets/images/owl.png', width: 120),
          ),

          Positioned(
            top: 30,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "ID :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: IconButton(
                    icon: Image.asset(
                      isPaused
                          ? 'assets/images/play_icon.png'
                          : 'assets/images/pause_icon.png',
                      width: 100,
                      height: 100,
                    ),
                    onPressed: () {
                      setState(() {
                        isPaused = !isPaused;
                        if (!isPaused &&
                            widget.setting.display.toLowerCase() ==
                                "Flash card") {
                          _startFlashCard();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: divisionProblems.isEmpty
                        ? const Text(
                            "Loading...",
                            style: TextStyle(fontSize: 40, color: Colors.red),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildOutlinedText(
                                "${divisionProblems[currentStep][0]} ÷ ${divisionProblems[currentStep][1]}",
                                fontSize: 120,
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  children: [
                    const SizedBox(width: 150),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 350,
                          height: 60,
                          padding: const EdgeInsets.fromLTRB(20, 7, 0, 0),
                          decoration: BoxDecoration(
                            color: Colors.yellow[600],
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.shade200,
                                offset: const Offset(4, 4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Text(
                                "Ans",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 10
                                    ..color = Colors.black
                                    ..strokeJoin = StrokeJoin.round,
                                ),
                              ),
                              const Text(
                                "Ans",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (showAnswer)
                                Align(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: [
                                      Text(
                                        "${getCurrentAnswer()}",
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 10
                                            ..color = Colors.red
                                            ..strokeJoin = StrokeJoin.round,
                                        ),
                                      ),
                                      Text(
                                        "${getCurrentAnswer()}",
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (!showAnswer) {
                            showAnswer = true; // แสดงคำตอบ
                          } else {
                            // ไปข้อถัดไป
                            if (currentStep < divisionProblems.length - 1) {
                              currentStep++;
                              showAnswer = false;
                            } else {
                              // จบ → เริ่มใหม่
                              _restart();
                            }
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/Next.png', width: 150),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),

              Container(
                height: 42,
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Intelligent Quick Maths ( IQM )",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Sound ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          'assets/images/sound_icon.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 4),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: isSoundOn,
                            onChanged: (value) {
                              setState(() {
                                isSoundOn = value;
                              });
                            },
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: const Color.fromARGB(
                              255,
                              235,
                              116,
                              107,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isSoundOn ? "ON" : "OFF",
                          style: TextStyle(
                            color: isSoundOn ? Colors.white : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
