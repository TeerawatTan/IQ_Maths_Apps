import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Custom validation function that shows ScaffoldMessenger
  bool _validateInputs() {
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;

    // Validate email
    if (emailController.text.isEmpty) {
      emailError = 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      emailError = 'Please enter a valid email';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError = 'Please enter your password';
    } else if (passwordController.text.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }

    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError = 'Please confirm your password';
    } else if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError = 'Passwords do not match';
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
    if (confirmPasswordError != null) {
      _showValidationError(confirmPasswordError);
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

  Future<void> _register() async {
    // Use custom validation instead of form validation
    if (_validateInputs()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Register success.")));
          Navigator.pop(context);
          // Navigator.pushReplacementNamed(context, '/Setting');
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'Email is already in use.';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email format.';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak.';
        } else {
          message = 'Registration failed: ${e.message}';
        }
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } finally {
        setState(() => _isLoading = false);
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

          // Icons เหมือน login
          // Positioned(
          //   top: 40,
          //   left: 20,
          //   child: Image.asset('assets/images/logo.png', width: 100),
          // ),
          Positioned(
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // เมื่อกดที่ logo จะย้อนกลับ
              },
              child: Image.asset('assets/images/logo.png', width: 100),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Image.asset('assets/images/maths_icon3.png', width: 90),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            child: Image.asset('assets/images/maths_icon2.png', width: 150),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            child: Image.asset('assets/images/maths_icon4.png', width: 120),
          ),
          Positioned(
            top: -8,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/images/iq_maths_icon.png', width: 150),
            ),
          ),

          Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 72),
                    _buildInputField(
                      label: "Email :",
                      controller: emailController,
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 8),

                    _buildInputField(
                      label: "Password :",
                      controller: passwordController,
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 8),

                    _buildInputField(
                      label: "Confirm Password :",
                      controller: confirmPasswordController,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),

                    _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Color.fromARGB(255, 235, 99, 144),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _register,
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "REGISTER",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.lightBlueAccent,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Row(
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
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      "v.1.0.0",
                      style: TextStyle(
                        color: Colors.white10,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      width: 240,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 6),
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
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 235, 99, 144),
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 235, 99, 144)),
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
