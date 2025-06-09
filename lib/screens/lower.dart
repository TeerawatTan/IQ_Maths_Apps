import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iq_maths_apps/datas/lower.dart';
import 'package:iq_maths_apps/datas/random_question.dart';
import 'package:iq_maths_apps/models/lower_upper.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/summary.dart';

class LowerScreen extends StatefulWidget {
  final MathsSetting setting;

  const LowerScreen({super.key, required this.setting});

  @override
  State<LowerScreen> createState() => _LowerScreenState();
}

class _LowerScreenState extends State<LowerScreen> {
  static const int _questionLimit = 10;
  List<int> _numbers = [];
  int _currentStep = 0;
  bool _showAnswer = false;
  bool _isSoundOn = true;
  bool _isPaused = false;
  bool _waitingToShowAnswer = false;
  bool _isShowAll = false;
  int _answer = 0;
  int _countAnsCorrect = 0;
  int _questionsAttempted = 0;
  bool _isFlashCardAnimating = false;
  final TextEditingController _inputAnsController = TextEditingController();
  bool _shouldContinueFlashCard = false;
  bool _showSmallWrongIcon = false;
  bool _showAnswerText = false;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();

    if (widget.setting.display.toLowerCase() == "flash card") {
      _shouldContinueFlashCard = true;
      _startFlashCard();
    }
  }

  @override
  void dispose() {
    _inputAnsController.dispose();
    _shouldContinueFlashCard = false;
    super.dispose();
  }

  void _generateRandomNumbers() {
    final digit1 = int.tryParse(widget.setting.digit1) ?? 1;
    final digit2 = int.tryParse(widget.setting.digit2) ?? 1;
    final row = int.tryParse(widget.setting.row) ?? 3;

    _numbers = [];

    if (row == 3) {
      _randomQuestion3rows(digit1, digit2);
    } else if (row == 4) {
      _randomQuestion4rows(digit1, digit2);
    } else if (row == 5) {
      _randomQuestion5rows(digit1, digit2);
    } else if (row == 6) {
      _randomQuestion6rows(digit1, digit2);
    }

    _currentStep = 0;
    _showAnswer = false;
    _waitingToShowAnswer = false;
    _showSmallWrongIcon = false;
    _showAnswerText = false;
    _inputAnsController.clear();
    setState(() {
      // Determine _isShowAll here based on the current setting
      _isShowAll = widget.setting.display.toLowerCase() == 'show all';
    });
    if (!_isShowAll) {
      _shouldContinueFlashCard = true;
      _startFlashCard();
    } else {
      // If in show all mode, reset _currentStep and immediately update UI
      setState(() {
        _currentStep = 0; // Not strictly needed for showAll but good practice
      });
    }
  }

  void _randomQuestion3rows(int d1, int d2) {
    // LowerUpper3Row? currentQ;
    // if (d1 == 1) {
    //   if (d2 == 1) {}
    // } else if (d1 == 2) {
    //   if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper3Row22);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 3) {
    //   if (d2 == 3) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper3Row33);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // }
    // if (currentQ != null) {
    //   _numbers.add(currentQ.digit1);
    //   _numbers.add(currentQ.digit2);
    //   _numbers.add(currentQ.digit3);
    //   _answer = currentQ.ans;
    // }
  }

  void _randomQuestion4rows(int d1, int d2) {
    // LowerUpper4Row? currentQ;
    // if (d1 == 1) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper4Row11);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 2) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper4Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper4Row22);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 3) {
    //   if (d2 == 3) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper4Row33);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // }
    // if (currentQ != null) {
    //   _numbers.add(currentQ.digit1);
    //   _numbers.add(currentQ.digit2);
    //   _numbers.add(currentQ.digit3);
    //   _numbers.add(currentQ.digit4);
    //   _answer = currentQ.ans;
    // }
  }

  void _randomQuestion5rows(int d1, int d2) {
    // LowerUpper5Row? currentQ;
    // if (d1 == 1) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper5Row11);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 2) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper5Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper5Row22);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 3) {
    //   if (d2 == 3) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper5Row33);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // }
    // if (currentQ != null) {
    //   _numbers.add(currentQ.digit1);
    //   _numbers.add(currentQ.digit2);
    //   _numbers.add(currentQ.digit3);
    //   _numbers.add(currentQ.digit4);
    //   _numbers.add(currentQ.digit5);
    //   _answer = currentQ.ans;
    // }
  }

  void _randomQuestion6rows(int d1, int d2) {
    // LowerUpper6Row? currentQ;
    // if (d1 == 1) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper6Row11);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 2) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper6Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper6Row22);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 3) {
    //   if (d2 == 3) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: upper6Row33);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // }
    // if (currentQ != null) {
    //   _numbers.add(currentQ.digit1);
    //   _numbers.add(currentQ.digit2);
    //   _numbers.add(currentQ.digit3);
    //   _numbers.add(currentQ.digit4);
    //   _numbers.add(currentQ.digit5);
    //   _numbers.add(currentQ.digit6);
    //   _answer = currentQ.ans;
    // }
  }

  Future<void> _startFlashCard() async {
    setState(() {
      _isFlashCardAnimating = true; // Disable button during animation
      _waitingToShowAnswer = false; // Hide '?' during flash card display
      _showAnswer = false; // Hide wrong _answer feedback
      _inputAnsController.clear(); // Clear input field
    });

    final int delaySeconds = int.tryParse(widget.setting.time.toString()) ?? 1;
    final Duration delayDuration = Duration(seconds: delaySeconds);

    // *** THIS IS THE KEY CHANGE ***
    // The loop now starts from the '_currentStep' instead of '0'
    for (int i = _currentStep; i < _numbers.length; i++) {
      if (!mounted || !_shouldContinueFlashCard) {
        // If the widget is unmounted or we've been told to stop (e.g., paused)
        return;
      }
      while (_isPaused && mounted) {
        // If paused, wait here without incrementing 'i' or '_currentStep'
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (!mounted || !_shouldContinueFlashCard) {
        // Check again after resuming, in case the state changed while paused
        return;
      }
      setState(() {
        _currentStep = i; // Update _currentStep to the number being displayed
      });
      await Future.delayed(delayDuration);
    }

    if (!mounted || !_shouldContinueFlashCard) {
      return;
    }
    setState(() {
      _waitingToShowAnswer = true; // Show '?' after all _numbers are flashed
      _isFlashCardAnimating = false; // Enable button after animation
    });
  }

  void _goSummaryPage() {
    if (!mounted) {
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(answerCorrect: _countAnsCorrect),
      ),
    );
  }

  void _nextStep() {
    if (_showAnswer) {
      _restart();
      return;
    }

    String input = _inputAnsController.text;
    int? userAnswer;
    if (input.isNotEmpty) {
      userAnswer = int.tryParse(input);
    }
    if (userAnswer != null) {
      if (userAnswer == _answer) {
        // ตอบถูก
        _countAnsCorrect++;
        _questionsAttempted++;
        if (_questionsAttempted >= _questionLimit) {
          _goSummaryPage();
          return;
        }
        _generateRandomNumbers();
      } else {
        //ตอบผิด
        setState(() {
          _showAnswer = true;
          _showSmallWrongIcon = false;
          _showAnswerText = false;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            _showSmallWrongIcon = true;
          });

          // --- Second Delay: For the answer text to appear (e.g., 200 milliseconds) ---
          Future.delayed(const Duration(milliseconds: 200), () {
            if (!mounted) return;
            setState(() {
              _showAnswerText = true; // NEW: Now show the answer text
            });

            // --- Third Delay: For the entire feedback display (2 seconds) ---
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted && _showAnswer) {
                // Ensure still in feedback state
                _questionsAttempted++;
                if (_questionsAttempted >= _questionLimit) {
                  _goSummaryPage();
                  return;
                }
                _generateRandomNumbers(); // Generate new question (resets all flags)
              }
            });
          });
        });
      }
    } else {
      return;
    }
  }

  void _restart() {
    _generateRandomNumbers();
  }

  void _playPauseFlashCard() {
    setState(() {
      _isPaused = !_isPaused;
      _shouldContinueFlashCard = !_isPaused; // Control the animation loop
    });
    if (!_isPaused) {
      _startFlashCard(); // Resume the flashcard animation if unpaused
    }
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
        ? 'flash card'
        : 'Show all';

    // Determine if the Next button should be enabled
    bool isNextButtonEnabled = true;
    if (!_isShowAll && _isFlashCardAnimating) {
      isNextButtonEnabled = false; // Disable during flash card animation
    } else if (!_isShowAll && !_waitingToShowAnswer && !_showAnswer) {
      // In flash card mode, if not showing '?' or _answer, button is disabled (waiting for sequence to finish)
      // This case is actually covered by _isFlashCardAnimating now.
    }

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
                if (widget.setting.display.toLowerCase() == "flash card" &&
                    !_waitingToShowAnswer)
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: IconButton(
                      icon: Image.asset(
                        _isPaused
                            ? 'assets/images/play_icon.png'
                            : 'assets/images/pause_icon.png',
                        width: 100,
                        height: 100,
                      ),
                      onPressed: _playPauseFlashCard,
                    ),
                  ),
                // Display current step/total _numbers if paused and in flash card mode
                if (_isPaused &&
                    widget.setting.display.toLowerCase() == "flash card")
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: buildOutlinedText(
                      '${_currentStep + 1}/${_numbers.length}', // Display current number/total
                      fontSize: 30,
                      strokeColor: Colors.blueAccent,
                      fillColor: Colors.white,
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
                    child: _isShowAll
                        ? () {
                            final rowCount = _numbers.length;
                            final double fontSize = (120 - (rowCount * 16.5))
                                .clamp(35, 120)
                                .toDouble();
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _numbers.map((e) {
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
                        : _isFlashCardAnimating // Show current step during flash card animation
                        ? buildOutlinedText(
                            "${_numbers[_currentStep]}",
                            fontSize: 160,
                          )
                        : _showAnswer || _waitingToShowAnswer
                        ? buildOutlinedText("?", fontSize: 160)
                        : Container(),
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
                                  enabled:
                                      !_isFlashCardAnimating, // Disable input during animation
                                ),
                              ),
                              if (_showAnswer)
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    if (_showSmallWrongIcon)
                                      Image.asset(
                                        'assets/images/wrong.png',
                                        width: 50,
                                        height: 50,
                                      ),
                                    if (_showSmallWrongIcon)
                                      SizedBox(width: 10),
                                    if (_showAnswerText)
                                      Flexible(
                                        child: Stack(
                                          children: [
                                            Text(
                                              "$_answer",
                                              style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                foreground: Paint()
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeWidth = 10
                                                  ..color = Colors.red
                                                  ..strokeJoin =
                                                      StrokeJoin.round,
                                              ),
                                            ),
                                            Text(
                                              "$_answer",
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
                      onPressed: isNextButtonEnabled
                          ? (_showAnswer ? _restart : _nextStep)
                          : null, // Disable button if not enabled
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
                            value: _isSoundOn,
                            onChanged: (value) {
                              setState(() {
                                _isSoundOn = value;
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
                          _isSoundOn ? "ON" : "OFF",
                          style: TextStyle(
                            color: _isSoundOn ? Colors.white : Colors.white,
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
