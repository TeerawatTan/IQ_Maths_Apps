import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/no_data.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/widget_wrapper.dart';
import 'dart:math';

class RandomExerciseScreen extends StatefulWidget {
  final MathsSetting setting;

  const RandomExerciseScreen({super.key, required this.setting});

  @override
  State<RandomExerciseScreen> createState() => _RandomExerciseScreenState();
}

class _RandomExerciseScreenState extends State<RandomExerciseScreen> {
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

    int getMin(int digit) => (digit == 1) ? 1 : pow(10, digit - 1).toInt();
    int getMax(int digit) => (digit == 1) ? 9 : pow(10, digit).toInt() - 1;

    final rand = Random();
    int total = -1;

    while (total < 0) {
      numbers = List.generate(row, (_) {
        final useDigit = rand.nextBool() ? digit1 : digit2;
        final min = getMin(useDigit);
        final max = getMax(useDigit);
        final value = rand.nextInt(max - min + 1) + min;

        // สุ่มติดลบหรือบวก
        return rand.nextBool() ? value : -value;
      });

      total = numbers.reduce((a, b) => a + b);
    }

    answer = total;
    currentStep = 0;
    showAnswer = false;
    waitingToShowAnswer = false;
    showSmallWrongIcon = false;
    showAnswerText = false;
    inputAnsController.clear();

    setState(() {
      isShowAll = widget.setting.display.toLowerCase() == 'show all';
    });

    if (!isShowAll) {
      shouldContinueFlashCard = true;
      _startFlashCard();
    }
  }

  Future<void> _startFlashCard() async {
    setState(() {
      isFlashCardAnimating = true;
      waitingToShowAnswer = false;
      showAnswer = false;
      inputAnsController.clear();
    });

    final delaySeconds = int.tryParse(widget.setting.time.toString()) ?? 1;
    final delayDuration = Duration(seconds: delaySeconds);

    for (int i = currentStep; i < numbers.length; i++) {
      if (!mounted || !shouldContinueFlashCard) return;
      while (isPaused && mounted) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (!mounted || !shouldContinueFlashCard) return;
      setState(() => currentStep = i);
      await Future.delayed(delayDuration);
    }

    if (!mounted || !shouldContinueFlashCard) return;

    setState(() {
      waitingToShowAnswer = true;
      isFlashCardAnimating = false;
    });
  }

  void _goSummaryPage() {
    if (!mounted) return;
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

    final input = inputAnsController.text;
    final userAnswer = int.tryParse(input);

    if (userAnswer != null) {
      if (userAnswer == answer) {
        countAnsCorrect++;
        questionsAttempted++;
        if (questionsAttempted >= questionLimit) {
          _goSummaryPage();
        } else {
          _generateRandomNumbers();
        }
      } else {
        setState(() {
          showAnswer = true;
          showSmallWrongIcon = false;
          showAnswerText = false;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() => showSmallWrongIcon = true);

          Future.delayed(const Duration(milliseconds: 200), () {
            if (!mounted) return;
            setState(() => showAnswerText = true);

            Future.delayed(const Duration(seconds: 2), () {
              if (!mounted || !showAnswer) return;
              questionsAttempted++;
              if (questionsAttempted >= questionLimit) {
                _goSummaryPage();
              } else {
                _generateRandomNumbers();
              }
            });
          });
        });
      }
    }
  }

  void _restart() {
    _generateRandomNumbers();
  }

  void _playPauseFlashCard() {
    setState(() {
      isPaused = !isPaused;
      shouldContinueFlashCard = !isPaused;
    });
    if (!isPaused) _startFlashCard();
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
      currentMenuImage: 'assets/images/RandomExercise.png',
      isShowMode: true,
      child: numbers.isEmpty
          ? const NoDataScreen()
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
