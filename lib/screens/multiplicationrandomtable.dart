import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final auth = FirebaseAuth.instance;
  bool isPaused = false;
  bool isSoundOn = true;

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
    super.dispose();
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
  }

  void _nextQuestion() {
    setState(() {
      _generateRandomNumbers(); // 🔁 สุ่มคำถามใหม่
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      userName: auth.currentUser?.email?.split('@').first ?? '',
      avatarImg: null,
      displayMode: '',
      inputAnsController: TextEditingController(),
      onNextPressed: _submitAnswers,
      onNextsPressed: _nextQuestion,
      onCheckPressed: _submitAnswers,
      showRightButtons: true,
      onPlayPauseFlashCard: null,
      isPaused: isPaused,
      currentStep: 0,
      totalNumbers: numbers.length,
      isFlashCardAnimating: false,
      showAnswer: false,
      showAnswerText: false,
      showAnswerInput: false,
      waitingToShowAnswer: false,
      showSmallWrongIcon: false,
      answerText: '',
      currentMenuImage: 'assets/images/multiplicationrandomtable.png',
      isShowMode: false,
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
                          color: Colors.black.withOpacity(0.1),
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

      // child: numbers.isEmpty
      //     ? const NoDataScreen()
      //     : Container(
      //         margin: const EdgeInsets.only(
      //           left: 180,
      //           right: 250,
      //           top: 60,
      //           bottom: 10,
      //         ),
      //         height: 350,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(7),
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.black.withOpacity(0.1),
      //               blurRadius: 20,
      //               offset: Offset(0, 8),
      //               spreadRadius: 2,
      //             ),
      //           ],
      //         ),
      //         child: Column(
      //           children: [
      //             _buildHeaderRow(),
      //             Expanded(
      //               child: SingleChildScrollView(
      //                 child: Column(
      //                   children: List.generate(
      //                     questionLimit,
      //                     _buildQuestionRow,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      onBackPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Confirm Back"),
            content: const Text(
              "Are you sure you want to leave this exercise?",
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Back"),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
              ),
            ],
          ),
        );
      },
      onExitPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                child: const Text("Exit"),
                onPressed: () {
                  Navigator.pop(context);
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
