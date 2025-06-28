import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonLayout extends StatefulWidget {
  final Widget child;
  final String? userId; // UserId สำหรับการตรวจสอบ Session
  final bool customBottomBar;
  final bool isSoundOn;
  final ValueChanged<bool>? onSoundToggle;

  const CommonLayout({
    super.key,
    required this.child,
    this.userId,
    this.customBottomBar = false,
    this.isSoundOn = true,
    this.onSoundToggle,
  });

  @override
  State<CommonLayout> createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  StreamSubscription<DocumentSnapshot>? sessionListener;
  final AuthService authService = AuthService();
  static const String profileImagePathKey =
      'profileImagePath'; // Key สำหรับ SharedPreferences
  static const String isAssetImageKey =
      'isAssetImage'; // Key สำหรับ SharedPreferences
  String? profileImagePath;
  bool isAssetImage = true;
  ImageProvider? profileImage;
  late bool currentIsSoundOn;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _listenForSessionChanges(context, widget.userId!);
    }
    _loadProfileImage();
    currentIsSoundOn = widget.isSoundOn;
  }

  @override
  void dispose() {
    sessionListener?.cancel(); // ยกเลิก Listener เมื่อ Widget ถูก dispose
    super.dispose();
  }

  // ฟังก์ชันสำหรับฟังการเปลี่ยนแปลงของ Session ใน Firestore
  Future<void> _listenForSessionChanges(
    BuildContext context,
    String userId,
  ) async {
    final currentDeviceId = await authService
        .getDeviceId(); // ดึง Device ID ปัจจุบัน

    sessionListener = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((doc) async {
          // ถ้า Document ไม่มีอยู่ (ผู้ใช้ถูกลบหรือ Session หมดอายุ)
          if (!doc.exists) {
            if (FirebaseAuth.instance.currentUser != null) {
              await authService.logout(); // Logout ผู้ใช้
            }
            sessionListener?.cancel(); // ยกเลิก Listener
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/'); // กลับไปหน้า Login
            }
            return;
          }
          final remoteDeviceId = doc.get(
            'deviceId',
          ); // ดึง Device ID จาก Firestore
          // ถ้า Device ID ไม่ตรงกัน (มีการ Login จากอุปกรณ์อื่น)
          if (remoteDeviceId != currentDeviceId) {
            if (FirebaseAuth.instance.currentUser != null) {
              await authService.logout(); // Logout ผู้ใช้
            }
            sessionListener?.cancel(); // ยกเลิก Listener

            if (context.mounted) {
              // แสดง Dialog แจ้งเตือน
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('บัญชีถูกใช้งานจากอุปกรณ์อื่น'),
                  content: const Text('คุณถูกออกจากระบบ'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/',
                        ); // กลับไปหน้า Login
                      },
                      child: const Text('ตกลง'),
                    ),
                  ],
                ),
              );
            }
          }
        });
  }

  // ฟังก์ชันสำหรับโหลดรูปโปรไฟล์จาก SharedPreferences
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(profileImagePathKey);
    final isAsset = prefs.getBool(isAssetImageKey) ?? true;

    if (imagePath != null) {
      setState(() {
        profileImagePath = imagePath;
        isAssetImage = isAsset;
        if (isAssetImage) {
          profileImage = AssetImage(profileImagePath!);
        } else {
          profileImage = FileImage(File(profileImagePath!));
        }
      });
    } else {
      setState(() {
        profileImagePath = null;
        isAssetImage = true;
        profileImage = const AssetImage('assets/images/user_icon.png');
      });
    }
  }

  Future<void> _logout() async {
    try {
      await authService.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
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
          // Flag logout somthings.
        });
      }
    }
  }

  // Widget สำหรับ Background
  Widget _buildBackground() => Positioned.fill(
    child: Image.asset('assets/images/bg4.png', fit: BoxFit.cover),
  );

  // Widget สำหรับ Header (โลโก้)
  Widget _buildHeader() => Positioned(
    top: 20,
    left: 20,
    child: Image.asset('assets/images/logo.png', width: 70),
  );

  // Widget สำหรับ User Info (ชื่อผู้ใช้และรูปโปรไฟล์)
  Widget _buildUserInfo() {
    final uname = authService.getUserName();
    return Positioned(
      top: 10,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
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
              SizedBox(width: 10),
              CircleAvatar(radius: 25, backgroundImage: profileImage),
              IconButton(
                icon: const Icon(Icons.logout),
                iconSize: 30.0,
                color: const Color.fromARGB(255, 235, 99, 144),
                onPressed: _logout,
                tooltip: 'Logout',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สำหรับ Footer
  Widget _widgetBuildFooter(bool isSmallScreen) => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      color: Colors.lightBlueAccent,
      height: isSmallScreen ? 32 : 35,
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
          widget.customBottomBar
              ? Padding(
                  padding: EdgeInsets.only(right: isSmallScreen ? 10 : 16),
                  child: Text(
                    "v.1.0.0",
                    style: TextStyle(
                      color: Colors.white10,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(right: isSmallScreen ? 10 : 16),
                  child: Row(
                    children: [
                      Text(
                        "Sound ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                      Image.asset(
                        'assets/images/sound_icon.png',
                        width: 22,
                        height: 22,
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: currentIsSoundOn,
                          onChanged: (value) {
                            setState(() {
                              currentIsSoundOn = value;
                              if (widget.onSoundToggle != null) {
                                widget.onSoundToggle!(value);
                              }
                            });
                          },
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.red,
                          inactiveTrackColor: const Color.fromARGB(
                            255,
                            235,
                            116,
                            107,
                          ),
                        ),
                      ),
                      Text(
                        currentIsSoundOn ? "ON" : "OFF",
                        style: TextStyle(
                          color: currentIsSoundOn ? Colors.white : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600; // ตรวจสอบขนาดหน้าจอ
          return Stack(
            children: [
              _buildBackground(),
              _buildHeader(),
              _buildUserInfo(),
              widget.child,
              _widgetBuildFooter(isSmallScreen),
            ],
          );
        },
      ),
    );
  }
}
