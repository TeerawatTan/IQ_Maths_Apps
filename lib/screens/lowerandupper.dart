import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/datas/lower_upper.dart';
import 'package:iq_maths_apps/datas/random_question.dart';
import 'package:iq_maths_apps/models/lower_upper.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/widget_wrapper.dart';

class LowerAndUpperScreen extends StatefulWidget {
  final MathsSetting setting;

  const LowerAndUpperScreen({super.key, required this.setting});

  @override
  State<LowerAndUpperScreen> createState() => _LowerAndUpperScreenState();
}

class _LowerAndUpperScreenState extends State<LowerAndUpperScreen> {
  static const int questionLimit = 10;
  List<int> numbers = [];
  int currentStep = 0;
  bool showAnswer = false;
  bool isPaused = false;
  bool waitingToShowAnswer = false;
  bool isShowAll = false;
  int answer = 0;
  int countAnsCorrect = 0;
  int questionsAttempted = 0;
  bool isFlashCardAnimating = false;
  final TextEditingController inputAnsController = TextEditingController();
  bool shouldContinueFlashCard = false;
  bool showSmallWrongIcon = false;
  bool showAnswerText = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();

    if (widget.setting.display.toLowerCase() == "flash card") {
      shouldContinueFlashCard = true;
      _startFlashCard();
    }
  }

  @override
  void dispose() {
    inputAnsController.dispose();
    shouldContinueFlashCard = false;
    super.dispose();
  }

  void _generateRandomNumbers() {
    final digit1 = int.tryParse(widget.setting.digit1) ?? 1;
    final digit2 = int.tryParse(widget.setting.digit2) ?? 1;
    final row = int.tryParse(widget.setting.row) ?? 3;

    numbers = [];

    if (row == 3) {
      _randomQuestion3rows(digit1, digit2);
    } else if (row == 4) {
      _randomQuestion4rows(digit1, digit2);
    } else if (row == 5) {
      _randomQuestion5rows(digit1, digit2);
    } else if (row == 6) {
      _randomQuestion6rows(digit1, digit2);
    }

    currentStep = 0;
    showAnswer = false;
    waitingToShowAnswer = false;
    showSmallWrongIcon = false;
    showAnswerText = false;
    inputAnsController.clear();
    setState(() {
      // Determine isShowAll here based on the current setting
      isShowAll = widget.setting.display.toLowerCase() == 'show all';
    });
    if (!isShowAll) {
      shouldContinueFlashCard = true;
      _startFlashCard();
    } else {
      // If in show all mode, reset currentStep and immediately update UI
      setState(() {
        currentStep = 0; // Not strictly needed for showAll but good practice
      });
    }
  }

  void _randomQuestion3rows(int d1, int d2) {
    LowerUpper3Row? currentQ;
    if (d1 == 1) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper3Row11,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper3Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper3Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper3Row22,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 3) {
      if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper3Row32,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 3) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper3Row33,
        );
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
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper4Row11,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper4Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper4Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper4Row22,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 3) {
      if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper4Row32,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 3) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper4Row33,
        );
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
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper5Row11,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper5Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper5Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper5Row22,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 3) {
      if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper5Row32,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 3) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper5Row33,
        );
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
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper6Row11,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper6Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 2) {
      if (d2 == 1) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper6Row21,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper6Row22,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      }
    } else if (d1 == 3) {
      if (d2 == 2) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper6Row32,
        );
        selector.selectRandomQuestion();
        currentQ = selector.getCurrentQuestion();
      } else if (d2 == 3) {
        RandomQuestionRow selector = RandomQuestionRow(
          questions: lowerUpper6Row33,
        );
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

  Future<void> _startFlashCard() async {
    setState(() {
      isFlashCardAnimating = true; // Disable button during animation
      waitingToShowAnswer = false; // Hide '?' during flash card display
      showAnswer = false; // Hide wrong answer feedback
      inputAnsController.clear(); // Clear input field
    });

    final int delaySeconds = int.tryParse(widget.setting.time.toString()) ?? 1;
    final Duration delayDuration = Duration(seconds: delaySeconds);

    // *** THIS IS THE KEY CHANGE ***
    // The loop now starts from the 'currentStep' instead of '0'
    for (int i = currentStep; i < numbers.length; i++) {
      if (!mounted || !shouldContinueFlashCard) {
        // If the widget is unmounted or we've been told to stop (e.g., paused)
        return;
      }
      while (isPaused && mounted) {
        // If paused, wait here without incrementing 'i' or 'currentStep'
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (!mounted || !shouldContinueFlashCard) {
        // Check again after resuming, in case the state changed while paused
        return;
      }
      setState(() {
        currentStep = i; // Update currentStep to the number being displayed
      });
      await Future.delayed(delayDuration);
    }

    if (!mounted || !shouldContinueFlashCard) {
      return;
    }
    setState(() {
      waitingToShowAnswer = true; // Show '?' after all numbers are flashed
      isFlashCardAnimating = false; // Enable button after animation
    });
  }

  void _goSummaryPage() {
    if (!mounted) {
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(answerCorrect: countAnsCorrect),
      ),
    );
  }

  void _nextStep() {
    if (showAnswer) {
      _restart();
      return;
    }

    String input = inputAnsController.text;
    int? userAnswer;
    if (input.isNotEmpty) {
      userAnswer = int.tryParse(input);
    }
    if (userAnswer != null) {
      if (userAnswer == answer) {
        // ตอบถูก
        countAnsCorrect++;
        questionsAttempted++;
        if (questionsAttempted >= questionLimit) {
          _goSummaryPage();
          return;
        }
        _generateRandomNumbers();
      } else {
        //ตอบผิด
        setState(() {
          showAnswer = true;
          showSmallWrongIcon = false;
          showAnswerText = false;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            showSmallWrongIcon = true;
          });

          // --- Second Delay: For the answer text to appear (e.g., 200 milliseconds) ---
          Future.delayed(const Duration(milliseconds: 200), () {
            if (!mounted) return;
            setState(() {
              showAnswerText = true; // NEW: Now show the answer text
            });

            // --- Third Delay: For the entire feedback display (2 seconds) ---
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted && showAnswer) {
                // Ensure still in feedback state
                questionsAttempted++;
                if (questionsAttempted >= questionLimit) {
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
      isPaused = !isPaused;
      shouldContinueFlashCard = !isPaused; // Control the animation loop
    });
    if (!isPaused) {
      _startFlashCard(); // Resume the flashcard animation if unpaused
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the Next button should be enabled
    bool isNextButtonEnabled = true;
    if (!isShowAll && isFlashCardAnimating) {
      isNextButtonEnabled = false; // Disable during flash card animation
    } else if (!isShowAll && !waitingToShowAnswer && !showAnswer) {
      // In flash card mode, if not showing '?' or answer, button is disabled (waiting for sequence to finish)
      // This case is actually covered by isFlashCardAnimating now.
    }

    return WidgetWrapper(
      userName: auth.currentUser == null
          ? ''
          : auth.currentUser!.email!.substring(
              0,
              auth.currentUser!.email!.indexOf('@'),
            ),
      avatarImg: null,
      displayMode: widget.setting.display,
      inputAnsController: inputAnsController,
      onNextPressed: isNextButtonEnabled
          ? (showAnswer ? _restart : _nextStep)
          : null,
      onPlayPauseFlashCard: _playPauseFlashCard,
      isPaused: isPaused,
      currentStep: currentStep,
      totalNumbers: numbers.length,
      isFlashCardAnimating: isFlashCardAnimating,
      showAnswer: showAnswer,
      showAnswerText: showAnswerText,
      waitingToShowAnswer: waitingToShowAnswer,
      showSmallWrongIcon: showSmallWrongIcon,
      answerText: answer.toString(),
      currentMenuImage: 'assets/images/lowerandupper.png',
      isShowMode: true,
      child: numbers.isEmpty
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
              child: isShowAll
                  ? () {
                      // คำนวณ fontSize ให้เหมาะสมกับทุกขนาดหน้าจอ
                      final rowCount = numbers.length;
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
                        children: numbers.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: buildOutlinedText("$e", fontSize: fontSize),
                          );
                        }).toList(),
                      );
                    }()
                  : isFlashCardAnimating
                  ? buildOutlinedText("${numbers[currentStep]}", fontSize: 160)
                  : showAnswer || waitingToShowAnswer
                  ? buildOutlinedText("?", fontSize: 160)
                  : Container(),
            ),
    );
  }
}
