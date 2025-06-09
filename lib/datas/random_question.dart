import 'dart:math';

class RandomQuestionRow {
  final Random _random = Random();
  final List<dynamic> _allQuestions; // เก็บลิสต์คำถามทั้งหมด
  dynamic _currentQuestion; // เก็บคำถามที่ถูกเลือกมาล่าสุด

  RandomQuestionRow({required List<dynamic> questions})
    : _allQuestions = questions;

  /// ฟังก์ชัน void ที่สุ่มเลือกคำถามจาก LowerUpper5RowList
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
  dynamic getCurrentQuestion() {
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
