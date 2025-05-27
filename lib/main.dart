import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/setting.dart';
import 'screens/lower.dart';
import 'screens/upper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IQ Maths',
      theme: ThemeData(useMaterial3: true),
      home: LoginScreen(),
      routes: {
        '/Setting': (context) => SettingScreen(),
        '/Lower': (context) => LowerScreen(),
        '/Upper': (context) => UpperScreen(),
      },
    );
  }
}
