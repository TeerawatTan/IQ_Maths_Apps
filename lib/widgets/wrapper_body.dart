import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iq_maths_apps/helpers/format_input_number.dart';
import 'package:iq_maths_apps/services/auth_service.dart';
import 'package:iq_maths_apps/widgets/common_layout.dart';

// ฟังก์ชันสำหรับสร้างข้อความที่มีขอบ
Widget buildOutlinedText(
  String text, {
  double fontSize = 60,
  double strokeWidthRatio = 0.25,
  Color strokeColor = Colors.black,
  Color fillColor = Colors.white,
}) {
  final strokeWidth = fontSize * strokeWidthRatio;

  return Stack(
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..strokeJoin = StrokeJoin.round,
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: fillColor,
        ),
      ),
    ],
  );
}

// ฟังก์ชันสำหรับกำหนดขนาดฟอนต์ตามความยาวของข้อความ
double _getFontSize(int textLength) {
  switch (textLength) {
    case 0:
    case 1:
      return 60.0;
    case 2:
      return 55.0;
    case 3:
      return 50.0;
    case 4:
      return 45.0;
    case 5:
      return 37.5;
    default:
      return 35.0;
  }
}

class WrapperBody extends StatefulWidget {
  final String displayMode;
  final bool isFlashCardAnimating;
  final bool showAnswer;
  final bool showAnswerText;
  final bool waitingToShowAnswer;
  final TextEditingController inputAnsController;
  final Function? onNextPressed;
  final Function? onPlayPauseFlashCard;
  final bool isPaused;
  final int? currentStep;
  final int? totalNumbers;
  final bool showSmallWrongIcon;
  final String? answerText;
  final String currentMenuButtonLabel;
  final bool isShowMode;
  final Widget child;
  final bool showAnswerInput;
  final VoidCallback? onExitPressed;
  final bool showExitButton;
  final VoidCallback? onCheckPressed;
  final VoidCallback? onNextsPressed;
  final bool isSoundOn;
  final ValueChanged<bool>? onSoundToggle;
  final bool isAnswerCorrect;
  final bool hasCheckedAnswer;
  final bool hideAnsLabel;

  const WrapperBody({
    super.key,
    required this.displayMode,
    this.isFlashCardAnimating = false,
    this.showAnswer = false,
    this.showAnswerText = false,
    this.waitingToShowAnswer = false,
    required this.inputAnsController,
    this.onNextPressed,
    this.onPlayPauseFlashCard,
    this.isPaused = false,
    this.currentStep,
    this.totalNumbers,
    this.showSmallWrongIcon = false,
    this.answerText,
    required this.currentMenuButtonLabel,
    required this.isShowMode,
    required this.child,
    this.showAnswerInput = true,
    this.onExitPressed,
    this.showExitButton = true,
    this.onCheckPressed,
    this.onNextsPressed,
    this.isSoundOn = true,
    this.onSoundToggle,
    this.isAnswerCorrect = false,
    this.hasCheckedAnswer = false,
    this.hideAnsLabel = false,
  });

  @override
  State<WrapperBody> createState() => _WrapperBodyState();
}

