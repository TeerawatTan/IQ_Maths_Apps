import 'package:flutter/material.dart';
import 'package:iq_maths_apps/widgets/setting_menu_button.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_lp.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_five.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_tenplus.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_tenminus.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_multi.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_div.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String selectedMenu = '';
  String selectedDigit1 = '';
  String selectedDigit2 = '';
  String selectedDisplay = '';
  String selectedRow = '';
  String selectedTime = '';

  bool isSoundOn = true;
  bool isSettingValid() {
    print("selectedDisplay : $selectedDisplay");
    if (selectedMenu == 'MULTI' || selectedMenu == 'DIV') {
      return selectedDigit1.isNotEmpty &&
          selectedDigit2.isNotEmpty &&
          selectedTime.isNotEmpty;
    }
    return selectedDigit1.isNotEmpty &&
        selectedDigit2.isNotEmpty &&
        selectedDisplay.isNotEmpty &&
        selectedRow.isNotEmpty &&
        (selectedDisplay == 'Show all' ? true : selectedTime.isNotEmpty);
    //selectedTime.isNotEmpty;
  }

  void clearSetting() {
    setState(() {
      selectedDigit1 = '';
      selectedDigit2 = '';
      selectedDisplay = '';
      selectedRow = '';
      selectedTime = '';
    });
  }

  void selectMenu(String menu) {
    setState(() {
      if (selectedMenu == menu) {
        selectedMenu = '';
      } else {
        selectedMenu = menu;
      }
      clearSetting();
    });
  }

  void navigateToRoute(String route) {
    if (!isSettingValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Please complete all the settings first',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final setting = MathsSetting(
      digit1: selectedDigit1,
      digit2: selectedDigit2,
      display: selectedDisplay,
      row: selectedRow,
      time: selectedTime,
    );

    Navigator.pushNamed(context, route, arguments: setting);
  }

  void handleSettingChanged(String label, String value) {
    setState(() {
      switch (label) {
        case 'Digit 1':
          selectedDigit1 = value;
          break;
        case 'Digit 2':
          selectedDigit2 = value;
          break;
        case 'Display':
          selectedDisplay = value;
          break;
        case 'Row':
          selectedRow = value;
          break;
        case 'Time':
          selectedTime = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildHeader(),
          _buildUserInfo(),
          _buildMainMenu(),
          if (selectedMenu == 'LP') _buildSubOptionsLP(),
          if (selectedMenu == 'FIVE') _buildSubOptionsFive(),
          if (selectedMenu == 'TEN+') _buildSubOptionsTenPlus(),
          if (selectedMenu == 'TEN-') _buildSubOptionsTenMinus(),
          if (selectedMenu == 'MULTI') _buildSubOptionsMulti(),
          if (selectedMenu == 'DIV') _buildSubOptionsDiv(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBackground() => Positioned.fill(
    child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
  );

  Widget _buildHeader() => Positioned(
    top: 30,
    left: 20,
    child: Image.asset('assets/images/logo.png', width: 70),
  );

  Widget _buildUserInfo() => Positioned(
    top: 30,
    right: 20,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.cyan[100],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          const Text(
            "ID : User Test",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black12,
            child: Icon(Icons.person, color: Colors.black),
          ),
        ],
      ),
    ),
  );

  Widget _buildMainMenu() => Positioned(
    top: 120,
    left: 50,
    right: 20,
    bottom: 50,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MenuButton(
            title: 'LOWER & UPPER',
            color: const Color(0xFFFA7D9D),
            onPressed: () => selectMenu('LP'),
          ),
          MenuButton(
            title: 'FIVE BUDDY + -',
            color: const Color(0xFF5CE1E6),
            onPressed: () => selectMenu('FIVE'),
          ),
          MenuButton(
            title: 'TEN COUPLE +',
            color: const Color(0xFF5271FF),
            onPressed: () => selectMenu('TEN+'),
          ),
          MenuButton(
            title: 'TEN COUPLE -',
            color: const Color(0xFF38B6FF),
            onPressed: () => selectMenu('TEN-'),
          ),
          MenuButton(
            title: 'Multiplication x',
            color: const Color(0xFF7ED957),
            onPressed: () => selectMenu('MULTI'),
          ),
          MenuButton(
            title: 'Division',
            color: const Color(0xFFC4A5FF),
            onPressed: () => selectMenu('DIV'),
          ),
        ],
      ),
    ),
  );

  Widget _buildSubOptionsLP() => Positioned(
    top: 115,
    left: 270,
    child: SubOptionsLP(
      onNavigate: navigateToRoute,
      digit1: selectedDigit1,
      digit2: selectedDigit2,
      display: selectedDisplay,
      row: selectedRow,
      time: selectedTime,
      onSettingChanged: handleSettingChanged,
    ),
  );

  Widget _buildSubOptionsFive() => Positioned(
    top: 90,
    left: 270,
    child: SubOptionsFive(
      onNavigate: navigateToRoute,
      digit1: selectedDigit1,
      digit2: selectedDigit2,
      display: selectedDisplay,
      row: selectedRow,
      time: selectedTime,
      onSettingChanged: handleSettingChanged,
    ),
  );

  Widget _buildSubOptionsTenPlus() => Positioned(
    top: 90,
    left: 270,
    child: SubOptionsTenPlus(
      onNavigate: navigateToRoute,
      digit1: selectedDigit1,
      digit2: selectedDigit2,
      display: selectedDisplay,
      row: selectedRow,
      time: selectedTime,
      onSettingChanged: handleSettingChanged,
    ),
  );

  Widget _buildSubOptionsTenMinus() => Positioned(
    top: 90,
    left: 270,
    child: SubOptionsTenMinus(
      onNavigate: navigateToRoute,
      digit1: selectedDigit1,
      digit2: selectedDigit2,
      display: selectedDisplay,
      row: selectedRow,
      time: selectedTime,
      onSettingChanged: handleSettingChanged,
    ),
  );

  Widget _buildSubOptionsMulti() => Positioned(
    top: 115,
    left: 270,
    child: SubOptionsMulti(
      onNavigate: navigateToRoute,
      digit1: selectedDigit1,
      digit2: selectedDigit2,
      time: selectedTime,
      onSettingChanged: handleSettingChanged,
    ),
  );

  Widget _buildSubOptionsDiv() => Positioned(
    top: 115,
    left: 270,
    child: SubOptionsDiv(
      onNavigate: navigateToRoute,
      digit1: selectedDigit1,
      digit2: selectedDigit2,
      time: selectedTime,
      onSettingChanged: handleSettingChanged,
    ),
  );

  Widget _buildFooter() => Positioned(
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                onChanged: (value) => setState(() => isSoundOn = value),
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
