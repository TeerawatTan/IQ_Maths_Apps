import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/datas/five_and_ten_minus_eight.dart';
import 'package:iq_maths_apps/datas/five_and_ten_minus_nine.dart';
import 'package:iq_maths_apps/datas/five_and_ten_plus_eight.dart';
import 'package:iq_maths_apps/datas/five_and_ten_plus_nine.dart';
import 'package:iq_maths_apps/datas/five_and_ten_plus_seven.dart';
import 'package:iq_maths_apps/datas/five_and_ten_plus_six.dart';
import 'package:iq_maths_apps/datas/random_five_and_ten_plus.dart';
import 'package:iq_maths_apps/datas/random_ten_minus.dart';
import 'package:iq_maths_apps/datas/random_ten_plus.dart';
import 'package:iq_maths_apps/datas/ten_minus_eight.dart';
import 'package:iq_maths_apps/datas/ten_minus_nine.dart';
import 'package:iq_maths_apps/datas/ten_minus_seven.dart';
import 'package:iq_maths_apps/datas/ten_plus_eight.dart';
import 'package:iq_maths_apps/datas/ten_plus_five.dart';
import 'package:iq_maths_apps/datas/ten_plus_four.dart';
import 'package:iq_maths_apps/datas/ten_plus_nine.dart';
import 'package:iq_maths_apps/datas/ten_plus_one.dart';
import 'package:iq_maths_apps/datas/ten_plus_seven.dart';
import 'package:iq_maths_apps/datas/ten_plus_six.dart';
import 'package:iq_maths_apps/datas/ten_plus_three.dart';
import 'package:iq_maths_apps/datas/ten_plus_two.dart';
import 'package:iq_maths_apps/helpers/random_question.dart';
import 'package:iq_maths_apps/models/digit_model.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';
import 'package:iq_maths_apps/screens/no_data.dart';
import 'package:iq_maths_apps/screens/summary.dart';
import 'package:iq_maths_apps/widgets/animated_outlined_text.dart';
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

  void _generateRandomNumbers() {
    final digit1 = int.tryParse(widget.setting.digit1) ?? 1;
    final digit2 = int.tryParse(widget.setting.digit2) ?? 1;
    final row = int.tryParse(widget.setting.row) ?? 3;

    numbers = [];

    if (row == 4) {
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

  final Map<String, List<dynamic>> _dataMap = {
    'Ten_+9_4_1_1': tenPlusNine4Row11,
    'Ten_+9_4_1_2': tenPlusNine4Row21,
    'Ten_+9_4_2_1': tenPlusNine4Row21,
    'Ten_+9_4_2_2': tenPlusNine4Row22,
    'Ten_+9_5_1_1': tenPlusNine5Row11,
    'Ten_+9_5_1_2': tenPlusNine5Row21,
    'Ten_+9_5_2_1': tenPlusNine5Row21,
    'Ten_+9_5_2_2': tenPlusNine5Row22,
    'Ten_+9_6_1_1': tenPlusNine6Row11,
    'Ten_+9_6_1_2': tenPlusNine6Row21,
    'Ten_+9_6_2_1': tenPlusNine6Row21,
    'Ten_+9_6_2_2': tenPlusNine6Row22,

    'Ten_+8_4_1_1': tenPlusEight4Row11,
    'Ten_+8_4_1_2': tenPlusEight4Row21,
    'Ten_+8_4_2_1': tenPlusEight4Row21,
    'Ten_+8_4_2_2': tenPlusEight4Row22,
    'Ten_+8_5_1_1': tenPlusEight5Row11,
    'Ten_+8_5_1_2': tenPlusEight5Row21,
    'Ten_+8_5_2_1': tenPlusEight5Row21,
    'Ten_+8_5_2_2': tenPlusEight5Row22,
    'Ten_+8_6_1_1': tenPlusEight6Row11,
    'Ten_+8_6_1_2': tenPlusEight6Row21,
    'Ten_+8_6_2_1': tenPlusEight6Row21,
    'Ten_+8_6_2_2': tenPlusEight6Row22,

    'Ten_+7_4_1_1': tenPlusSeven4Row11,
    'Ten_+7_4_1_2': tenPlusSeven4Row21,
    'Ten_+7_4_2_1': tenPlusSeven4Row21,
    'Ten_+7_4_2_2': tenPlusSeven4Row22,
    'Ten_+7_5_1_1': tenPlusSeven5Row11,
    'Ten_+7_5_1_2': tenPlusSeven5Row21,
    'Ten_+7_5_2_1': tenPlusSeven5Row21,
    'Ten_+7_5_2_2': tenPlusSeven5Row22,
    'Ten_+7_6_1_1': tenPlusSeven6Row11,
    'Ten_+7_6_1_2': tenPlusSeven6Row21,
    'Ten_+7_6_2_1': tenPlusSeven6Row21,
    'Ten_+7_6_2_2': tenPlusSeven6Row22,

    'Ten_+6_4_1_1': tenPlusSix4Row11,
    'Ten_+6_4_1_2': tenPlusSix4Row21,
    'Ten_+6_4_2_1': tenPlusSix4Row21,
    'Ten_+6_4_2_2': tenPlusSix4Row22,
    'Ten_+6_5_1_1': tenPlusSix5Row11,
    'Ten_+6_5_1_2': tenPlusSix5Row21,
    'Ten_+6_5_2_1': tenPlusSix5Row21,
    'Ten_+6_5_2_2': tenPlusSix5Row22,
    'Ten_+6_6_1_1': tenPlusSix6Row11,
    'Ten_+6_6_1_2': tenPlusSix6Row21,
    'Ten_+6_6_2_1': tenPlusSix6Row21,
    'Ten_+6_6_2_2': tenPlusSix6Row22,

    'Ten_+5_4_1_1': tenPlusFive4Row11,
    'Ten_+5_4_1_2': tenPlusFive4Row21,
    'Ten_+5_4_2_1': tenPlusFive4Row21,
    'Ten_+5_4_2_2': tenPlusFive4Row22,
    'Ten_+5_5_1_1': tenPlusFive5Row11,
    'Ten_+5_5_1_2': tenPlusFive5Row21,
    'Ten_+5_5_2_1': tenPlusFive5Row21,
    'Ten_+5_5_2_2': tenPlusFive5Row22,
    'Ten_+5_6_1_1': tenPlusFive6Row11,
    'Ten_+5_6_1_2': tenPlusFive6Row21,
    'Ten_+5_6_2_1': tenPlusFive6Row21,
    'Ten_+5_6_2_2': tenPlusFive6Row22,

    'Ten_+4_4_1_1': tenPlusFour4Row11,
    'Ten_+4_4_1_2': tenPlusFour4Row21,
    'Ten_+4_4_2_1': tenPlusFour4Row21,
    'Ten_+4_4_2_2': tenPlusFour4Row22,
    'Ten_+4_5_1_1': tenPlusFour5Row11,
    'Ten_+4_5_1_2': tenPlusFour5Row21,
    'Ten_+4_5_2_1': tenPlusFour5Row21,
    'Ten_+4_5_2_2': tenPlusFour5Row22,
    'Ten_+4_6_1_1': tenPlusFour6Row11,
    'Ten_+4_6_1_2': tenPlusFour6Row21,
    'Ten_+4_6_2_1': tenPlusFour6Row21,
    'Ten_+4_6_2_2': tenPlusFour6Row22,

    'Ten_+3_4_1_1': tenPlusThree4Row11,
    'Ten_+3_4_1_2': tenPlusThree4Row21,
    'Ten_+3_4_2_1': tenPlusThree4Row21,
    'Ten_+3_4_2_2': tenPlusThree4Row22,
    'Ten_+3_5_1_1': tenPlusThree5Row11,
    'Ten_+3_5_1_2': tenPlusThree5Row21,
    'Ten_+3_5_2_1': tenPlusThree5Row21,
    'Ten_+3_5_2_2': tenPlusThree5Row22,
    'Ten_+3_6_1_1': tenPlusThree6Row11,
    'Ten_+3_6_1_2': tenPlusThree6Row21,
    'Ten_+3_6_2_1': tenPlusThree6Row21,
    'Ten_+3_6_2_2': tenPlusThree6Row22,

    'Ten_+2_4_1_1': tenPlusTwo4Row11,
    'Ten_+2_4_1_2': tenPlusTwo4Row21,
    'Ten_+2_4_2_1': tenPlusTwo4Row21,
    'Ten_+2_4_2_2': tenPlusTwo4Row22,
    'Ten_+2_5_1_1': tenPlusTwo5Row11,
    'Ten_+2_5_1_2': tenPlusTwo5Row21,
    'Ten_+2_5_2_1': tenPlusTwo5Row21,
    'Ten_+2_5_2_2': tenPlusTwo5Row22,
    'Ten_+2_6_1_1': tenPlusTwo6Row11,
    'Ten_+2_6_1_2': tenPlusTwo6Row21,
    'Ten_+2_6_2_1': tenPlusTwo6Row21,
    'Ten_+2_6_2_2': tenPlusTwo6Row22,

    'Ten_+1_4_1_1': tenPlusOne4Row11,
    'Ten_+1_4_1_2': tenPlusOne4Row21,
    'Ten_+1_4_2_1': tenPlusOne4Row21,
    'Ten_+1_4_2_2': tenPlusOne4Row22,
    'Ten_+1_5_1_1': tenPlusOne5Row11,
    'Ten_+1_5_1_2': tenPlusOne5Row21,
    'Ten_+1_5_2_1': tenPlusOne5Row21,
    'Ten_+1_5_2_2': tenPlusOne5Row22,
    'Ten_+1_6_1_1': tenPlusOne6Row11,
    'Ten_+1_6_1_2': tenPlusOne6Row21,
    'Ten_+1_6_2_1': tenPlusOne6Row21,
    'Ten_+1_6_2_2': tenPlusOne6Row22,

    'Random_Lesson_Ten_+_4_1_1': randomTenPlus4Row11,
    'Random_Lesson_Ten_+_4_1_2': randomTenPlus4Row21,
    'Random_Lesson_Ten_+_4_2_1': randomTenPlus4Row21,
    'Random_Lesson_Ten_+_4_2_2': randomTenPlus4Row22,
    'Random_Lesson_Ten_+_5_1_1': randomTenPlus5Row11,
    'Random_Lesson_Ten_+_5_1_2': randomTenPlus5Row21,
    'Random_Lesson_Ten_+_5_2_1': randomTenPlus5Row21,
    'Random_Lesson_Ten_+_5_2_2': randomTenPlus5Row22,
    'Random_Lesson_Ten_+_6_1_1': randomTenPlus6Row11,
    'Random_Lesson_Ten_+_6_1_2': randomTenPlus6Row21,
    'Random_Lesson_Ten_+_6_2_1': randomTenPlus6Row21,
    'Random_Lesson_Ten_+_6_2_2': randomTenPlus6Row22,

    'Ten_-9_4_1_1': tenMinusNine4Row11,
    'Ten_-9_4_1_2': tenMinusNine4Row21,
    'Ten_-9_4_2_1': tenMinusNine4Row21,
    'Ten_-9_4_2_2': tenMinusNine4Row22,
    'Ten_-9_5_1_1': tenMinusNine5Row11,
    'Ten_-9_5_1_2': tenMinusNine5Row21,
    'Ten_-9_5_2_1': tenMinusNine5Row21,
    'Ten_-9_5_2_2': tenMinusNine5Row22,
    'Ten_-9_6_1_1': tenMinusNine6Row11,
    'Ten_-9_6_1_2': tenMinusNine6Row21,
    'Ten_-9_6_2_1': tenMinusNine6Row21,
    'Ten_-9_6_2_2': tenMinusNine6Row22,

    'Ten_-8_4_1_1': tenMinusEight4Row11,
    'Ten_-8_4_1_2': tenMinusEight4Row21,
    'Ten_-8_4_2_1': tenMinusEight4Row21,
    'Ten_-8_4_2_2': tenMinusEight4Row22,
    'Ten_-8_5_1_1': tenMinusEight5Row11,
    'Ten_-8_5_1_2': tenMinusEight5Row21,
    'Ten_-8_5_2_1': tenMinusEight5Row21,
    'Ten_-8_5_2_2': tenMinusEight5Row22,
    'Ten_-8_6_1_1': tenMinusEight6Row11,
    'Ten_-8_6_1_2': tenMinusEight6Row21,
    'Ten_-8_6_2_1': tenMinusEight6Row21,
    'Ten_-8_6_2_2': tenMinusEight6Row22,

    'Ten_-7_4_1_1': tenMinusSeven4Row11,
    'Ten_-7_4_1_2': tenMinusSeven4Row21,
    'Ten_-7_4_2_1': tenMinusSeven4Row21,
    'Ten_-7_4_2_2': tenMinusSeven4Row22,
    'Ten_-7_5_1_1': tenMinusSeven5Row11,
    'Ten_-7_5_1_2': tenMinusSeven5Row21,
    'Ten_-7_5_2_1': tenMinusSeven5Row21,
    'Ten_-7_5_2_2': tenMinusSeven5Row22,
    'Ten_-7_6_1_1': tenMinusSeven6Row11,
    'Ten_-7_6_1_2': tenMinusSeven6Row21,
    'Ten_-7_6_2_1': tenMinusSeven6Row21,
    'Ten_-7_6_2_2': tenMinusSeven6Row22,

    'Five&Ten_-9_4_1_1': fiveTenMinusNine4Row11,
    'Five&Ten_-9_4_1_2': fiveTenMinusNine4Row21,
    'Five&Ten_-9_4_2_1': fiveTenMinusNine4Row21,
    'Five&Ten_-9_4_2_2': fiveTenMinusNine4Row22,
    'Five&Ten_-9_5_1_1': fiveTenMinusNine5Row11,
    'Five&Ten_-9_5_1_2': fiveTenMinusNine5Row21,
    'Five&Ten_-9_5_2_1': fiveTenMinusNine5Row21,
    'Five&Ten_-9_5_2_2': fiveTenMinusNine5Row22,
    'Five&Ten_-9_6_1_1': fiveTenMinusNine6Row11,
    'Five&Ten_-9_6_1_2': fiveTenMinusNine6Row21,
    'Five&Ten_-9_6_2_1': fiveTenMinusNine6Row21,
    'Five&Ten_-9_6_2_2': fiveTenMinusNine6Row22,

    'Five&Ten_-8_4_1_1': fiveTenMinusEight4Row11,
    'Five&Ten_-8_4_1_2': fiveTenMinusEight4Row21,
    'Five&Ten_-8_4_2_1': fiveTenMinusEight4Row21,
    'Five&Ten_-8_4_2_2': fiveTenMinusEight4Row22,
    'Five&Ten_-8_5_1_1': fiveTenMinusEight5Row11,
    'Five&Ten_-8_5_1_2': fiveTenMinusEight5Row21,
    'Five&Ten_-8_5_2_1': fiveTenMinusEight5Row21,
    'Five&Ten_-8_5_2_2': fiveTenMinusEight5Row22,
    'Five&Ten_-8_6_1_1': fiveTenMinusEight6Row11,
    'Five&Ten_-8_6_1_2': fiveTenMinusEight6Row21,
    'Five&Ten_-8_6_2_1': fiveTenMinusEight6Row21,
    'Five&Ten_-8_6_2_2': fiveTenMinusEight6Row22,

    'Five&Ten_+9_4_1_1': fiveTenPlusNine4Row11,
    'Five&Ten_+9_4_1_2': fiveTenPlusNine4Row21,
    'Five&Ten_+9_4_2_1': fiveTenPlusNine4Row21,
    'Five&Ten_+9_4_2_2': fiveTenPlusNine4Row22,
    'Five&Ten_+9_5_1_1': fiveTenPlusNine5Row11,
    'Five&Ten_+9_5_1_2': fiveTenPlusNine5Row21,
    'Five&Ten_+9_5_2_1': fiveTenPlusNine5Row21,
    'Five&Ten_+9_5_2_2': fiveTenPlusNine5Row22,
    'Five&Ten_+9_6_1_1': fiveTenPlusNine6Row11,
    'Five&Ten_+9_6_1_2': fiveTenPlusNine6Row21,
    'Five&Ten_+9_6_2_1': fiveTenPlusNine6Row21,
    'Five&Ten_+9_6_2_2': fiveTenPlusNine6Row22,

    'Five&Ten_+8_4_1_1': fiveTenPlusEight4Row11,
    'Five&Ten_+8_4_1_2': fiveTenPlusEight4Row21,
    'Five&Ten_+8_4_2_1': fiveTenPlusEight4Row21,
    'Five&Ten_+8_4_2_2': fiveTenPlusEight4Row22,
    'Five&Ten_+8_5_1_1': fiveTenPlusEight5Row11,
    'Five&Ten_+8_5_1_2': fiveTenPlusEight5Row21,
    'Five&Ten_+8_5_2_1': fiveTenPlusEight5Row21,
    'Five&Ten_+8_5_2_2': fiveTenPlusEight5Row22,
    'Five&Ten_+8_6_1_1': fiveTenPlusEight6Row11,
    'Five&Ten_+8_6_1_2': fiveTenPlusEight6Row21,
    'Five&Ten_+8_6_2_1': fiveTenPlusEight6Row21,
    'Five&Ten_+8_6_2_2': fiveTenPlusEight6Row22,

    'Five&Ten_+7_4_1_1': fiveTenPlusSeven4Row11,
    'Five&Ten_+7_4_1_2': fiveTenPlusSeven4Row21,
    'Five&Ten_+7_4_2_1': fiveTenPlusSeven4Row21,
    'Five&Ten_+7_4_2_2': fiveTenPlusSeven4Row22,
    'Five&Ten_+7_5_1_1': fiveTenPlusSeven5Row11,
    'Five&Ten_+7_5_1_2': fiveTenPlusSeven5Row21,
    'Five&Ten_+7_5_2_1': fiveTenPlusSeven5Row21,
    'Five&Ten_+7_5_2_2': fiveTenPlusSeven5Row22,
    'Five&Ten_+7_6_1_1': fiveTenPlusSeven6Row11,
    'Five&Ten_+7_6_1_2': fiveTenPlusSeven6Row21,
    'Five&Ten_+7_6_2_1': fiveTenPlusSeven6Row21,
    'Five&Ten_+7_6_2_2': fiveTenPlusSeven6Row22,

    'Five&Ten_+6_4_1_1': fiveTenPlusSix4Row11,
    'Five&Ten_+6_4_1_2': fiveTenPlusSix4Row21,
    'Five&Ten_+6_4_2_1': fiveTenPlusSix4Row21,
    'Five&Ten_+6_4_2_2': fiveTenPlusSix4Row22,
    'Five&Ten_+6_5_1_1': fiveTenPlusSix5Row11,
    'Five&Ten_+6_5_1_2': fiveTenPlusSix5Row21,
    'Five&Ten_+6_5_2_1': fiveTenPlusSix5Row21,
    'Five&Ten_+6_5_2_2': fiveTenPlusSix5Row22,
    'Five&Ten_+6_6_1_1': fiveTenPlusSix6Row11,
    'Five&Ten_+6_6_1_2': fiveTenPlusSix6Row21,
    'Five&Ten_+6_6_2_1': fiveTenPlusSix6Row21,
    'Five&Ten_+6_6_2_2': fiveTenPlusSix6Row22,

    'Random_Lesson_Five&Ten_+_4_1_1': randomFiveTenPlus4Row11,
    'Random_Lesson_Five&Ten_+_4_1_2': randomFiveTenPlus4Row21,
    'Random_Lesson_Five&Ten_+_4_2_1': randomFiveTenPlus4Row21,
    'Random_Lesson_Five&Ten_+_4_2_2': randomFiveTenPlus4Row22,
    'Random_Lesson_Five&Ten_+_5_1_1': randomFiveTenPlus5Row11,
    'Random_Lesson_Five&Ten_+_5_1_2': randomFiveTenPlus5Row21,
    'Random_Lesson_Five&Ten_+_5_2_1': randomFiveTenPlus5Row21,
    'Random_Lesson_Five&Ten_+_5_2_2': randomFiveTenPlus5Row22,
    'Random_Lesson_Five&Ten_+_6_1_1': randomFiveTenPlus6Row11,
    'Random_Lesson_Five&Ten_+_6_1_2': randomFiveTenPlus6Row21,
    'Random_Lesson_Five&Ten_+_6_2_1': randomFiveTenPlus6Row21,
    'Random_Lesson_Five&Ten_+_6_2_2': randomFiveTenPlus6Row22,

    'Random_Lesson_Ten_-_4_1_1': randomTenMinus4Row11,
    'Random_Lesson_Ten_-_4_1_2': randomTenMinus4Row21,
    'Random_Lesson_Ten_-_4_2_1': randomTenMinus4Row21,
    'Random_Lesson_Ten_-_4_2_2': randomTenMinus4Row22,
    'Random_Lesson_Ten_-_5_1_1': randomTenMinus5Row11,
    'Random_Lesson_Ten_-_5_1_2': randomTenMinus5Row21,
    'Random_Lesson_Ten_-_5_2_1': randomTenMinus5Row21,
    'Random_Lesson_Ten_-_5_2_2': randomTenMinus5Row22,
    'Random_Lesson_Ten_-_6_1_1': randomTenMinus6Row11,
    'Random_Lesson_Ten_-_6_1_2': randomTenMinus6Row21,
    'Random_Lesson_Ten_-_6_2_1': randomTenMinus6Row21,
    'Random_Lesson_Ten_-_6_2_2': randomTenMinus6Row22,
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

  void _randomQuestion4rows(int d1, int d2) {
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

  void _randomQuestion5rows(int d1, int d2) {
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

  void _randomQuestion6rows(int d1, int d2) {
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
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: numbers.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: normalbuildOutlinedText(
                                "$e",
                                fontSize: fontSize,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }()
                  : isFlashCardAnimating
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: FittedBox(
                        child: flashCardTextWithGlow(
                          "${numbers[currentStep]}",
                          fontSize: 120,
                          displayTimeSeconds:
                              int.tryParse(widget.setting.time.toString()) ?? 2,
                        ),
                      ),
                    )
                  : showAnswer || waitingToShowAnswer
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: FittedBox(
                        child: normalbuildOutlinedText("?", fontSize: 160),
                      ),
                    )
                  : Container(),
            ),
    );
  }
}
