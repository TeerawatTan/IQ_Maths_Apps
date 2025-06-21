import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  final int answerCorrect;

  const SummaryScreen({super.key, required this.answerCorrect});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _isLoggingOut = false; // State to manage logout loading
  final auth = FirebaseAuth.instance;

  Widget buildOutlinedText(
    String text, {
    double fontSize = 60,
    double strokeWidthRatio = 0.2,
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
            height: 0.4,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            height: 0.8,
            color: fillColor,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ],
    );
  }

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
    String userName = auth.currentUser == null
        ? ''
        : auth.currentUser!.email!.substring(
            0,
            auth.currentUser!.email!.indexOf('@'),
          );
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
            top: 25,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                          "ID : $userName",
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
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.answerCorrect == 0
                          ? 'assets/images/wrong.png'
                          : 'assets/images/correct.png',
                      width: 100,
                      height: 100,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Stack(
                            children: [
                              Text(
                                "ตอบถูก ${widget.answerCorrect} ข้อ",
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 10
                                    ..color = Colors.black
                                    ..strokeJoin = StrokeJoin.round,
                                ),
                              ),
                              Text(
                                "ตอบถูก ${widget.answerCorrect} ข้อ",
                                style: const TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // Pops SummaryScreen, revealing YourWidget
                      },
                      child: const Text(
                        "Play Again",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom Bar
              Container(
                height: 35,
                color: Colors.blue[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Intelligent Quick Maths (IQM)",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
