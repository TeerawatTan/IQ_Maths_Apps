import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iq_maths_apps/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoBar extends StatefulWidget {
  final String userName;

  const UserInfoBar({required this.userName, super.key});

  @override
  State<UserInfoBar> createState() => _UserInfoBarState();
}

class _UserInfoBarState extends State<UserInfoBar> {
  bool isLoggingOut = false;
  static const String profileImagePathKey =
      'profileImagePath'; // คีย์สำหรับ SharedPreferences
  static const String isAssetImageKey =
      'isAssetImage'; // คีย์สำหรับ SharedPreferences
  String? profileImagePath;
  bool isAssetImage = true;
  ImageProvider? profileImage;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // โหลดรูปภาพที่บันทึกไว้เมื่อเริ่มต้น
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(profileImagePathKey);
    final isAsset =
        prefs.getBool(isAssetImageKey) ?? true; // Default to true if not set

    if (imagePath != null) {
      setState(() {
        profileImagePath = imagePath;
        isAssetImage = isAsset;
        // กำหนด profileImage ตรงนี้ด้วย
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
    setState(() {
      isLoggingOut = true; // Show loading indicator
    });

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
          isLoggingOut = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              "ID : ${widget.userName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(radius: 25, backgroundImage: profileImage),
            IconButton(
              icon: const Icon(Icons.logout),
              iconSize: 30.0,
              color: Color.fromARGB(255, 235, 99, 144),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
