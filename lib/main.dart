import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/maths_setting.dart';
import 'screens/login.dart';
import 'screens/setting.dart';
import 'screens/lower.dart';
import 'screens/upper.dart';
import 'screens/lowerandupper.dart';
import 'screens/multiplication.dart';
import 'screens/division.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IQ Maths',
      theme: ThemeData(fontFamily: 'PoetsenOn', useMaterial3: true),
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/Lower') {
          final mathsSetting = settings.arguments as MathsSetting;
          return MaterialPageRoute(
            builder: (_) => LowerScreen(setting: mathsSetting),
          );
        } else if (settings.name == '/Upper') {
          final mathsSetting = settings.arguments as MathsSetting;
          return MaterialPageRoute(
            builder: (_) => UpperScreen(setting: mathsSetting),
          );
        } else if (settings.name == '/LowerAndUpper') {
          final mathsSetting = settings.arguments as MathsSetting;
          return MaterialPageRoute(
            builder: (_) => LowerAndUpperScreen(setting: mathsSetting),
          );
        } else if (settings.name == '/Multiplication') {
          final mathsSetting = settings.arguments as MathsSetting;
          return MaterialPageRoute(
            builder: (_) => MultiplicationScreen(setting: mathsSetting),
          );
        } else if (settings.name == '/Division') {
          final mathsSetting = settings.arguments as MathsSetting;
          return MaterialPageRoute(
            builder: (_) => DivisionScreen(setting: mathsSetting),
          );
        } else if (settings.name == '/Setting') {
          return MaterialPageRoute(builder: (_) => const SettingScreen());
        }
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      },
    );
  }
}
