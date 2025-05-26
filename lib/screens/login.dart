import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Image.asset('assets/images/logo.png', width: 100),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/user_icon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  _buildLoginField(
                    label: "ID :",
                    controller: idController,
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 8),
                  _buildLoginField(
                    label: "Password :",
                    controller: passwordController,
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      if (idController.text == 'admin' &&
                          passwordController.text == '1234') {
                        Navigator.pushReplacementNamed(context, '/Setting');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid ID or Password')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 235, 99, 144),
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
                      "LOGIN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
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
                  Row(
                    children: [
                      Text(
                        isSoundOn ? "Sound ON" : "Sound OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/sound_icon.png',
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 6),
                      Switch(
                        value: isSoundOn,
                        onChanged: (value) {
                          setState(() {
                            isSoundOn = value;
                          });
                        },
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 235, 99, 144),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 235, 99, 144),
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
