import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/no_data.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/widget_wrapper.dart';

class TenCoupleScreen extends StatefulWidget {
  final MathsSetting setting;

  const TenCoupleScreen({super.key, required this.setting});

  @override
  State<TenCoupleScreen> createState() => _TenCoupleScreenState();
}

class _TenCoupleScreenState extends State<TenCoupleScreen> {
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
      await audioPlayer.play(AssetSource('files/sound_tik.mp3'));
    }
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
    //   numbers.add(currentQ.digit1);
    //   numbers.add(currentQ.digit2);
    //   numbers.add(currentQ.digit3);
    //   answer = currentQ.ans;
    // }
  }

  void _randomQuestion4rows(int d1, int d2) {
    // FiveTen4Row? currentQ;
    // if (d1 == 1) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour4Row11);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour4Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 2) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour4Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour4Row22);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // }
    // if (currentQ != null) {
    //   numbers.add(currentQ.digit1);
    //   numbers.add(currentQ.digit2);
    //   numbers.add(currentQ.digit3);
    //   numbers.add(currentQ.digit4);
    //   answer = currentQ.ans;
    // }
  }

  void _randomQuestion5rows(int d1, int d2) {
    // FiveTen5Row? currentQ;
    // if (d1 == 1) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour5Row11);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour5Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 2) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour5Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour5Row22);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // }
    // if (currentQ != null) {
    //   numbers.add(currentQ.digit1);
    //   numbers.add(currentQ.digit2);
    //   numbers.add(currentQ.digit3);
    //   numbers.add(currentQ.digit4);
    //   numbers.add(currentQ.digit5);
    //   answer = currentQ.ans;
    // }
  }

  void _randomQuestion6rows(int d1, int d2) {
    // FiveTen6Row? currentQ;
    // if (d1 == 1) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour6Row11);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour6Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // } else if (d1 == 2) {
    //   if (d2 == 1) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour6Row21);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   } else if (d2 == 2) {
    //     RandomQuestionRow selector = RandomQuestionRow(questions: fivePlusFour6Row22);
    //     selector.selectRandomQuestion();
    //     currentQ = selector.getCurrentQuestion();
    //   }
    // }
    // if (currentQ != null) {
    //   numbers.add(currentQ.digit1);
    //   numbers.add(currentQ.digit2);
    //   numbers.add(currentQ.digit3);
    //   numbers.add(currentQ.digit4);
    //   numbers.add(currentQ.digit5);
    //   numbers.add(currentQ.digit6);
    //   answer = currentQ.ans;
    // }
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
      setState(() {
        currentStep = i; // Update currentStep to the number being displayed
      });
      _playTikSound();
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
