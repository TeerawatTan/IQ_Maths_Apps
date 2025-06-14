import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildOutlinedText(
  String text, {
  double fontSize = 16.0,
  Color strokeColor = Colors.black,
  Color fillColor = Colors.white,
}) {
  return Stack(
    children: [
      // Stroked text
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 7
            ..color = strokeColor,
        ),
      ),
      // Solid text
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
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

class LowerUpperWrapper extends StatefulWidget {
  final String? userName;
  final String? avatarImg;
  final Widget child;
  final String displayMode;
  final bool isFlashCardAnimating;
  final bool showAnswer;
  final bool showAnswerText;
  final bool waitingToShowAnswer;
  final TextEditingController inputAnsController;
  final Function? onNextPressed;
  final Function?
  onPlayPauseFlashCard; // Optional callback for flash card play/pause
  final bool isPaused; // For flash card state
  final int? currentStep; // For flash card step display
  final int? totalNumbers; // For flash card total numbers display
  final bool showSmallWrongIcon;
  final String? answerText; // For displaying the actual answer
  final String currentMenuImage;

  const LowerUpperWrapper({
    super.key,
    this.userName = '',
    this.avatarImg,
    required this.child,
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
  });

  @override
  State<LowerUpperWrapper> createState() => _LowerUpperWrapperState();
}

class _LowerUpperWrapperState extends State<LowerUpperWrapper> {
  // bool _isSoundOn = true; // State for sound toggle

  bool _isLoggingOut = false; // State to manage logout loading

  // Function to handle user logout
  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true; // Show loading indicator
    });

    try {
      await FirebaseAuth.instance.signOut(); // Sign out the current user
      // After successful logout, navigate back to the login screen
      if (mounted) {
        // Check if the widget is still in the tree
        Navigator.pushReplacementNamed(
          context,
          '/',
        ); // Assuming '/' is your login route
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
          _isLoggingOut = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Image.asset('assets/images/logo.png', width: 60),
          ),
          Positioned(
            top: 110,
            left: 20,
            child: Image.asset(widget.currentMenuImage, width: 150),
          ),
          Positioned(
            top: 10,
            left: 100,
            child: Center(
              child: Image.asset('assets/images/iq_maths_icon.png', width: 130),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Image.asset('assets/images/owl.png', width: 120),
          ),

          Positioned(
            top: 30,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "ID : ${widget.userName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black12,
                        child: widget.avatarImg == null
                            ? const Icon(Icons.person, color: Colors.black)
                            : ClipOval(
                                child: Image.asset(
                                  widget.avatarImg!,
                                  fit: BoxFit.cover,
                                  width: 36,
                                  height: 36,
                                ),
                              ),
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
                              icon: const Icon(Icons.logout), // Logout icon
                              iconSize: 30.0, // Adjust icon size as needed
                              color: const Color.fromARGB(
                                255,
                                235,
                                99,
                                144,
                              ), // Icon color
                              onPressed: _logout, // Call the _logout function
                              tooltip:
                                  'Logout', // Text that appears on long press
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Text(
                      "Display : ${widget.displayMode}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 7
                          ..color = Colors.black
                          ..strokeJoin = StrokeJoin.round,
                      ),
                    ),
                    Text(
                      "Display : ${widget.displayMode}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (widget.displayMode.toLowerCase() == "flash card" &&
                    !widget.waitingToShowAnswer)
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: IconButton(
                      icon: Image.asset(
                        widget.isPaused
                            ? 'assets/images/play_icon.png'
                            : 'assets/images/pause_icon.png',
                        width: 100,
                        height: 100,
                      ),
                      onPressed:
                          widget.onPlayPauseFlashCard as void Function()?,
                    ),
                  ),
                // Display current step/total _numbers if paused and in flash card mode
                if (widget.isPaused &&
                    widget.displayMode.toLowerCase() == "flash card")
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: buildOutlinedText(
                      '${widget.currentStep! + 1}/${widget.totalNumbers!}', // Display current number/total
                      fontSize: 30,
                      strokeColor: Colors.blueAccent,
                      fillColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),

          // Main Content Area (passed as child)
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: widget.child,
                ),
              ),

              // Answer Input and Next Button Section
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: widget.totalNumbers! > 0
                    ? Row(
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
                                      padding: const EdgeInsets.only(
                                        left: 100.0,
                                        right: 100,
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: widget.inputAnsController,
                                        decoration: const InputDecoration(
                                          counterText: '',
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _getFontSize(
                                            widget
                                                .inputAnsController
                                                .text
                                                .length,
                                          ),
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                        showCursor: false,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        maxLength: 5,
                                        enabled: !widget.isFlashCardAnimating,
                                        onChanged: (value) {
                                          setState(
                                            () {},
                                          ); // อัพเดท UI เมื่อข้อความเปลี่ยน
                                        },
                                      ),
                                    ),
                                    if (widget.showAnswer)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                        ), // ขยับซ้าย 50 pixels
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        foreground: Paint()
                                                          ..style =
                                                              PaintingStyle
                                                                  .stroke
                                                          ..strokeWidth = 10
                                                          ..color = Colors.red
                                                          ..strokeJoin =
                                                              StrokeJoin.round,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.answerText!,
                                                      style: const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/Next.png',
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      )
                    : Row(),
              ),

              // Bottom Bar
              Container(
                height: 42,
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Intelligent Quick Maths ( IQM )",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     const Text(
                    //       "Sound ",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Image.asset(
                    //       'assets/images/sound_icon.png',
                    //       width: 22,
                    //       height: 22,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Transform.scale(
                    //       scale: 0.8,
                    //       child: Switch(
                    //         value: _isSoundOn,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _isSoundOn = value;
                    //           });
                    //         },
                    //         activeColor: Colors.white,
                    //         inactiveThumbColor: Colors.red,
                    //         inactiveTrackColor: const Color.fromARGB(
                    //           255,
                    //           235,
                    //           116,
                    //           107,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       _isSoundOn ? "ON" : "OFF",
                    //       style: TextStyle(
                    //         color: _isSoundOn ? Colors.white : Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
