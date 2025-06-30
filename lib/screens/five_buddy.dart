import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/datas/five_minus_four.dart';
import 'package:iq_maths_apps/datas/five_minus_one.dart';
import 'package:iq_maths_apps/datas/five_minus_three.dart';
import 'package:iq_maths_apps/datas/five_minus_two.dart';
import 'package:iq_maths_apps/datas/five_plus_four.dart';
import 'package:iq_maths_apps/datas/five_plus_one.dart';
import 'package:iq_maths_apps/datas/five_plus_three.dart';
import 'package:iq_maths_apps/datas/five_plus_two.dart';
import 'package:iq_maths_apps/datas/random_five_minus.dart';
import 'package:iq_maths_apps/datas/random_five_plus.dart';
import 'package:iq_maths_apps/helpers/random_question.dart';
import 'package:iq_maths_apps/models/digit_model.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/no_data.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/widget_wrapper.dart';

class FiveBuddyScreen extends StatefulWidget {
  final MathsSetting setting;

  const FiveBuddyScreen({super.key, required this.setting});

  @override
  State<FiveBuddyScreen> createState() => _FiveBuddyScreenState();
}

class _FiveBuddyScreenState extends State<FiveBuddyScreen> {
  static const int questionLimit = 10;
  List<int> numbers = [];
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
      audioPlayer.play(AssetSource('files/sound_tik.mp3'));
    }
  }

  final Map<String, List<dynamic>> _dataMap = {
    'Five_+1_4_1_1': fivePlusOne4Row11,
    'Five_+1_4_1_2': fivePlusOne4Row21,
    'Five_+1_4_2_1': fivePlusOne4Row21,
    'Five_+1_4_2_2': fivePlusOne4Row22,
    'Five_+1_5_1_1': fivePlusOne5Row11,
    'Five_+1_5_1_2': fivePlusOne5Row21,
    'Five_+1_5_2_1': fivePlusOne5Row21,
    'Five_+1_5_2_2': fivePlusOne5Row22,
    'Five_+1_6_1_1': fivePlusOne6Row11,
    'Five_+1_6_1_2': fivePlusOne6Row21,
    'Five_+1_6_2_1': fivePlusOne6Row21,
    'Five_+1_6_2_2': fivePlusOne6Row22,

    'Five_+2_4_1_1': fivePlusTwo4Row11,
    'Five_+2_4_1_2': fivePlusTwo4Row21,
    'Five_+2_4_2_1': fivePlusTwo4Row21,
    'Five_+2_4_2_2': fivePlusTwo4Row22,
    'Five_+2_5_1_1': fivePlusTwo5Row11,
    'Five_+2_5_1_2': fivePlusTwo5Row21,
    'Five_+2_5_2_1': fivePlusTwo5Row21,
    'Five_+2_5_2_2': fivePlusTwo5Row22,
    'Five_+2_6_1_1': fivePlusTwo6Row11,
    'Five_+2_6_1_2': fivePlusTwo6Row21,
    'Five_+2_6_2_1': fivePlusTwo6Row21,
    'Five_+2_6_2_2': fivePlusTwo6Row22,

    'Five_+3_4_1_1': fivePlusThree4Row11,
    'Five_+3_4_1_2': fivePlusThree4Row21,
    'Five_+3_4_2_1': fivePlusThree4Row21,
    'Five_+3_4_2_2': fivePlusThree4Row22,
    'Five_+3_5_1_1': fivePlusThree5Row11,
    'Five_+3_5_1_2': fivePlusThree5Row21,
    'Five_+3_5_2_1': fivePlusThree5Row21,
    'Five_+3_5_2_2': fivePlusThree5Row22,
    'Five_+3_6_1_1': fivePlusThree6Row11,
    'Five_+3_6_1_2': fivePlusThree6Row21,
    'Five_+3_6_2_1': fivePlusThree6Row21,
    'Five_+3_6_2_2': fivePlusThree6Row22,

    'Five_+4_4_1_1': fivePlusFour4Row11,
    'Five_+4_4_1_2': fivePlusFour4Row21,
    'Five_+4_4_2_1': fivePlusFour4Row21,
    'Five_+4_4_2_2': fivePlusFour4Row22,
    'Five_+4_5_1_1': fivePlusFour5Row11,
    'Five_+4_5_1_2': fivePlusFour5Row21,
    'Five_+4_5_2_1': fivePlusFour5Row21,
    'Five_+4_5_2_2': fivePlusFour5Row22,
    'Five_+4_6_1_1': fivePlusFour6Row11,
    'Five_+4_6_1_2': fivePlusFour6Row21,
    'Five_+4_6_2_1': fivePlusFour6Row21,
    'Five_+4_6_2_2': fivePlusFour6Row22,

    'Random_Lesson_Five_+_4_1_1': randomFivePlus4Row11,
    'Random_Lesson_Five_+_4_1_2': randomFivePlus4Row21,
    'Random_Lesson_Five_+_4_2_1': randomFivePlus4Row21,
    'Random_Lesson_Five_+_4_2_2': randomFivePlus4Row22,
    'Random_Lesson_Five_+_5_1_1': randomFivePlus5Row11,
    'Random_Lesson_Five_+_5_1_2': randomFivePlus5Row21,
    'Random_Lesson_Five_+_5_2_1': randomFivePlus5Row21,
    'Random_Lesson_Five_+_5_2_2': randomFivePlus5Row22,
    'Random_Lesson_Five_+_6_1_1': randomFivePlus6Row11,
    'Random_Lesson_Five_+_6_1_2': randomFivePlus6Row21,
    'Random_Lesson_Five_+_6_2_1': randomFivePlus6Row21,
    'Random_Lesson_Five_+_6_2_2': randomFivePlus6Row22,

    'Five_-4_4_1_1': fiveMinusFour4Row11,
    'Five_-4_4_1_2': fiveMinusFour4Row21,
    'Five_-4_4_2_1': fiveMinusFour4Row21,
    'Five_-4_4_2_2': fiveMinusFour4Row22,
    'Five_-4_5_1_1': fiveMinusFour5Row11,
    'Five_-4_5_1_2': fiveMinusFour5Row21,
    'Five_-4_5_2_1': fiveMinusFour5Row21,
    'Five_-4_5_2_2': fiveMinusFour5Row22,
    'Five_-4_6_1_1': fiveMinusFour6Row11,
    'Five_-4_6_1_2': fiveMinusFour6Row21,
    'Five_-4_6_2_1': fiveMinusFour6Row21,
    'Five_-4_6_2_2': fiveMinusFour6Row22,

    'Five_-3_4_1_1': fiveMinusThree4Row11,
    'Five_-3_4_1_2': fiveMinusThree4Row21,
    'Five_-3_4_2_1': fiveMinusThree4Row21,
    'Five_-3_4_2_2': fiveMinusThree4Row22,
    'Five_-3_5_1_1': fiveMinusThree5Row11,
    'Five_-3_5_1_2': fiveMinusThree5Row21,
    'Five_-3_5_2_1': fiveMinusThree5Row21,
    'Five_-3_5_2_2': fiveMinusThree5Row22,
    'Five_-3_6_1_1': fiveMinusThree6Row11,
    'Five_-3_6_1_2': fiveMinusThree6Row21,
    'Five_-3_6_2_1': fiveMinusThree6Row21,
    'Five_-3_6_2_2': fiveMinusThree6Row22,

    'Five_-2_4_1_1': fiveMinusTwo4Row11,
    'Five_-2_4_1_2': fiveMinusTwo4Row21,
    'Five_-2_4_2_1': fiveMinusTwo4Row21,
    'Five_-2_4_2_2': fiveMinusTwo4Row22,
    'Five_-2_5_1_1': fiveMinusTwo5Row11,
    'Five_-2_5_1_2': fiveMinusTwo5Row21,
    'Five_-2_5_2_1': fiveMinusTwo5Row21,
    'Five_-2_5_2_2': fiveMinusTwo5Row22,
    'Five_-2_6_1_1': fiveMinusTwo6Row11,
    'Five_-2_6_1_2': fiveMinusTwo6Row21,
    'Five_-2_6_2_1': fiveMinusTwo6Row21,
    'Five_-2_6_2_2': fiveMinusTwo6Row22,

    'Five_-1_4_1_1': fiveMinusOne4Row11,
    'Five_-1_4_1_2': fiveMinusOne4Row21,
    'Five_-1_4_2_1': fiveMinusOne4Row21,
    'Five_-1_4_2_2': fiveMinusOne4Row22,
    'Five_-1_5_1_1': fiveMinusOne5Row11,
    'Five_-1_5_1_2': fiveMinusOne5Row21,
    'Five_-1_5_2_1': fiveMinusOne5Row21,
    'Five_-1_5_2_2': fiveMinusOne5Row22,
    'Five_-1_6_1_1': fiveMinusOne6Row11,
    'Five_-1_6_1_2': fiveMinusOne6Row21,
    'Five_-1_6_2_1': fiveMinusOne6Row21,
    'Five_-1_6_2_2': fiveMinusOne6Row22,

    'Random_Lesson_Five_-_4_1_1': randomFiveMinus4Row11,
    'Random_Lesson_Five_-_4_1_2': randomFiveMinus4Row21,
    'Random_Lesson_Five_-_4_2_1': randomFiveMinus4Row21,
    'Random_Lesson_Five_-_4_2_2': randomFiveMinus4Row22,
    'Random_Lesson_Five_-_5_1_1': randomFiveMinus5Row11,
    'Random_Lesson_Five_-_5_1_2': randomFiveMinus5Row21,
    'Random_Lesson_Five_-_5_2_1': randomFiveMinus5Row21,
    'Random_Lesson_Five_-_5_2_2': randomFiveMinus5Row22,
    'Random_Lesson_Five_-_6_1_1': randomFiveMinus6Row11,
    'Random_Lesson_Five_-_6_1_2': randomFiveMinus6Row21,
    'Random_Lesson_Five_-_6_2_1': randomFiveMinus6Row21,
    'Random_Lesson_Five_-_6_2_2': randomFiveMinus6Row22,
  };

  List<dynamic> _getList() {
    final currentMenu = widget.setting.selectedSubOptionLabel.replaceAll(
      ' ',
      '_',
    );
    final currentRow = widget.setting.row;
    final currentD1 = widget.setting.digit1;
    final currentD2 = widget.setting.digit2;
    final key = '${currentMenu}_${currentRow}_${currentD1}_$currentD2';
    return _dataMap[key] ?? [];
  }

  void _generateRandomNumbers() {
    final row = int.tryParse(widget.setting.row) ?? 3;

    numbers = [];

    if (row == 4) {
      _randomQuestion4rows();
    } else if (row == 5) {
      _randomQuestion5rows();
    } else if (row == 6) {
      _randomQuestion6rows();
    } else {
      return;
    }

    currentStep = 0;
    showAnswer = false;
    waitingToShowAnswer = false;
    showSmallWrongIcon = false;
    showAnswerText = false;
    isAnswerCorrect = false;
    hasCheckedAnswer = false;
    inputAnsController.clear();
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

  void _randomQuestion4rows() {
    FourDigit? currentQ;
    RandomQuestionRow selector = RandomQuestionRow(questions: _getList());
    selector.selectRandomQuestion();
    currentQ = selector.getCurrentQuestion();

    if (currentQ != null) {
      numbers.add(currentQ.digit1);
      numbers.add(currentQ.digit2);
      numbers.add(currentQ.digit3);
      numbers.add(currentQ.digit4);
      answer = currentQ.ans;
    }
  }

  void _randomQuestion5rows() {
    FiveDigit? currentQ;
    RandomQuestionRow selector = RandomQuestionRow(questions: _getList());
    selector.selectRandomQuestion();
    currentQ = selector.getCurrentQuestion();

    if (currentQ != null) {
      numbers.add(currentQ.digit1);
      numbers.add(currentQ.digit2);
      numbers.add(currentQ.digit3);
      numbers.add(currentQ.digit4);
      numbers.add(currentQ.digit5);
      answer = currentQ.ans;
    }
  }

  void _randomQuestion6rows() {
    SixDigit? currentQ;
    RandomQuestionRow selector = RandomQuestionRow(questions: _getList());
    selector.selectRandomQuestion();
    currentQ = selector.getCurrentQuestion();

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
      hasCheckedAnswer = false; // Reset when starting flash card
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
      _playTikSound();
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

  void _checkAnswer() {
    String input = inputAnsController.text.replaceAll(',', '');
    ;
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
      shouldContinueFlashCard = !isPaused; // Control the animation loop
    });
    if (!isPaused) {
      _startFlashCard(); // Resume the flashcard animation if unpaused
    }
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
