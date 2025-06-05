import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';

class LowerScreen extends StatefulWidget {
  final MathsSetting setting;

  const LowerScreen({super.key, required this.setting});

  @override
  State<LowerScreen> createState() => _LowerScreenState();
}

class _LowerScreenState extends State<LowerScreen> {
  late List<int> numbers;
  int currentStep = 0;
  bool showAnswer = false;
  bool isSoundOn = true;
  bool isPaused = false;
  bool waitingToShowAnswer = false;
  bool get isFlashCard => widget.setting.display.toLowerCase() == "flash card";
  bool get isShowAll => widget.setting.display.toLowerCase() == "show all";

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();

    if (isFlashCard) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !isPaused) {
          _startFlashCard();
        }
      });
    }
  }

  void _generateRandomNumbers() {
    final digit1 = int.tryParse(widget.setting.digit1) ?? 1;
    final digit2 = int.tryParse(widget.setting.digit2) ?? 1;
    final row = int.tryParse(widget.setting.row) ?? 3;

    final minDigit1 = pow(10, digit1 - 1).toInt();
    final maxDigit1 = pow(10, digit1).toInt() - 1;

    final digit2Abs = digit2.abs();
    final minDigit2 = pow(10, digit2Abs - 1).toInt();
    final maxDigit2 = pow(10, digit2Abs).toInt() - 1;

    final random = Random();

    numbers = List.generate(row, (index) {
      if (index == 0) {
        return random.nextInt(maxDigit1 - minDigit1 + 1) + minDigit1;
      } else {
        int value = random.nextInt(maxDigit2 - minDigit2 + 1) + minDigit2;
        bool isNegative = random.nextBool();
        return isNegative ? -value : value;
      }
    });
  }

  void _startFlashCard() {
    final time = double.tryParse(widget.setting.time!) ?? 1.5;

    Future.delayed(Duration(milliseconds: (time * 1000).toInt()), () {
      if (!mounted || isPaused) return;

      setState(() {
        if (currentStep < numbers.length) {
          currentStep++;
          showAnswer = false;
          if (currentStep == numbers.length) {
            waitingToShowAnswer = true;
          }
        }
      });

      if (currentStep < numbers.length && !isPaused) {
        _startFlashCard();
      }
    });
  }

  void _nextStep() {
    setState(() {
      if (isShowAll) {
        showAnswer = true;
        return;
      }
      if (waitingToShowAnswer) {
        showAnswer = true;
        waitingToShowAnswer = false;
      } else if (currentStep < numbers.length) {
        currentStep++;
        if (currentStep == numbers.length) {
          waitingToShowAnswer = true;
        }
      }
    });
  }

  Widget buildNumberDisplay() {
    if (isShowAll) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: numbers.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: buildOutlinedText("$e", fontSize: 60),
          );
        }).toList(),
      );
    }

    if (waitingToShowAnswer) {
      return buildOutlinedText("?", fontSize: 160);
    }

    if (currentStep < numbers.length) {
      return buildOutlinedText("${numbers[currentStep]}", fontSize: 160);
    }

    return buildOutlinedText("${getAnswerSum()}", fontSize: 160);
  }

  void _restart() {
    setState(() {
      currentStep = 0;
      showAnswer = false;
      waitingToShowAnswer = false;
      _generateRandomNumbers();

      if (isFlashCard) {
        _startFlashCard();
      }
    });
  }

  int getAnswerSum() => numbers.fold(0, (sum, n) => sum + n);

  Widget buildOutlinedText(
    String text, {
    double fontSize = 60,
    double strokeWidthRatio = 0.25,
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
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            height: 1.3,
            color: fillColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayMode = widget.setting.display.toLowerCase() == 'flash card'
        ? 'Flash card'
        : 'Show all';
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
            child: Image.asset('assets/images/lower.png', width: 150),
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
                Stack(
                  children: [
                    Text(
                      "Display : $displayMode",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 7
                          ..color = Colors.black
                          ..strokeJoin = StrokeJoin.round,
                      ),
                    ),
                    Text(
                      "Display : $displayMode",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

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
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: isShowAll
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: numbers.map((e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                ),
                                child: buildOutlinedText("$e", fontSize: 60),
                              );
                            }).toList(),
                          )
                        : showAnswer || waitingToShowAnswer
                        ? buildOutlinedText("?", fontSize: 160)
                        : buildOutlinedText(
                            "${numbers[currentStep]}",
                            fontSize: 160,
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
                                        "${getAnswerSum()}",
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
                                        "${getAnswerSum()}",
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
                      onPressed: showAnswer ? _restart : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
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
