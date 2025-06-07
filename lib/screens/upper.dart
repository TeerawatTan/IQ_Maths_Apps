import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iq_maths_apps/datas/upper.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/datas/random_question.dart';
import 'package:iq_maths_apps/models/lower_upper.dart';
import 'package:iq_maths_apps/screens/summary.dart';

class UpperScreen extends StatefulWidget {
  final MathsSetting setting;

  const UpperScreen({super.key, required this.setting});

  @override
  State<UpperScreen> createState() => _UpperScreenState();
}

class _UpperScreenState extends State<UpperScreen> {
  late List<int> numbers = [];
  int currentStep = 0;
  bool showAnswer = false;
  bool isSoundOn = true;
  bool isPaused = false;
  bool waitingToShowAnswer = false;
  bool get isFlashCard => widget.setting.display.toLowerCase() == "flash card";
  bool get isShowAll => widget.setting.display.toLowerCase() == "show all";
  final int questionLimit = 2;
  int currentQuestionNo = 0;
  dynamic currentQ;
  int answer = 0;
  int countAnsCorrect = 0;
  final TextEditingController _inputAnsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();

    if (isFlashCard) {
      _startFlashCard();
    }
  }

  @override
  void dispose() {
    _inputAnsController.dispose();
    super.dispose();
  }

  void _generateRandomNumbers() {
    final digit1 = int.tryParse(widget.setting.digit1) ?? 1;
    final digit2 = int.tryParse(widget.setting.digit2) ?? 1;
    final row = int.tryParse(widget.setting.row) ?? 3;

    if (row == 3) {
      _randomQuestion3rows(digit1, digit2);
    } else if (row == 4) {
      _randomQuestion4rows(digit1, digit2);
    } else if (row == 5) {
      _randomQuestion5rows(digit1, digit2);
    } else if (row == 6) {
      _randomQuestion6rows(digit1, digit2);
    }
  }

  void _randomQuestion3rows(int d1, int d2) {
    LowerUpper3Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper3Row11);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {}
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper3Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    }
    if (currentQ != null) {
      numbers.add(currentQ.digit1);
      numbers.add(currentQ.digit2);
      numbers.add(currentQ.digit3);
      answer = currentQ.ans;
    }
  }

  void _randomQuestion4rows(int d1, int d2) {
    LowerUpper4Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper4Row11);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {}
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper4Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    }
    if (currentQ != null) {
      numbers.add(currentQ.digit1);
      numbers.add(currentQ.digit2);
      numbers.add(currentQ.digit3);
      numbers.add(currentQ.digit4);
      answer = currentQ.ans;
    }
  }

  void _randomQuestion5rows(int d1, int d2) {
    LowerUpper5Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper5Row11);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion() as LowerUpper5Row?;
      } else if (d2 == 2) {}
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper5Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    }
    if (currentQ != null) {
      numbers.add(currentQ.digit1);
      numbers.add(currentQ.digit2);
      numbers.add(currentQ.digit3);
      numbers.add(currentQ.digit4);
      numbers.add(currentQ.digit5);
      answer = currentQ.ans;
    }
  }

  void _randomQuestion6rows(int d1, int d2) {
    LowerUpper6Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper6Row11);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion() as LowerUpper6Row?;
      } else if (d2 == 2) {}
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: upper6Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    }
    if (currentQ != null) {
      numbers.add(currentQ.digit1);
      numbers.add(currentQ.digit2);
      numbers.add(currentQ.digit3);
      numbers.add(currentQ.digit4);
      numbers.add(currentQ.digit5);
      numbers.add(currentQ.digit6);
      answer = currentQ.ans;
    }
  }

  void _startFlashCard() {
    final time = int.tryParse(widget.setting.time) ?? 2;
    Future.delayed(Duration(milliseconds: (time * 1000).toInt()), () {
      if (!mounted || isPaused) return;

      print("Start FlashCard currentStep : $currentStep");
      if (waitingToShowAnswer) {
        // Flash card: กำลังรอแสดง ? → แสดงคำตอบ
        showAnswer = true;
        waitingToShowAnswer = false;
      } else if (currentStep < numbers.length) {
        currentStep++;
        if (currentStep == numbers.length) {
          waitingToShowAnswer = true;
        }
      }

      if (currentStep < numbers.length && !isPaused) {
        _startFlashCard();
      }
    });
  }

  void _nextStep() {
    setState(() {
      if (isShowAll) {
        // Show all: กด Next → แสดงคำตอบเลย
        int enteredNumber = int.parse(_inputAnsController.text);
        if (enteredNumber == answer) {
          ++countAnsCorrect;
          showAnswer = false;
        } else {
          showAnswer = true;
        }
        numbers = [];
        _inputAnsController.clear();
        answer = 0;
        ++currentQuestionNo;
        if (currentQuestionNo == questionLimit) {
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) {
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SummaryScreen(answerCorrect: countAnsCorrect),
              ),
            );
          });
        } else {
          _generateRandomNumbers();
        }
      }
    });
  }

  void _restart() {
    setState(() {
      currentStep = 0;
      showAnswer = false;
      waitingToShowAnswer = false;

      numbers = [];
      _inputAnsController.clear();
      answer = 0;

      _generateRandomNumbers();

      if (isFlashCard) {
        _startFlashCard();
      }
    });
  }

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
            child: Image.asset('assets/images/upper.png', width: 150),
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
                        ? () {
                            final rowCount = numbers.length;
                            final double fontSize = (120 - (rowCount * 16.5))
                                .clamp(35, 120)
                                .toDouble();
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: numbers.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  child: buildOutlinedText(
                                    "$e",
                                    fontSize: fontSize,
                                  ),
                                );
                              }).toList(),
                            );
                          }()
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
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 100.0,
                                  right: 100,
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _inputAnsController,
                                  decoration: InputDecoration(counterText: ''),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 60,
                                    color: Colors.red,
                                  ),
                                  showCursor: false,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  maxLength: 5,
                                ),
                              ),
                              if (showAnswer)
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/wrong.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Stack(
                                        children: [
                                          Text(
                                            "$answer",
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
                                            "$answer",
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
