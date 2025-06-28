import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iq_maths_apps/services/auth_service.dart';
import 'package:iq_maths_apps/widgets/common_layout.dart';
import 'package:iq_maths_apps/widgets/setting_menu_button.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_lp.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_five.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_tenplus.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_tenminus.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_multi.dart';
import 'package:iq_maths_apps/widgets/sub_options/sub_options_div.dart';
import 'package:iq_maths_apps/models/maths_setting.dart';

class HomeScreen extends StatefulWidget {
  final String? userId;
  const HomeScreen({super.key, this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMenu = '';
  String selectedDigit1 = '';
  String selectedDigit2 = '';
  String selectedDisplay = '';
  String selectedRow = '';
  String selectedTime = '';
  bool isSoundOn = true;
  bool isLoggingOut = false;
  String? selectedSubOptionLPLabel;
  String? selectedSubOptionFiveLabel;
  String? selectedSubOptionTenPlusLabel;
  String? selectedSubOptionTenMinusLabel;
  String? selectedSubOptionMultiLabel;
  String? selectedSubOptionDivLabel;

  String uname = FirebaseAuth.instance.currentUser == null
      ? ''
      : FirebaseAuth.instance.currentUser!.email!.substring(
          0,
          FirebaseAuth.instance.currentUser!.email!.indexOf('@'),
        );

  // StreamSubscription<DocumentSnapshot>? sessionListener; // ย้ายไป CommonLayout
  final AuthService authService = AuthService();
  // static const String profileImagePathKey = 'profileImagePath'; // ย้ายไป CommonLayout
  // static const String isAssetImageKey = 'isAssetImage'; // ย้ายไป CommonLayout
  // String? profileImagePath; // ย้ายไป CommonLayout
  // bool isAssetImage = true; // ย้ายไป CommonLayout
  // ImageProvider? profileImage; // ย้ายไป CommonLayout

  @override
  void initState() {
    super.initState();
    // ส่วนของการฟัง Session และโหลดรูปโปรไฟล์ถูกย้ายไปที่ CommonLayout แล้ว
    // final userId = widget.userId;
    // if (userId != null) {
    //   listenForSessionChanges(context, userId);
    // }
    // _loadProfileImage();
  }

  @override
  void dispose() {
    // sessionListener?.cancel(); // ย้ายไป CommonLayout
    super.dispose();
  }

  // listenForSessionChanges method ถูกย้ายไปที่ CommonLayout แล้ว

  // _loadProfileImage method ถูกย้ายไปที่ CommonLayout แล้ว

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
        return selectedSubOptionLPLabel != null;
      case 'FIVE':
        return selectedSubOptionFiveLabel != null;
      case 'TEN+':
        return selectedSubOptionTenPlusLabel != null;
      case 'TEN-':
        return selectedSubOptionTenMinusLabel != null;
      case 'MULTI':
        return selectedSubOptionMultiLabel != null;
      case 'DIV':
        return selectedSubOptionDivLabel != null;
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
      selectedSubOptionLPLabel = null;
      selectedSubOptionFiveLabel = null;
      selectedSubOptionTenPlusLabel = null;
      selectedSubOptionTenMinusLabel = null;
      selectedSubOptionMultiLabel = null;
      selectedSubOptionDivLabel = null;
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
          selectedSubOptionLPLabel = label;
          break;
        case 'FIVE':
          selectedSubOptionFiveLabel = label;
          break;
        case 'TEN+':
          selectedSubOptionTenPlusLabel = label;
          break;
        case 'TEN-':
          selectedSubOptionTenMinusLabel = label;
          break;
        case 'MULTI':
          selectedSubOptionMultiLabel = label;
          break;
        case 'DIV':
          selectedSubOptionDivLabel = label;
          break;
      }
      selectedDigit1 = '';
      selectedDigit2 = '';
      selectedDisplay = '';
      selectedRow = '';
      selectedTime = '';
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
    String? currentSelectedSubOptionLabel;
    switch (selectedMenu) {
      case 'LP':
        if (selectedSubOptionLPLabel == 'Lower') {
          routeToNavigate = '/Lower';
        } else if (selectedSubOptionLPLabel == 'Upper') {
          routeToNavigate = '/Upper';
        } else if (selectedSubOptionLPLabel == 'Lower&Upper') {
          routeToNavigate = '/LowerAndUpper';
        }
        currentSelectedSubOptionLabel = selectedSubOptionLPLabel;
        break;
      case 'FIVE':
        routeToNavigate = '/FiveBuddy';
        currentSelectedSubOptionLabel = selectedSubOptionFiveLabel;
        break;
      case 'TEN+':
        routeToNavigate = '/TenCouple';
        currentSelectedSubOptionLabel = selectedSubOptionTenPlusLabel;
        break;
      case 'TEN-':
        if (selectedSubOptionTenMinusLabel == 'Random Exercise') {
          routeToNavigate = '/RandomExercise';
        } else {
          routeToNavigate = '/TenCouple';
        }
        currentSelectedSubOptionLabel = selectedSubOptionTenMinusLabel;
        break;
      case 'MULTI':
        if (selectedSubOptionMultiLabel == 'Multiplication') {
          routeToNavigate = '/Multiplication';
        } else if (selectedSubOptionMultiLabel ==
            'Multiplication Random Table') {
          routeToNavigate = '/MultiplicationRendomTable';
        }
        currentSelectedSubOptionLabel = selectedSubOptionMultiLabel;
        break;
      case 'DIV':
        if (selectedSubOptionDivLabel == 'Division') {
          routeToNavigate = '/Division';
        } else if (selectedSubOptionDivLabel == 'Division Random Table') {
          routeToNavigate = '/DivisionRandomTable';
        }
        currentSelectedSubOptionLabel = selectedSubOptionDivLabel;
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
        selectedSubOptionLabel: currentSelectedSubOptionLabel ?? '',
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

  @override
  Widget build(BuildContext context) {
    // ใช้ CommonLayout เพื่อห่อหุ้มเนื้อหาเฉพาะของ HomeScreen
    return CommonLayout(
      userId: widget.userId, // ส่ง UID ไปยัง CommonLayout
      child: Stack(
        children: [
          // เนื้อหาเฉพาะของ HomeScreen จะอยู่ที่นี่
          _buildMainMenu(),
          if (selectedMenu == 'LP') _buildSubOptionsLP(),
          if (selectedMenu == 'FIVE') _buildSubOptionsFive(),
          if (selectedMenu == 'TEN+') _buildSubOptionsTenPlus(),
          if (selectedMenu == 'TEN-') _buildSubOptionsTenMinus(),
          if (selectedMenu == 'MULTI') _buildSubOptionsMulti(),
          if (selectedMenu == 'DIV') _buildSubOptionsDiv(),
          if (selectedMenu.isNotEmpty) _buildStartButton(),
          _buildExitAppButton(),
        ],
      ),
    );
  }

  // Widget สำหรับ Main Menu
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
          ],
        ),
      ),
    ),
  );

  // Widget สำหรับปุ่ม Start
  Widget _buildStartButton() => Positioned(
    bottom: 110,
    right: 10,
    child: InkWell(
      onTap: navigateToRoute,
      child: Image.asset('assets/images/start.png', width: 120),
    ),
  );

  // Widget สำหรับปุ่ม Exit App
  Widget _buildExitAppButton() => Positioned(
    bottom: 50,
    right: 10,
    child: InkWell(
      onTap: () {
        SystemNavigator.pop();
      },
      child: Image.asset('assets/images/exit.png', width: 120),
    ),
  );

  // Widgets สำหรับ Sub-options ต่างๆ (LP, FIVE, TEN+, TEN-, MULTI, DIV)
  // ยังคงอยู่ใน HomeScreen เนื่องจากเป็นส่วนเฉพาะของหน้านี้
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
          selectedSubOptionLabel: selectedSubOptionLPLabel,
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
          selectedSubOptionLabel: selectedSubOptionFiveLabel,
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
          selectedSubOptionLabel: selectedSubOptionTenPlusLabel,
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
          selectedSubOptionLabel: selectedSubOptionTenMinusLabel,
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
          selectedSubOptionLabel: selectedSubOptionMultiLabel,
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
          selectedSubOptionLabel: selectedSubOptionDivLabel,
          digit1: selectedDigit1,
          digit2: selectedDigit2,
          onSettingChanged: handleSettingChanged,
        ),
      ),
    ),
  );
}