class _WrapperBodyState extends State<WrapperBody> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  // Function สำหรับปรับขนาดฟอนต์ตามหน้าจอ
  double _getResponsiveFontSize(int textLength, bool isSmallScreen) {
    double baseFontSize = _getFontSize(textLength);
    return isSmallScreen ? baseFontSize * 0.8 : baseFontSize;
  }

  // Function สำหรับปรับขนาดรูปภาพตามหน้าจอ
  double _getResponsiveImageSize(double baseSize, bool isSmallScreen) {
    return isSmallScreen ? baseSize * 0.7 : baseSize;
  }

  // Function สำหรับปรับขนาดฟอนต์ทั่วไปตามหน้าจอ
  double _getResponsiveTextSize(double baseSize, bool isSmallScreen) {
    return isSmallScreen ? baseSize * 0.8 : baseSize;
  }

  // ฟังก์ชันสำหรับกำหนดสีปุ่มตาม Label
  Color _getButtonColors(String label) {
    String colorLabel = label.toLowerCase();

    if (colorLabel == 'lower' ||
        colorLabel == 'upper' ||
        colorLabel == 'lower&upper') {
      return const Color(0xFFFA7D9D);
    } else if (colorLabel.startsWith('five')) {
      return const Color(0xFFA3DEE8);
    } else if (colorLabel.startsWith('ten +')) {
      return const Color(0xFF5271FF);
    } else if (colorLabel.startsWith('five&ten')) {
      return const Color(0xFF51E4D6);
    } else if (colorLabel.startsWith('random lesson ten') ||
        colorLabel.startsWith('random lesson five')) {
      return Colors.red.shade400;
    } else if (colorLabel.startsWith('ten -')) {
      return const Color(0xFF2196F3);
    } else if (colorLabel == 'random exercise') {
      return const Color(0xFFF9CA24);
    } else if (colorLabel.startsWith('multiplication')) {
      return const Color(0xFF7ED957);
    } else if (colorLabel.startsWith('division')) {
      return const Color(0xFFC4A5FF);
    } else {
      return Colors.white;
    }
  }

  // Widget สำหรับปุ่มเมนูด้านซ้าย
  Widget _widgetLeftMenuButton(bool isSmallScreen) => Positioned(
    top: isSmallScreen ? 90 : 110,
    left: isSmallScreen ? 15 : 20,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _getButtonColors(widget.currentMenuButtonLabel),
        foregroundColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'PoetsenOn',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        maximumSize: Size(
          _getResponsiveImageSize(195, isSmallScreen),
          widget.currentMenuButtonLabel.contains('Random')
              ? (isSmallScreen ? 60 : 70)
              : (isSmallScreen ? 50 : 60),
        ),
      ),
      onPressed: () => Navigator.pop(context),
      child: Text(
        widget.currentMenuButtonLabel,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.fade,
      ),
    ),
  );

  // Widget สำหรับ Logo IQM
  Widget _widgetLogoIQM(bool isSmallScreen) => Positioned(
    top: isSmallScreen ? 2 : 4,
    left: isSmallScreen ? 80 : 100,
    child: Center(
      child: Image.asset(
        'assets/images/iq_maths_icon.png',
        width: _getResponsiveImageSize(130, isSmallScreen),
      ),
    ),
  );

  // Widget สำหรับ Icon Owl
  Widget _widgetIconOwl(bool isSmallScreen) => Positioned(
    bottom: isSmallScreen ? 80 : 40,
    left: isSmallScreen ? 15 : 20,
    child: Image.asset(
      'assets/images/owl.png',
      width: _getResponsiveImageSize(120, isSmallScreen),
    ),
  );

  // Widget สำหรับปุ่ม Check/Next แบบ Floating
  Widget _widgetBuildFloatingButton() {
    Widget actionButtonImage;
    if (widget.hasCheckedAnswer) {
      actionButtonImage = Image.asset('assets/images/next.png', width: 120);
    } else {
      actionButtonImage = Image.asset('assets/images/check.png', width: 120);
    }

    return ElevatedButton(
      onPressed: () {
        if (widget.hasCheckedAnswer) {
          widget.onNextPressed?.call();
        } else {
          widget.onCheckPressed?.call();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: actionButtonImage,
    );
  }

  // Widget สำหรับส่วน Input คำตอบที่ปรับตามขนาดหน้าจอ
  Widget _widgetBuildResponsiveInputSection(
    bool isSmallScreen,
    BoxConstraints constraints,
  ) {
    if (isSmallScreen) {
      // Layout แบบ Column สำหรับหน้าจอเล็ก
      return Column(
        children: [
          // Answer Input Box
          Container(
            width: constraints.maxWidth * 0.95,
            height: 50,
            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
            decoration: BoxDecoration(
              color: Colors.yellow[600],
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade200,
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                // "Ans" Label
                Text(
                  "Ans",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 8
                      ..color = Colors.black
                      ..strokeJoin = StrokeJoin.round,
                  ),
                ),
                const Text(
                  "Ans",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Input Field
                Padding(
                  padding: const EdgeInsets.only(left: 80.0, right: 110),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: widget.inputAnsController,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _getResponsiveFontSize(
                        widget.inputAnsController.text.length,
                        isSmallScreen,
                      ),
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      NumberInputFormatter(),
                    ],
                    maxLength: 10,
                    enabled: !widget.isFlashCardAnimating,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!widget.showAnswer && widget.isAnswerCorrect)
                        Image.asset(
                          'assets/images/correct.png',
                          width: 35,
                          height: 35,
                        ),
                      if (widget.showSmallWrongIcon &&
                          widget.showAnswer &&
                          !widget.isAnswerCorrect)
                        Image.asset(
                          'assets/images/wrong.png',
                          width: 35,
                          height: 35,
                        ),
                      if (widget.showAnswerText && !widget.isAnswerCorrect)
                        const SizedBox(width: 3),
                      if (widget.showAnswerText && !widget.isAnswerCorrect)
                        Stack(
                          children: [
                            Text(
                              widget.answerText!,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 8
                                  ..color = Colors.red
                                  ..strokeJoin = StrokeJoin.round,
                              ),
                            ),
                            Text(
                              widget.answerText!,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Next Button
          ElevatedButton(
            onPressed: () {
              if (widget.hasCheckedAnswer) {
                widget.onNextPressed?.call();
              } else {
                widget.onCheckPressed?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Image.asset(
              widget.hasCheckedAnswer
                  ? 'assets/images/next.png'
                  : 'assets/images/check.png',
              width: 120,
            ),
          ),
        ],
      );
    } else {
      // Layout แบบ Row สำหรับหน้าจอใหญ่
      return Row(
        children: [
          const SizedBox(width: 150),
          Expanded(
            child: Center(
              child: Container(
                width: 450,
                height: 60,
                padding: const EdgeInsets.fromLTRB(20, 7, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade200,
                      offset: const Offset(4, 4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Text(
                      "Ans",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 10
                          ..color = Colors.black
                          ..strokeJoin = StrokeJoin.round,
                      ),
                    ),
                    const Text(
                      "Ans",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0, right: 110),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: widget.inputAnsController,
                        decoration: const InputDecoration(counterText: ''),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _getFontSize(
                            widget.inputAnsController.text.length,
                          ),
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                        showCursor: false,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          NumberInputFormatter(),
                        ],
                        maxLength: 10,
                        enabled: !widget.isFlashCardAnimating,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (!widget.showAnswer && widget.isAnswerCorrect)
                            Image.asset(
                              'assets/images/correct.png',
                              width: 50,
                              height: 50,
                            ),
                          if (widget.showSmallWrongIcon &&
                              widget.showAnswer &&
                              !widget.isAnswerCorrect)
                            Image.asset(
                              'assets/images/wrong.png',
                              width: 50,
                              height: 50,
                            ),
                          if (widget.showAnswerText && !widget.isAnswerCorrect)
                            const SizedBox(width: 3),
                          if (widget.showAnswerText && !widget.isAnswerCorrect)
                            SizedBox(
                              width: 55, // กำหนดความกว้างสูงสุดของ answer text
                              height: 80, // กำหนดความสูงสูงสุดของ answer text
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Stack(
                                  children: [
                                    Text(
                                      widget.answerText!,
                                      style: TextStyle(
                                        fontSize:
                                            36, // ขนาดเริ่มต้น (จะถูกปรับโดย FittedBox)
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 8
                                          ..color = Colors.red
                                          ..strokeJoin = StrokeJoin.round,
                                      ),
                                    ),
                                    Text(
                                      widget.answerText!,
                                      style: const TextStyle(
                                        fontSize:
                                            36, // ขนาดเริ่มต้น (จะถูกปรับโดย FittedBox)
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              if (widget.hasCheckedAnswer) {
                widget.onNextPressed?.call();
              } else {
                widget.onCheckPressed?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Image.asset(
              widget.hasCheckedAnswer
                  ? 'assets/images/next.png'
                  : 'assets/images/check.png',
              width: 120,
            ),
          ),
          const SizedBox(width: 12),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      userId: authService.getUserId(),
      isSoundOn: widget.isSoundOn,
      child: LayoutBuilder(
        // เนื้อหาหลักของ WrapperBody
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          return Stack(
            children: [
              // Menu btn
              _widgetLeftMenuButton(isSmallScreen),

              // IQ Maths Icon
              _widgetLogoIQM(isSmallScreen),

              // Owl Image
              _widgetIconOwl(isSmallScreen),

              Positioned(
                top: isSmallScreen ? 5 : 10,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Display Mode Text
                    if (widget.isShowMode)
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Stack(
                          children: [
                            Text(
                              "Display : ${widget.displayMode}",
                              style: TextStyle(
                                fontSize: _getResponsiveTextSize(
                                  24,
                                  isSmallScreen,
                                ),
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = isSmallScreen ? 5 : 7
                                  ..color = Colors.black
                                  ..strokeJoin = StrokeJoin.round,
                              ),
                            ),
                            Text(
                              "Display : ${widget.displayMode}",
                              style: TextStyle(
                                fontSize: _getResponsiveTextSize(
                                  24,
                                  isSmallScreen,
                                ),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Step Counter
                    if (widget.isPaused &&
                        widget.displayMode.toLowerCase() == "flash card")
                      Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: buildOutlinedText(
                          '${widget.currentStep! + 1}/${widget.totalNumbers!}',
                          fontSize: _getResponsiveTextSize(30, isSmallScreen),
                          strokeColor: Colors.blueAccent,
                          fillColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),

              // Main Content Area
              // ส่วนนี้คือ widget.child ที่ส่งมาจาก WrapperBody
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
                  child: widget.child,
                ),
              ),

              // Answer Input แบบเดิมเมื่อ hideAnsLabel = false (ไม่ได้ใช้ในตาราง)
              if (widget.showAnswerInput &&
                  (widget.totalNumbers ?? 0) > 0 &&
                  !widget.hideAnsLabel)
                Positioned(
                  bottom: isSmallScreen ? 70 : 80, // ปรับตำแหน่งให้เหมาะสม
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8.0 : 16.0,
                      vertical: 5.0,
                    ),
                    child: _widgetBuildResponsiveInputSection(
                      isSmallScreen,
                      constraints,
                    ),
                  ),
                ),

              // ปุ่ม Check/Next แบบ overlay สำหรับตาราง (เมื่อ hideAnsLabel = true)
              if (widget.showAnswerInput &&
                  (widget.totalNumbers ?? 0) > 0 &&
                  widget.hideAnsLabel)
                Positioned(
                  bottom: isSmallScreen
                      ? 40
                      : 45, // ลงมาใกล้ bottom bar มากขึ้น
                  right: 20,
                  child: _widgetBuildFloatingButton(),
                ),
            ],
          );
        },
      ),
    );
  }
}
