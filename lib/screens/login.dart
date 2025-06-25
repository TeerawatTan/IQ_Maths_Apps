import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/services/auth_service.dart';
import 'package:image_picker/image_picker.dart'; // นำเข้า image_picker สำหรับเลือกรูปภาพ
import 'package:shared_preferences/shared_preferences.dart'; // นำเข้า shared_preferences สำหรับเก็บข้อมูล
import 'dart:io'; // จำเป็นสำหรับคลาส File

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isSoundOn = true;
  bool _isLoading = false;
  String?
  _profileImagePath; // สำหรับเก็บเส้นทางไฟล์รูปภาพ (อาจเป็น asset หรือ file path)
  bool _isAssetImage = true; // ระบุว่าเป็นรูปจาก asset หรือไม่

  static const String _profileImagePathKey =
      'profileImagePath'; // คีย์สำหรับ SharedPreferences
  static const String _isAssetImageKey =
      'isAssetImage'; // คีย์สำหรับ SharedPreferences

  // รายการรูปภาพ Avatar เริ่มต้น
  final List<String> _defaultAvatars = [
    'assets/avatars/1.png',
    'assets/avatars/2.png',
    'assets/avatars/3.png',
    'assets/avatars/4.png',
    'assets/avatars/5.png',
    'assets/avatars/6.png',
    'assets/avatars/7.png',
    'assets/avatars/8.png',
    'assets/avatars/9.png',
    'assets/avatars/10.png',
    'assets/avatars/11.png',
    'assets/avatars/12.png',
    'assets/avatars/13.png',
    'assets/avatars/14.png',
    'assets/avatars/15.png',
    'assets/avatars/16.png',
    'assets/avatars/17.png',
    'assets/avatars/18.png',
    'assets/avatars/19.png',
    'assets/avatars/20.png',
    'assets/avatars/21.png',
    'assets/avatars/22.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // โหลดรูปภาพที่บันทึกไว้เมื่อเริ่มต้น
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // โหลดเส้นทางรูปโปรไฟล์และประเภทรูปภาพจาก SharedPreferences
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_profileImagePathKey);
    final isAsset =
        prefs.getBool(_isAssetImageKey) ?? true; // Default to true if not set

    if (imagePath != null) {
      setState(() {
        _profileImagePath = imagePath;
        _isAssetImage = isAsset;
      });
    }
  }

  // บันทึกเส้นทางรูปโปรไฟล์และประเภทรูปภาพลง SharedPreferences
  Future<void> _saveProfileImage(String path, bool isAsset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImagePathKey, path);
    await prefs.setBool(_isAssetImageKey, isAsset);
  }

  // ฟังก์ชันสำหรับเลือกรูปภาพจากแกลเลอรี
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
        _isAssetImage = false;
      });
      await _saveProfileImage(image.path, false);
    }
  }

  // ฟังก์ชันสำหรับเลือกรูปภาพจาก Avatar
  void _pickImageFromAvatar(String avatarPath) {
    setState(() {
      _profileImagePath = avatarPath;
      _isAssetImage = true;
    });
    _saveProfileImage(avatarPath, true);
  }

  void _showImageSourceSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('เลือกจาก Avatar'),
                onTap: () {
                  Navigator.pop(context);
                  _showAvatarSelectionDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกจากอัลบั้ม'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือก Avatar'),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.5,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _defaultAvatars.length,
              itemBuilder: (context, index) {
                final avatarPath = _defaultAvatars[index];
                return GestureDetector(
                  onTap: () {
                    _pickImageFromAvatar(avatarPath);
                    Navigator.pop(context); // ปิด Dialog
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _profileImagePath == avatarPath
                            ? const Color.fromARGB(255, 235, 99, 144)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(avatarPath),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันตรวจสอบความถูกต้องของข้อมูลแบบกำหนดเองที่แสดง ScaffoldMessenger
  bool _validateInputs() {
    String? emailError;
    String? passwordError;

    // ตรวจสอบอีเมล
    if (emailController.text.isEmpty) {
      emailError = 'กรุณาใส่อีเมลของคุณ';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      emailError = 'กรุณาใส่อีเมลที่ถูกต้อง';
    }

    // ตรวจสอบรหัสผ่าน
    if (passwordController.text.isEmpty) {
      passwordError = 'กรุณาใส่รหัสผ่านของคุณ';
    }

    // แสดงข้อความผิดพลาดหากการตรวจสอบไม่สำเร็จ
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

    bool success = await _authService.login(
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
    bool isShowKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
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
              child: Image.asset('assets/images/maths_icon3.png', width: 90),
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
                    GestureDetector(
                      // ครอบรูปภาพด้วย GestureDetector
                      onTap:
                          _showImageSourceSelectionSheet, // เรียกฟังก์ชันแสดงตัวเลือกการเลือกรูป
                      child: Container(
                        width: 100,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // แสดงรูปภาพที่เลือกหรือไอคอนผู้ใช้เริ่มต้น
                          image: _profileImagePath != null
                              ? (_isAssetImage
                                    ? DecorationImage(
                                        image: AssetImage(_profileImagePath!),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: FileImage(
                                          File(_profileImagePath!),
                                        ),
                                        fit: BoxFit.cover,
                                      ))
                              : const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/user_icon.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        // เพิ่มไอคอนแก้ไขเล็กๆ เพื่อบ่งชี้ว่าสามารถแตะได้
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Color.fromARGB(255, 235, 99, 144),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    _buildLoginField(
                      label: "อีเมล :",
                      controller: emailController,
                      icon: Icons.email,
                    ),

                    const SizedBox(height: 8),
                    _buildLoginField(
                      label: "รหัสผ่าน :",
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "เข้าสู่ระบบ",
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Intelligent Quick Maths (IQM)",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
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
        boxShadow: const [
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
