import 'dart:math';
import 'package:iq_maths_apps/datas/upper.dart';

class UpperQuestion4Row {
  final Random _random = Random();
  final List<Upper4row> _allQuestions; // เก็บลิสต์คำถามทั้งหมด
  Upper4row? _currentQuestion; // เก็บคำถามที่ถูกเลือกมาล่าสุด

  UpperQuestion4Row({required List<Upper4row> questions})
    : _allQuestions = questions;

  /// ฟังก์ชัน void ที่สุ่มเลือกคำถามจาก upper5rowList
  void selectRandomQuestion() {
    if (_allQuestions.isEmpty) {
      _currentQuestion = null;
      return;
    }
    // สุ่มเลือก index จากลิสต์
    int randomIndex = _random.nextInt(_allQuestions.length);
    _currentQuestion = _allQuestions[randomIndex];
  }

  /// ฟังก์ชันสำหรับเรียกดูคำถามที่ถูกสุ่มเลือกมา
  Upper4row? getCurrentQuestion() {
    return _currentQuestion;
  }

  /// เมธอดสำหรับตรวจสอบคำตอบของคำถามปัจจุบัน
  /// ans จะถูก "ซ่อน" โดยการที่เราเข้าถึงมันผ่าน object ภายใน class นี้เท่านั้น
  bool checkCurrentQuestionAnswer(int userAnswer) {
    if (_currentQuestion == null) {
      return false;
    }
    // เข้าถึง ans จาก object ที่ถูกสุ่มเลือกมา
    return userAnswer == _currentQuestion!.ans;
  }
}
