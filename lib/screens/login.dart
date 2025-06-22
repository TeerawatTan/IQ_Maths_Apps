import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  bool isSoundOn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Custom validation function that shows ScaffoldMessenger
  bool _validateInputs() {
    String? emailError;
    String? passwordError;

    // Validate email
    if (emailController.text.isEmpty) {
      emailError = 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      emailError = 'Please enter a valid email';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError = 'Please enter your password';
    }

    // Show error message if validation fails
    if (emailError != null) {
      _showValidationError(emailError);
      return false;
    }
    if (passwordError != null) {
      _showValidationError(passwordError);
      return false;
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _login() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    final AuthService authService = AuthService();

    bool success = await authService.login(
      emailController.text.trim(),
      passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(
          context,
          '/Setting',
          arguments: user.uid,
        );
      }
    } else {
      _showValidationError(
        "บัญชีนี้ถูกใช้งานจากอุปกรณ์อื่น หรือข้อมูลไม่ถูกต้อง",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(child: Text("${snapshot.error}")),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          bool isShowKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/bg4.png',
                    fit: BoxFit.cover,
                  ),
                ),
                if (!isShowKeyboard)
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Image.asset('assets/images/logo.png', width: 100),
                  ),
                if (!isShowKeyboard)
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Image.asset(
                      'assets/images/maths_icon3.png',
                      width: 90,
                    ),
                  ),
                if (!isShowKeyboard)
                  Positioned(
                    top: -8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/images/iq_maths_icon.png',
                        width: 150,
                      ),
                    ),
                  ),
                !isShowKeyboard
                    ? Positioned(
                        bottom: 40,
                        left: 0,
                        child: Image.asset(
                          'assets/images/maths_icon2.png',
                          width: 150,
                        ),
                      )
                    : Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/images/maths_icon2.png',
                          width: 150,
                        ),
                      ),
                !isShowKeyboard
                    ? Positioned(
                        bottom: 40,
                        right: 0,
                        child: Image.asset(
                          'assets/images/maths_icon4.png',
                          width: 120,
                        ),
                      )
                    : Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/images/maths_icon4.png',
                          width: 120,
                        ),
                      ),
                Center(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 70),
                          Container(
                            width: 100,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/user_icon.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          _buildLoginField(
                            label: "Email :",
                            controller: emailController,
                            icon: Icons.email,
                          ),

                          const SizedBox(height: 8),
                          _buildLoginField(
                            label: "Password :",
                            controller: passwordController,
                            icon: Icons.lock,
                            isPassword: true,
                          ),

                          const SizedBox(height: 10),

                          _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 235, 99, 144),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        20,
                                        5,
                                        10,
                                        0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            235,
                                            99,
                                            144,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "LOGIN",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isShowKeyboard)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.lightBlueAccent,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Intelligent Quick Maths (IQM)",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "v.1.0.0",
                            style: TextStyle(
                              color: Colors.white10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 235, 99, 144),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      width: 240,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 147, 217, 250),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 235, 99, 144),
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 235, 99, 144),
          ),
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 235, 99, 144),
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}
