import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class WidgetWrapper extends StatefulWidget {
  final String? userName;
  final String? avatarImg;
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
  final String currentMenuImage;
  final bool isShowMode;
  final Widget child;

  const WidgetWrapper({
    super.key,
    this.userName = '',
    this.avatarImg,
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
    required this.currentMenuImage,
    required this.isShowMode,
    required this.child,
  });

  @override
  State<WidgetWrapper> createState() => _WidgetWrapperState();
}

class _WidgetWrapperState extends State<WidgetWrapper> {
  bool _isLoggingOut = false;

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

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;

          return Stack(
            children: [
              // Background
              Positioned.fill(
                child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
              ),

              // Logo
              Positioned(
                top: isSmallScreen ? 20 : 25,
                left: isSmallScreen ? 15 : 20,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: _getResponsiveImageSize(60, isSmallScreen),
                ),
              ),

              // Menu Image
              Positioned(
                top: isSmallScreen ? 90 : 110,
                left: isSmallScreen ? 15 : 20,
                child: Image.asset(
                  widget.currentMenuImage,
                  width: _getResponsiveImageSize(150, isSmallScreen),
                ),
              ),

              // IQ Maths Icon
              Positioned(
                top: isSmallScreen ? 2 : 4,
                left: isSmallScreen ? 80 : 100,
                child: Center(
                  child: Image.asset(
                    'assets/images/iq_maths_icon.png',
                    width: _getResponsiveImageSize(130, isSmallScreen),
                  ),
                ),
              ),

              // Owl Image
              Positioned(
                bottom: isSmallScreen ? 80 : 40,
                left: isSmallScreen ? 15 : 20,
                child: Image.asset(
                  'assets/images/owl.png',
                  width: _getResponsiveImageSize(120, isSmallScreen),
                ),
              ),

              // Top Right User Info and Controls
              Positioned(
                top: isSmallScreen ? 20 : 25,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // User Info Container
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "ID : ${widget.userName}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            Image.asset(
                              'assets/images/user_icon.png',
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                            _isLoggingOut
                                ? const SizedBox(
                                    width: 30, // Match icon size
                                    height: 30, // Match icon size
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromARGB(255, 235, 99, 144),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.logout,
                                    ), // Logout icon
                                    iconSize:
                                        30.0, // Adjust icon size as needed
                                    color: const Color.fromARGB(
                                      255,
                                      235,
                                      99,
                                      144,
                                    ), // Icon color
                                    onPressed:
                                        _logout, // Call the _logout function
                                    tooltip:
                                        'Logout', // Text that appears on long press
                                  ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 4 : 6),

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

                    // Flash Card Controls
                    if (widget.displayMode.toLowerCase() == "flash card" &&
                        !widget.waitingToShowAnswer)
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: IconButton(
                          icon: Image.asset(
                            widget.isPaused
                                ? 'assets/images/play_icon.png'
                                : 'assets/images/pause_icon.png',
                            width: _getResponsiveImageSize(100, isSmallScreen),
                            height: _getResponsiveImageSize(100, isSmallScreen),
                          ),
                          onPressed:
                              widget.onPlayPauseFlashCard as void Function()?,
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
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
                      child: widget.child,
                    ),
                  ),

                  // Answer Input and Next Button Section - Responsive
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8.0 : 16.0,
                      vertical: 5.0,
                    ),
                    child: widget.totalNumbers! > 0
                        ? _buildResponsiveInputSection(
                            isSmallScreen,
                            constraints,
                          )
                        : const SizedBox.shrink(),
                  ),
                  // const SizedBox(height: 5),
                  // Bottom Bar
                  Container(
                    height: isSmallScreen ? 32 : 35,
                    color: Colors.blue[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: isSmallScreen ? 10 : 16,
                          ),
                          child: Text(
                            "Intelligent Quick Maths (IQM)",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: isSmallScreen ? 10 : 16,
                          ),
                          child: Text(
                            "v.1.0.0",
                            style: TextStyle(
                              color: Colors.white10,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResponsiveInputSection(
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
                  padding: const EdgeInsets.only(left: 80.0, right: 80),
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
                    ],
                    maxLength: 5,
                    enabled: !widget.isFlashCardAnimating,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),

                // Answer Display
                if (widget.showAnswer)
                  Positioned(
                    right: 15,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (widget.showSmallWrongIcon)
                          Image.asset(
                            'assets/images/wrong.png',
                            width: 35,
                            height: 35,
                          ),
                        if (widget.showSmallWrongIcon) const SizedBox(width: 3),
                        if (widget.showAnswerText)
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
            onPressed: widget.onNextPressed as void Function()?,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Image.asset('assets/images/Next.png', width: 120),
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
                width: 400,
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
                      padding: const EdgeInsets.only(left: 100.0, right: 100),
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
                        ],
                        maxLength: 5,
                        enabled: !widget.isFlashCardAnimating,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    if (widget.showAnswer)
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            if (widget.showSmallWrongIcon)
                              Image.asset(
                                'assets/images/wrong.png',
                                width: 50,
                                height: 50,
                              ),
                            if (widget.showSmallWrongIcon)
                              const SizedBox(width: 5),
                            if (widget.showAnswerText)
                              Flexible(
                                child: Stack(
                                  children: [
                                    Text(
                                      widget.answerText!,
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 10
                                          ..color = Colors.red
                                          ..strokeJoin = StrokeJoin.round,
                                      ),
                                    ),
                                    Text(
                                      widget.answerText!,
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
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
            onPressed: widget.onNextPressed as void Function()?,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Image.asset('assets/images/Next.png', width: 150),
          ),
          const SizedBox(width: 12),
        ],
      );
    }
  }
}
