import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/no_data.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/widget_wrapper.dart';

class MultiplicationScreen extends StatefulWidget {
  final MathsSetting setting;

  const MultiplicationScreen({super.key, required this.setting});

  @override
  State<MultiplicationScreen> createState() => _MultiplicationScreenState();
}

class _MultiplicationScreenState extends State<MultiplicationScreen> {
  static const int questionLimit = 10;
  List<List<int>> numbers = [];
  int currentStep = 0;
  bool showAnswer = false;
  bool isSoundOn = true;
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
  bool isLoggingOut = false; // State to manage logout loading
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    widget.setting.display = "show all";
    _generateRandomNumbers();
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

    numbers = [];

    final min1 = pow(10, digit1 - 1).toInt();
    final max1 = pow(10, digit1).toInt() - 1;
    final min2 = pow(10, digit2 - 1).toInt();
    final max2 = pow(10, digit2).toInt() - 1;

    final random = Random();

    numbers = List.generate(questionLimit, (_) {
      final a = random.nextInt(max1 - min1 + 1) + min1;
      final b = random.nextInt(max2 - min2 + 1) + min2;
      return [a, b];
    });

    final p = numbers[currentStep];
    answer = p[0] * p[1];

    currentStep = 0;
    showAnswer = false;
    waitingToShowAnswer = false;
    showSmallWrongIcon = false;
    showAnswerText = false;
    inputAnsController.clear();
    setState(() {
      // Determine _isShowAll here based on the current setting
      isShowAll = widget.setting.display.toLowerCase() == 'show all';
    });
    if (!isShowAll) {
      shouldContinueFlashCard = true;
    } else {
      // If in show all mode, reset _currentStep and immediately update UI
      setState(() {
        currentStep = 0; // Not strictly needed for showAll but good practice
      });
    }
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

  @override
  Widget build(BuildContext context) {
    bool isNextButtonEnabled = true;
    if (!isShowAll && isFlashCardAnimating) {
      isNextButtonEnabled = false; // Disable during flash card animation
    } else if (!isShowAll && !waitingToShowAnswer && !showAnswer) {
      // In flash card mode, if not showing '?' or _answer, button is disabled (waiting for sequence to finish)
      // This case is actually covered by _isFlashCardAnimating now.
    }

    return WidgetWrapper(
      userName: auth.currentUser == null
          ? ''
          : auth.currentUser!.email!.substring(
              0,
              auth.currentUser!.email!.indexOf('@'),
            ),
      avatarImg: null,
      displayMode: '',
      inputAnsController: inputAnsController,
      onNextPressed: isNextButtonEnabled
          ? (showAnswer ? _restart : _nextStep)
          : null,
      onPlayPauseFlashCard: null,
      isPaused: isPaused,
      currentStep: currentStep,
      totalNumbers: numbers.length,
      isFlashCardAnimating: isFlashCardAnimating,
      showAnswer: showAnswer,
      showAnswerText: showAnswerText,
      waitingToShowAnswer: waitingToShowAnswer,
      showSmallWrongIcon: showSmallWrongIcon,
      answerText: answer.toString(),
      currentMenuImage: 'assets/images/multiplication.png',
      isShowMode: false,
      child: numbers.isEmpty
          ? const NoDataScreen()
          : Center(
              child: isShowAll
                  ? () {
                      // คำนวณ fontSize ให้เหมาะสมกับทุกขนาดหน้าจอ
                      final screenWidth = MediaQuery.of(context).size.width;
                      double fontSize = 140;
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

                      fontSize = fontSize.clamp(25, 140);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildOutlinedText(
                            "${numbers[currentStep][0]} × ${numbers[currentStep][1]}",
                            fontSize: fontSize,
                          ),
                        ],
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
