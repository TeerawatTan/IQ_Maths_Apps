import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/helpers/format_number.dart';
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
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isAnswerCorrect = false;
  bool hasCheckedAnswer = false;

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
    audioPlayer.dispose();
    super.dispose();
  }

  void _playTikSound() async {
    if (isSoundOn) {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('files/sound_tik.mp3'));
    }
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
    isAnswerCorrect = false;
    hasCheckedAnswer = false;
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
      _playTikSound();
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

  void _checkAnswer() {
    String input = inputAnsController.text;
    int? userAnswer;
    if (input.isNotEmpty) {
      userAnswer = int.tryParse(input);
    } else {
      return;
    }

    setState(() {
      hasCheckedAnswer = true; // Mark that an answer has been checked
    });

    if (userAnswer != null && userAnswer == answer) {
      countAnsCorrect++;
      setState(() {
        isAnswerCorrect = true;
      });
      // Optionally add a short delay before moving to the next question
    } else {
      setState(() {
        isAnswerCorrect = false;
        showAnswer = true;
        showAnswerText = false;
        showSmallWrongIcon = false;
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          showSmallWrongIcon = true;
        });

        Future.delayed(const Duration(milliseconds: 50), () {
          if (!mounted) return;
          setState(() {
            showAnswerText = true;
          });
        });
      });
    }
  }

  void _nextStep() {
    Future.delayed(const Duration(seconds: 1), () {
      questionsAttempted++;
      if (questionsAttempted >= questionLimit) {
        _goSummaryPage();
        return;
      }
      _generateRandomNumbers();
    });
  }

  String _getCurrentMenuLabel() {
    final selectedLabel = widget.setting.selectedSubOptionLabel;

    if (selectedLabel.isEmpty) {
      return 'No Label'; // Default text instead of default image
    }
    return selectedLabel; // Return the label directly
  }

  @override
  Widget build(BuildContext context) {
    bool isNextButtonEnabled = true;
    if (!isShowAll && isFlashCardAnimating) {
      isNextButtonEnabled = false; // Disable during flash card animation
    } else if (!isShowAll && !waitingToShowAnswer && !showAnswer) {
      isNextButtonEnabled = false;
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
      onNextPressed: isAnswerCorrect || showAnswerText ? _nextStep : null,
      onCheckPressed: isNextButtonEnabled ? _checkAnswer : null,
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
      currentMenuButtonLabel: _getCurrentMenuLabel(),
      isShowMode: false,
      isSoundOn: isSoundOn,
      onSoundToggle: (newValue) {
        setState(() {
          isSoundOn = newValue;
        });
      },
      isAnswerCorrect: isAnswerCorrect,
      hasCheckedAnswer: hasCheckedAnswer,
      child: numbers.isEmpty
          ? const NoDataScreen()
          : LayoutBuilder(
              builder: (context, constraints) {
                final shortSide = MediaQuery.of(context).size.shortestSide;
                final isTablet = shortSide >= 600;

                // สร้างข้อความที่จะแสดง
                final displayText =
                    "${formatNumber(numbers[currentStep][0].toString())} × ${formatNumber(numbers[currentStep][1].toString())}";
                final textLength = displayText.length;

                // กำหนดขนาดตามจำนวนตัวอักษร
                double boxWidth, boxHeight;

                if (isTablet) {
                  if (textLength >= 13) {
                    // 5 หลัก (13+ ตัวอักษร)
                    boxWidth = 900.0;
                    boxHeight = 300.0;
                  } else if (textLength >= 11) {
                    // 4 หลัก (11 ตัวอักษร)
                    boxWidth = 800.0;
                    boxHeight = 250.0;
                  } else if (textLength >= 9) {
                    // 3 หลัก (9 ตัวอักษร)
                    boxWidth = 700.0;
                    boxHeight = 200.0;
                  } else if (textLength >= 7) {
                    // 2 หลัก (7 ตัวอักษร)
                    boxWidth = 550.0;
                    boxHeight = 180.0;
                  } else {
                    // 1 หลัก (5 ตัวอักษร)
                    boxWidth = 450.0;
                    boxHeight = 150.0;
                  }
                } else {
                  // สำหรับโทรศัพท์ ใช้ขนาดเดิม
                  boxWidth = 450.0;
                  boxHeight = 150.0;
                }

                final paddingTop = isTablet ? 80.0 : 80.0;
                final paddingLeft = isTablet ? 50.0 : 50.0;

                return SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: paddingTop,
                      left: paddingLeft,
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: buildOutlinedText(displayText),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
