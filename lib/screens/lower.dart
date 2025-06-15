import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/datas/lower.dart';
import 'package:iq_maths_apps/datas/random_question.dart';
import 'package:iq_maths_apps/models/lower_upper.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/lower_upper_wrapper.dart';

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
  final auth = FirebaseAuth.instance;

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
    LowerUpper4Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower4Row11);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower4Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower4Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower4Row22);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    }
    if (currentQ != null) {
      _numbers.add(currentQ.digit1);
      _numbers.add(currentQ.digit2);
      _numbers.add(currentQ.digit3);
      _numbers.add(currentQ.digit4);
      _answer = currentQ.ans;
    }
  }

  void _randomQuestion5rows(int d1, int d2) {
    LowerUpper5Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower5Row11);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower5Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower5Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower5Row22);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    }
    if (currentQ != null) {
      _numbers.add(currentQ.digit1);
      _numbers.add(currentQ.digit2);
      _numbers.add(currentQ.digit3);
      _numbers.add(currentQ.digit4);
      _numbers.add(currentQ.digit5);
      _answer = currentQ.ans;
    }
  }

  void _randomQuestion6rows(int d1, int d2) {
    LowerUpper6Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower6Row11);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower6Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower6Row21);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(questions: lower6Row22);
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    }
    if (currentQ != null) {
      _numbers.add(currentQ.digit1);
      _numbers.add(currentQ.digit2);
      _numbers.add(currentQ.digit3);
      _numbers.add(currentQ.digit4);
      _numbers.add(currentQ.digit5);
      _numbers.add(currentQ.digit6);
      _answer = currentQ.ans;
    }
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
    // Determine if the Next button should be enabled
    bool isNextButtonEnabled = true;
    if (!_isShowAll && _isFlashCardAnimating) {
      isNextButtonEnabled = false; // Disable during flash card animation
    } else if (!_isShowAll && !_waitingToShowAnswer && !_showAnswer) {
      // In flash card mode, if not showing '?' or _answer, button is disabled (waiting for sequence to finish)
      // This case is actually covered by _isFlashCardAnimating now.
    }

    return LowerUpperWrapper(
      userName: auth.currentUser == null
          ? ''
          : auth.currentUser!.email!.substring(
              0,
              auth.currentUser!.email!.indexOf('@'),
            ),
      avatarImg: null,
      displayMode: widget.setting.display,
      inputAnsController: _inputAnsController,
      onNextPressed: isNextButtonEnabled
          ? (_showAnswer ? _restart : _nextStep)
          : null,
      onPlayPauseFlashCard: _playPauseFlashCard,
      isPaused: _isPaused,
      currentStep: _currentStep,
      totalNumbers: _numbers.length,
      isFlashCardAnimating: _isFlashCardAnimating,
      showAnswer: _showAnswer,
      showAnswerText: _showAnswerText,
      waitingToShowAnswer: _waitingToShowAnswer,
      showSmallWrongIcon: _showSmallWrongIcon,
      answerText: _answer.toString(),
      currentMenuImage: 'assets/images/lower.png',
      child: _numbers.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: buildOutlinedText("No data", fontSize: 60)),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Play Again",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            )
          : Center(
              child: _isShowAll
                  ? () {
                      // คำนวณ fontSize ให้เหมาะสมกับทุกขนาดหน้าจอ
                      final rowCount = _numbers.length;
                      final screenHeight = MediaQuery.of(context).size.height;
                      final screenWidth = MediaQuery.of(context).size.width;
                      final availableHeight = screenHeight * 0.45;
                      double fontSize = (availableHeight / rowCount * 0.8)
                          .clamp(25, 120);
                      // ปรับแต่งเพิ่มเติมตามขนาดหน้าจอ
                      if (screenWidth < 400) {
                        // Pixel รุ่นแรก และหน้าจอเล็ก
                        fontSize = fontSize * 0.8;
                      } else if (screenWidth >= 400 && screenWidth < 500) {
                        // Pixel 6 และหน้าจอขนาดกลาง
                        fontSize = fontSize * 0.85;
                      } else if (screenWidth >= 500 && screenWidth < 700) {
                        // หน้าจอใหญ่ แต่ยังเป็น Phone
                        fontSize = fontSize * 0.9;
                      } else {
                        // Tablet (> 700px)
                        fontSize = fontSize * 1.3;
                      }

                      fontSize = fontSize.clamp(25, 120);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _numbers.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: buildOutlinedText("$e", fontSize: fontSize),
                          );
                        }).toList(),
                      );
                    }()
                  : _isFlashCardAnimating
                  ? buildOutlinedText(
                      "${_numbers[_currentStep]}",
                      fontSize: 160,
                    )
                  : _showAnswer || _waitingToShowAnswer
                  ? buildOutlinedText("?", fontSize: 160)
                  : Container(),
            ),
    );
  }
}
