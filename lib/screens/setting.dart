import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class MathsSetting {
  String digit1;
  String digit2;
  String display;
  String row;
  String time;

  MathsSetting({
    this.digit1 = '',
    this.digit2 = '',
    this.display = '',
    this.row = '',
    this.time = '',
  });

  bool isValid() {
    final d = display.trim().toLowerCase();

    final needsOnlyBasicFields = d == "multiplication";
    final needsOnlyBasicFieldsd = d == "division";
    if (needsOnlyBasicFields) {
      return digit1.isNotEmpty && digit2.isNotEmpty && time.isNotEmpty;
    } else if (needsOnlyBasicFieldsd) {
      return digit1.isNotEmpty && digit2.isNotEmpty && time.isNotEmpty;
    }

    return digit1.isNotEmpty &&
        digit2.isNotEmpty &&
        display.isNotEmpty &&
        row.isNotEmpty &&
        time.isNotEmpty;
  }
}

class _SettingScreenState extends State<SettingScreen> {
  bool showSubLPOptions = false;
  bool showSubFiveOptions = false;
  bool showSubTenplusOptions = false;
  bool showSubTenminusOptions = false;
  bool showSubMultiOptions = false;
  bool showSubDivisionOptions = false;
  bool isSoundOn = true;

  String selectedDigit1 = '';
  String selectedDigit2 = '';
  String selectedDisplay = '';
  String selectedRow = '';
  String selectedTime = '';

  void clearSetting() {
    setState(() {
      selectedDigit1 = '';
      selectedDigit2 = '';
      selectedDisplay = '';
      selectedRow = '';
      selectedTime = '';
    });
  }

