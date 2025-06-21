import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isLoggingOut = false;
  String? _selectedSubOptionLPLabel;
  String? _selectedSubOptionFiveLabel;
  String? _selectedSubOptionTenPlusLabel;
  String? _selectedSubOptionTenMinusLabel;
  String? _selectedSubOptionMultiLabel;
  String? _selectedSubOptionDivLabel;

  String uname = FirebaseAuth.instance.currentUser == null
      ? ''
      : FirebaseAuth.instance.currentUser!.email!.substring(
          0,
          FirebaseAuth.instance.currentUser!.email!.indexOf('@'),
        );

  bool isSettingValid() {
    if (selectedMenu == 'MULTI' || selectedMenu == 'DIV') {
      return selectedDigit1.isNotEmpty && selectedDigit2.isNotEmpty;
    }
    return selectedDigit1.isNotEmpty &&
        selectedDigit2.isNotEmpty &&
        selectedDisplay.isNotEmpty &&
        selectedRow.isNotEmpty &&
        (selectedDisplay == 'Show all' ? true : selectedTime.isNotEmpty) &&
        _isSubOptionSelected();
  }

  bool _isSubOptionSelected() {
    switch (selectedMenu) {
      case 'LP':
        return _selectedSubOptionLPLabel != null;
      case 'FIVE':
        return _selectedSubOptionFiveLabel != null;
      case 'TEN+':
        return _selectedSubOptionTenPlusLabel != null;
      case 'TEN-':
        return _selectedSubOptionTenMinusLabel != null;
      case 'MULTI':
        return _selectedSubOptionMultiLabel != null;
      case 'DIV':
        return _selectedSubOptionDivLabel != null;
      default:
        return false;
    }
  }

  void clearSetting() {
    setState(() {
      selectedDigit1 = '';
      selectedDigit2 = '';
      selectedDisplay = '';
      selectedRow = '';
      selectedTime = '';
      // เคลียร์ค่าปุ่มย่อยที่ถูกเลือกด้วย
      _selectedSubOptionLPLabel = null;
      _selectedSubOptionFiveLabel = null;
      _selectedSubOptionTenPlusLabel = null;
      _selectedSubOptionTenMinusLabel = null;
      _selectedSubOptionMultiLabel = null;
      _selectedSubOptionDivLabel = null;
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

  void _onSubOptionSelected(String menuKey, String label) {
    setState(() {
      switch (menuKey) {
        case 'LP':
          _selectedSubOptionLPLabel = label;
          break;
        case 'FIVE':
          _selectedSubOptionFiveLabel = label;
          break;
        case 'TEN+':
          _selectedSubOptionTenPlusLabel = label;
          break;
        case 'TEN-':
          _selectedSubOptionTenMinusLabel = label;
          break;
        case 'MULTI': // สำหรับปุ่มย่อยของ Multi
          _selectedSubOptionMultiLabel = label;
          break;
        case 'DIV': // สำหรับปุ่มย่อยของ Div
          _selectedSubOptionDivLabel = label;
          break;
      }
    });
  }

  void navigateToRoute() {
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

    String? routeToNavigate;
    // กำหนด route ตาม selectedMenu และ _selectedSubOptionXXXLabel
    switch (selectedMenu) {
      case 'LP':
        if (_selectedSubOptionLPLabel == 'Lower') {
          routeToNavigate = '/Lower';
        } else if (_selectedSubOptionLPLabel == 'Upper') {
          routeToNavigate = '/Upper';
        } else if (_selectedSubOptionLPLabel == 'Lower&Upper') {
          routeToNavigate = '/LowerAndUpper';
        }
        break;
      case 'FIVE':
        // if (_selectedSubOptionFiveLabel == 'Five +') {
        //   routeToNavigate = '/fivePlusRoute';
        // } else if (_selectedSubOptionFiveLabel == 'Five -') {
        //   routeToNavigate = '/fiveMinusRoute';
        // } else if (_selectedSubOptionFiveLabel == 'Five +-') {
        //   routeToNavigate = '/fivePlusMinusRoute';
        // }
        routeToNavigate = '/FiveBuddy'; // No design
        break;
      case 'TEN+':
        // if (_selectedSubOptionTenPlusLabel == '+9') {
        //   routeToNavigate = '/tenPlus9Route';
        // } else if (_selectedSubOptionTenPlusLabel == '+8') {
        //   routeToNavigate = '/tenPlus8Route';
        // } else if (_selectedSubOptionTenPlusLabel == 'Random Lesson') {
        //   routeToNavigate = '/tenPlusRandomRoute';
        // }
        routeToNavigate = '/TenCouple';
        break;
      case 'TEN-':
        routeToNavigate = '/TenCouple';
        break;
      case 'MULTI':
        if (_selectedSubOptionMultiLabel == 'Multiplication') {
          routeToNavigate = '/Multiplication';
        } else if (_selectedSubOptionMultiLabel ==
            'MultiplicationRendomTable') {
          routeToNavigate = '/MultiplicationRendomTable';
        }
        break;
      case 'DIV':
        if (_selectedSubOptionDivLabel == 'Division') {
          routeToNavigate = '/Division';
        } else if (_selectedSubOptionMultiLabel == 'DivisionRandomTable') {
          routeToNavigate = '/DivisionRandomTable';
        }
        break;
      default:
        break;
    }

    if (routeToNavigate != null) {
      final setting = MathsSetting(
        digit1: selectedDigit1,
        digit2: selectedDigit2,
        display: selectedDisplay,
        row: selectedRow,
        time: selectedTime,
      );
      Navigator.pushNamed(context, routeToNavigate, arguments: setting);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Please select a sub-option or complete settings.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
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

  // Function to handle user logout
  Future<void> _logout() async {
    setState(() {
      isLoggingOut = true; // Show loading indicator
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
          isLoggingOut = false; // Hide loading indicator
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
              _buildRightButton(),
              _buildFooter(isSmallScreen),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground() => Positioned.fill(
    child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
  );

  Widget _buildHeader() => Positioned(
    top: 20,
    left: 20,
    child: Image.asset('assets/images/logo.png', width: 70),
  );

  Widget _buildUserInfo() => Positioned(
    top: 20,
    right: 0,
    child: Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.cyan[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Text(
              "ID : $uname",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            // const SizedBox(width: 8),
            // CircleAvatar(
            //   radius: 18,
            //   backgroundColor: Colors.black12,
            //   child: Icon(Icons.person, color: Colors.black),
            // ),
            Image.asset(
              'assets/images/user_icon.png',
              width: 70,
              fit: BoxFit.cover,
            ),
            isLoggingOut
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
                    tooltip: 'Logout', // Text that appears on long press
                  ),
          ],
        ),
      ),
    ),
  );

  Widget _buildMainMenu() => Positioned(
    top: 110,
    left: 50,
    right: 20,
    bottom: 50,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              title: 'LOWER & UPPER',
              color: const Color(0xFFFA7D9D),
              onPressed: () => selectMenu('LP'),
              isSelected: selectedMenu == 'LP',
            ),
            MenuButton(
              title: 'FIVE BUDDY + -',
              color: const Color(0xFF5CE1E6),
              onPressed: () => selectMenu('FIVE'),
              isSelected: selectedMenu == 'FIVE',
            ),
            MenuButton(
              title: 'TEN COUPLE +',
              color: const Color(0xFF5271FF),
              onPressed: () => selectMenu('TEN+'),
              isSelected: selectedMenu == 'TEN+',
            ),
            MenuButton(
              title: 'TEN COUPLE -',
              color: const Color(0xFF38B6FF),
              onPressed: () => selectMenu('TEN-'),
              isSelected: selectedMenu == 'TEN-',
            ),
            MenuButton(
              title: 'Multiplication x',
              color: const Color(0xFF7ED957),
              onPressed: () => selectMenu('MULTI'),
              isSelected: selectedMenu == 'MULTI',
            ),
            MenuButton(
              title: 'Division',
              color: const Color(0xFFC4A5FF),
              onPressed: () => selectMenu('DIV'),
              isSelected: selectedMenu == 'DIV',
            ),
            if (uname.isNotEmpty &&
                    (uname.toLowerCase() == "iqmaths.official") ||
                uname.toLowerCase() == "test")
              MenuButton(
                title: 'Register',
                color: Colors.white,
                onPressed: () => Navigator.pushNamed(context, "/Register"),
                isSelected: selectedMenu == 'Register',
              ),
          ],
        ),
      ),
    ),
  );

  Widget _buildRightButton() => Positioned(
    top: 250,
    right: 10,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: navigateToRoute,
          child: Image.asset('assets/images/start.png', width: 120),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            SystemNavigator.pop();
          },
          child: Image.asset('assets/images/exit.png', width: 120),
        ),
      ],
    ),
  );

  Widget _buildSubOptionsLP() => Positioned(
    top: 100,
    left: 270,
    right: 120,
    bottom: 50,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SubOptionsLP(
          onSubOptionSelected: (label) => _onSubOptionSelected('LP', label),
          selectedSubOptionLabel: _selectedSubOptionLPLabel,
          digit1: selectedDigit1,
          digit2: selectedDigit2,
          display: selectedDisplay,
          row: selectedRow,
          time: selectedTime,
          onSettingChanged: handleSettingChanged,
        ),
      ),
    ),
  );

  Widget _buildSubOptionsFive() => Positioned(
    top: 100,
    left: 270,
    right: 120,
    bottom: 50,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SubOptionsFive(
          onSubOptionSelected: (label) => _onSubOptionSelected('FIVE', label),
          selectedSubOptionLabel: _selectedSubOptionFiveLabel,
          digit1: selectedDigit1,
          digit2: selectedDigit2,
          display: selectedDisplay,
          row: selectedRow,
          time: selectedTime,
          onSettingChanged: handleSettingChanged,
        ),
      ),
    ),
  );

  Widget _buildSubOptionsTenPlus() => Positioned(
    top: 100,
    left: 270,
    right: 120,
    bottom: 50,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SubOptionsTenPlus(
          onSubOptionSelected: (label) => _onSubOptionSelected('TEN+', label),
          selectedSubOptionLabel: _selectedSubOptionTenPlusLabel,
          digit1: selectedDigit1,
          digit2: selectedDigit2,
          display: selectedDisplay,
          row: selectedRow,
          time: selectedTime,
          onSettingChanged: handleSettingChanged,
        ),
      ),
    ),
  );

  Widget _buildSubOptionsTenMinus() => Positioned(
    top: 100,
    left: 270,
    right: 120,
    bottom: 50,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SubOptionsTenMinus(
          onSubOptionSelected: (label) => _onSubOptionSelected('TEN-', label),
          selectedSubOptionLabel: _selectedSubOptionTenMinusLabel,
          digit1: selectedDigit1,
          digit2: selectedDigit2,
          display: selectedDisplay,
          row: selectedRow,
          time: selectedTime,
          onSettingChanged: handleSettingChanged,
        ),
      ),
    ),
  );

  Widget _buildSubOptionsMulti() => Positioned(
    top: 100,
    left: 270,
    right: 120,
    bottom: 50,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SubOptionsMulti(
          onSubOptionSelected: (label) => _onSubOptionSelected('MULTI', label),
          selectedSubOptionLabel: _selectedSubOptionMultiLabel,
          digit1: selectedDigit1,
          digit2: selectedDigit2,
          onSettingChanged: handleSettingChanged,
        ),
      ),
    ),
  );

  Widget _buildSubOptionsDiv() => Positioned(
    top: 100,
    left: 270,
    right: 120,
    bottom: 50,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SubOptionsDiv(
          onSubOptionSelected: (label) => _onSubOptionSelected('DIV', label),
          selectedSubOptionLabel: _selectedSubOptionDivLabel,
          digit1: selectedDigit1,
          digit2: selectedDigit2,
          onSettingChanged: handleSettingChanged,
        ),
      ),
    ),
  );

  Widget _buildFooter(bool isSmallScreen) => Positioned(
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
          Padding(
            padding: EdgeInsets.only(left: isSmallScreen ? 10 : 16),
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
            padding: EdgeInsets.only(right: isSmallScreen ? 10 : 16),
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
  );
}
