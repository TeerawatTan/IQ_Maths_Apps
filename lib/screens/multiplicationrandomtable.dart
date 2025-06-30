import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/no_data.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/widget_wrapper.dart';

class MultiplicationRandomTableScreen extends StatefulWidget {
  final MathsSetting setting;

  const MultiplicationRandomTableScreen({super.key, required this.setting});

  @override
  State<MultiplicationRandomTableScreen> createState() =>
      _MultiplicationRandomTableScreenState();
}

class _MultiplicationRandomTableScreenState
    extends State<MultiplicationRandomTableScreen> {
  int currentIndex = 0;
  final int questionLimit = 10;
  List<List<int>> numbers = [];
  List<TextEditingController> controllers = [];
  List<bool?> answerStatus = [];
  bool isPaused = false;
  bool isSoundOn = true;
  bool isAnswerChecked = false;
  bool hasCheckedAnswer = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    widget.setting.display = "show all";
    _generateRandomNumbers();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    audioPlayer.dispose();
    super.dispose();
  }

  void _playTikSound() async {
    if (isSoundOn) {
      await audioPlayer.stop();
      audioPlayer.play(AssetSource('files/sound_tik.mp3'));
    }
  }

  void _generateRandomNumbers() {
    final digit1 = int.tryParse(widget.setting.digit1) ?? 1;
    final digit2 = int.tryParse(widget.setting.digit2) ?? 1;

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

    controllers = List.generate(questionLimit, (_) => TextEditingController());
    answerStatus = List.generate(questionLimit, (_) => null);
    isAnswerChecked = false;
    hasCheckedAnswer = false;

    _playTikSound();
  }

  void _checkAnswers() {
    setState(() {
      for (int i = 0; i < questionLimit; i++) {
        final correct = numbers[i][0] * numbers[i][1];
        final userInput = int.tryParse(controllers[i].text.trim());

        if (userInput != null && userInput == correct) {
          answerStatus[i] = true;
        } else {
          answerStatus[i] = false;
        }
      }
      isAnswerChecked = true;
      hasCheckedAnswer = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _generateRandomNumbers();
      currentIndex = 0;
      controllers = List.generate(
        questionLimit,
        (_) => TextEditingController(),
      );
    });
  }

  void _submitAnswers() {
    int correctAnswers = 0;
    for (int i = 0; i < questionLimit; i++) {
      final correct = numbers[i][0] * numbers[i][1];
      final userInput = int.tryParse(controllers[i].text.trim());
      if (userInput != null && userInput == correct) {
        correctAnswers++;
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(answerCorrect: correctAnswers),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8A2D1), Color(0xFFF8A2D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      child: Row(
        children: const [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  'No',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: Colors.white30),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  'Question',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: Colors.white30),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  'Answer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionRow(int index) {
    final a = numbers[index][0];
    final b = numbers[index][1];
    final isEven = index % 2 == 0;
    final isLast = index == questionLimit - 1;

    return Container(
      decoration: BoxDecoration(
        color: isEven ? Colors.grey.shade50 : Colors.white,
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 28, color: Colors.grey.shade700),
              ),
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade200),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '$a × $b',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade200),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 4.0,
              ),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '=',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    if (answerStatus[index] != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // แสดงไอคอนผลลัพธ์
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.asset(
                              answerStatus[index]!
                                  ? 'assets/images/correct.png'
                                  : 'assets/images/wrong.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          // แสดงเฉลยถ้าตอบผิด
                          if (answerStatus[index] == false)
                            Text(
                              '${numbers[index][0] * numbers[index][1]}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    return WidgetWrapper(
      displayMode: '',
      inputAnsController: TextEditingController(),
      onNextPressed: _submitAnswers,
      onCheckPressed: _checkAnswers,
      onNextsPressed: _nextQuestion,
      onPlayPauseFlashCard: null,
      isPaused: isPaused,
      currentStep: 0,
      totalNumbers: numbers.length,
      isFlashCardAnimating: false,
      showAnswer: false,
      showAnswerText: false,
      showAnswerInput: true,
      waitingToShowAnswer: false,
      showSmallWrongIcon: false,
      answerText: '',
      currentMenuButtonLabel: _getCurrentMenuLabel(),
      isShowMode: false,
      hasCheckedAnswer: hasCheckedAnswer,
      isAnswerCorrect: false,
      hideAnsLabel: true, // ซ่อน "Ans" label
      child: numbers.isEmpty
          ? const NoDataScreen()
          : LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final deviceType =
                    MediaQuery.of(context).size.shortestSide < 600
                    ? 'phone'
                    : 'tablet';

                EdgeInsets containerMargin;
                double containerHeight;

                if (deviceType == 'phone') {
                  if (width < 400) {
                    containerMargin = const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 60,
                    );
                    containerHeight = 420;
                  } else if (width < 600) {
                    containerMargin = const EdgeInsets.only(
                      left: 50,
                      right: 40,
                      top: 40,
                      bottom: 20,
                    );
                    containerHeight = 430;
                  } else if (width < 800) {
                    containerMargin = const EdgeInsets.only(
                      left: 220,
                      right: 160,
                      top: 60,
                      bottom: 20,
                    );
                    containerHeight = 430;
                  } else {
                    // Pixel 6 (แนวตั้ง) หรือจอใหญ่
                    containerMargin = const EdgeInsets.only(
                      left: 220,
                      right: 220,
                      top: 60,
                      bottom: 10,
                    );
                    containerHeight = 440;
                  }
                } else {
                  // Tablet
                  containerMargin = const EdgeInsets.symmetric(
                    horizontal: 230,
                    vertical: 30,
                  );
                  containerHeight = 530;
                }

                return Center(
                  child: Container(
                    margin: containerMargin,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((255.0 * 0.1).round()),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildHeaderRow(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                questionLimit,
                                _buildQuestionRow,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