  void toggleMenu(String target) {
    setState(() {
      clearSetting();

      showSubLPOptions = target == "LP" ? !showSubLPOptions : false;
      showSubFiveOptions = target == "FIVE" ? !showSubFiveOptions : false;
      showSubTenplusOptions = target == "TEN+" ? !showSubTenplusOptions : false;
      showSubTenminusOptions = target == "TEN-"
          ? !showSubTenminusOptions
          : false;
      showSubMultiOptions = target == "MULTI" ? !showSubMultiOptions : false;
      showSubDivisionOptions = target == "DIV"
          ? !showSubDivisionOptions
          : false;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDigit1 = '';
    selectedDigit2 = '';
    selectedDisplay = '';
    selectedRow = '';
    selectedTime = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildLogo(),
          _buildHeader(),
          _buildFoot(),
          _buildUserInfo(),
          _buildMainMenu(),
          if (showSubLPOptions) _buildSubOptions("LP"),
          if (showSubFiveOptions) _buildSubOptions("FIVE"),
          if (showSubTenplusOptions) _buildSubOptions("TEN+"),
          if (showSubTenminusOptions) _buildSubOptions("TEN-"),
          if (showSubMultiOptions) _buildSubOptions("MULTI"),
          if (showSubDivisionOptions) _buildSubOptions("DIV"),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBackground() => Positioned.fill(
    child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
  );

  Widget _buildLogo() => Positioned(
    top: 30,
    left: 20,
    child: Image.asset('assets/images/logo.png', width: 70),
  );

  Widget _buildHeader() => Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Center(
      child: Image.asset('assets/images/iq_maths_icon.png', width: 130),
    ),
  );

  Widget _buildUserInfo() => Positioned(
    top: 30,
    right: 20,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.cyan[100],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Text(
            "ID : User Test",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          SizedBox(width: 8),
          CircleAvatar(
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
          _menuButton(
            "LOWER & UPPER",
            Color(0xFFFA7D9D),
            () => toggleMenu("LP"),
          ),
          _menuButton(
            "FIVE BUDDY + -",
            Color(0xFF5CE1E6),
            () => toggleMenu("FIVE"),
          ),
          _menuButton(
            "TEN COUPLE +",
            Color(0xFF5271FF),
            () => toggleMenu("TEN+"),
          ),
          _menuButton(
            "TEN COUPLE -",
            Color(0xFF38B6FF),
            () => toggleMenu("TEN-"),
          ),
          _menuButton(
            "Multiplication x",
            Color(0xFF7ED957),
            () => toggleMenu("MULTI"),
          ),
          _menuButton("Division", Color(0xFFC4A5FF), () => toggleMenu("DIV")),
        ],
      ),
    ),
  );

  Widget _buildSubOptions(String type) {
    return Positioned(
      top: 115,
      left: 270,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type == "LP") ...[
              Row(
                children: [
                  _subOptionButton("Lower", "/Lower", Color(0xFFFA7D9D)),
                  SizedBox(width: 40),
                  _subOptionButton("Upper", "/Upper", Color(0xFFFA7D9D)),
                  SizedBox(width: 40),
                  _subOptionButton(
                    "Lower&Upper",
                    "/LowerUpper",
                    Color(0xFFFA7D9D),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "Setting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              _settingRow(["Digit 1", "Display"]),
              SizedBox(height: 8),
              _settingRow(["Digit 2", "Time"]),
              SizedBox(height: 8),
              _settingRow(["Row"]),
            ],
            if (type == "FIVE")
              SizedBox(
                height: 240,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "FIVE BUDDY +",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Five +4",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five +3",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five +2",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five +1",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "FIVE BUDDY -",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Five -4",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five -3",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five -2",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five -1",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "five buddy",
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Setting",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      _settingRow(["Digit 1", "Display"]),
                      SizedBox(height: 8),
                      _settingRow(["Digit 2", "Time"]),
                      SizedBox(height: 8),
                      _settingRow(["Row"]),
                    ],
                  ),
                ),
              ),
            if (type == "TEN+")
              SizedBox(
                height: 240,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Text(
                            "TEN COUPLE +",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.blueAccent,
                            ),
                          ),
                          const Text(
                            "TEN COUPLE +",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Ten +9",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten +8",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten +7",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten +6",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten +5",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Ten +4",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten +3",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten +2",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten +1",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Readom Lesson",
                            "/",
                            Color.fromARGB(255, 255, 0, 0),
                            displayOverride: "ten plus",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Stack(
                        children: [
                          Text(
                            "FIVE & TEN COUPLE +",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.blue,
                            ),
                          ),
                          const Text(
                            "FIVE & TEN COUPLE +",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Five & Ten +9",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five & Ten +8",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five & Ten +7",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten plus",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Five & Ten +6",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten plus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Readom Lesson",
                            "/",
                            Color.fromARGB(255, 255, 0, 0),
                            displayOverride: "ten plus",
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Setting",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      _settingRow(["Digit 1", "Display"]),
                      SizedBox(height: 8),
                      _settingRow(["Digit 2", "Time"]),
                      SizedBox(height: 8),
                      _settingRow(["Row"]),
                    ],
                  ),
                ),
              ),
            if (type == "TEN-")
              SizedBox(
                height: 240,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Text(
                            "TEN COUPLE -",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.blueAccent,
                            ),
                          ),
                          const Text(
                            "TEN COUPLE -",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Ten -9",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten -8",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten -7",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten -6",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten -5",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Ten -4",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten -3",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten -2",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Ten -1",
                            "/",
                            Color(0xFF5271FF),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Readom Lesson",
                            "/",
                            Color.fromARGB(255, 255, 0, 0),
                            displayOverride: "ten minus",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Stack(
                        children: [
                          Text(
                            "FIVE & TEN COUPLE -",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.blue,
                            ),
                          ),
                          const Text(
                            "FIVE & TEN COUPLE -",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Five & Ten -9",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five & Ten -8",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Five & Ten -7",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten minus",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _subOptionButton(
                            "Five & Ten -6",
                            "/",
                            Color(0xFFA3DEE8),
                            displayOverride: "ten minus",
                          ),
                          SizedBox(width: 10),
                          _subOptionButton(
                            "Readom Lesson",
                            "/",
                            Color.fromARGB(255, 255, 0, 0),
                            displayOverride: "ten minus",
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Setting",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      _settingRow(["Digit 1", "Display"]),
                      SizedBox(height: 8),
                      _settingRow(["Digit 2", "Time"]),
                      SizedBox(height: 8),
                      _settingRow(["Row"]),
                    ],
                  ),
                ),
              ),
            if (type == "MULTI") ...[
              Row(
                children: [
                  _subOptionButton(
                    "Multiplication",
                    "/Multiplication",
                    Color(0xFF7ED957),
                    displayOverride: "multiplication",
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "Setting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              _settingRow(["Digit 1", "Time"]),
              SizedBox(height: 10),
              _settingRow(["Digit 2"]),
            ],
            if (type == "DIV") ...[
              Row(
                children: [
                  _subOptionButton(
                    "Division",
                    "/Division",
                    Color(0xFFC4A5FF),
                    displayOverride: "division",
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "Setting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              _settingRow(["Digit 1", "Time"]),
              SizedBox(height: 10),
              _settingRow(["Digit 2"]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _settingRow(List<String> labels) => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: labels.map((label) => _dropdownBox(label)).toList(),
  );

  Widget _buildFoot() => Positioned(
    bottom: 60,
    right: 10,
    child: Image.asset('assets/images/maths_icon4.png', width: 90),
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

  Widget _menuButton(String title, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white, width: 3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }

  Widget _subOptionButton(
    String label,
    String route,
    Color color, {
    String? displayOverride,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      onPressed: () async {
        try {
          final setting = MathsSetting(
            digit1: selectedDigit1,
            digit2: selectedDigit2,
            display: displayOverride ?? selectedDisplay,
            row: selectedRow,
            time: selectedTime,
          );

          if (setting.isValid()) {
            await Future.delayed(Duration(milliseconds: 500));

            if (!mounted) return;

            await Navigator.pushNamed(context, route, arguments: setting);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  elevation: 0,
                  behavior: SnackBarBehavior.fixed,
                  duration: const Duration(seconds: 2),
                  content: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Please complete all the settings first",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
          }
        } catch (e) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text("Navigation failed: $e"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Text(label),
    );
  }

  Widget _dropdownBox(String label) {
    List<Map<String, String>> options;

    switch (label) {
      case "Digit 1":
        options = [
          {'label': '1', 'value': '1'},
          {'label': '2', 'value': '2'},
          {'label': '3', 'value': '3'},
        ];
        break;
      case "Display":
        options = [
          {'label': 'Flash card', 'value': 'Flash card'},
          {'label': 'Show all', 'value': 'Show all'},
        ];
        break;
      case "Digit 2":
        options = [
          {'label': '1', 'value': '1'},
          {'label': '2', 'value': '2'},
          {'label': '3', 'value': '3'},
        ];
        break;
      case "Row":
        options = [
          {'label': '3', 'value': '3'},
          {'label': '4', 'value': '4'},
          {'label': '5', 'value': '5'},
          {'label': '6', 'value': '6'},
        ];

        break;
      case "Time":
        options = [
          {'label': '1', 'value': '1'},
          {'label': '2', 'value': '2'},
          {'label': '3', 'value': '3'},
          {'label': '4', 'value': '4'},
          {'label': '5', 'value': '5'},
          {'label': '10', 'value': '10'},
          {'label': '15', 'value': '15'},
          {'label': '30', 'value': '30'},
          {'label': '60', 'value': '60'},
        ];

        break;
      default:
        options = [
          {'label': '0', 'value': '0'},
          {'label': '1', 'value': '1'},
        ];
    }

    String? selectedValue = _getSelectedValue(label);
    if (!options.any((opt) => opt['value'] == selectedValue)) {
      selectedValue = null;
    }
    return Container(
      width: 120,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 126, 217, 87),
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: (selectedValue == null || selectedValue.isEmpty)
              ? null
              : selectedValue,
          hint: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _setSelectedValue(label, value!));
          },
        ),
      ),
    );
  }

  String _getSelectedValue(String label) {
    switch (label) {
      case "Digit 1":
        return selectedDigit1;
      case "Digit 2":
        return selectedDigit2;
      case "Display":
        return selectedDisplay;
      case "Row":
        return selectedRow;
      case "Time":
        return selectedTime;
      default:
        return '';
    }
  }

  void _setSelectedValue(String label, String value) {
    switch (label) {
      case "Digit 1":
        selectedDigit1 = value;
        break;
      case "Digit 2":
        selectedDigit2 = value;
        break;
      case "Display":
        selectedDisplay = value;
        break;
      case "Row":
        selectedRow = value;
        break;
      case "Time":
        selectedTime = value;
        break;
    }
  }
}
