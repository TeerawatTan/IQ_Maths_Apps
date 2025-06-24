import 'package:audioplayers/audioplayers.dart';
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
  bool isSoundOn = true;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isAnswerCorrect = false;
  bool hasCheckedAnswer = false;

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
    isAnswerCorrect = false;
    hasCheckedAnswer = false;
    setState(() {
      isShowAll = widget.setting.display.toLowerCase() == 'show all';
    });
    if (!isShowAll) {
      shouldContinueFlashCard = true;
      _startFlashCard();
    } else {
      setState(() {
        currentStep = 0;
      });
      _playTikSound();
    }
  }

  Future<void> _startFlashCard() async {
    setState(() {
      isFlashCardAnimating = true;
      waitingToShowAnswer = false;
      showAnswer = false;
      inputAnsController.clear();
      hasCheckedAnswer = false;
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
      _playTikSound();
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

  void _playPauseFlashCard() {
    setState(() {
      isPaused = !isPaused;
      shouldContinueFlashCard = !isPaused;
    });
    if (!isPaused) _startFlashCard();
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
      displayMode: widget.setting.display,
      inputAnsController: inputAnsController,
      onNextPressed: isAnswerCorrect || showAnswerText ? _nextStep : null,
      onCheckPressed: isNextButtonEnabled ? _checkAnswer : null,
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
      currentMenuButtonLabel: _getCurrentMenuLabel(),
      isShowMode: true,
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

                      return SingleChildScrollView(
                        reverse: true,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: numbers.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: buildOutlinedText(
                                "$e",
                                fontSize: fontSize,
                              ),
                            );
                          }).toList(),
                        ),
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
