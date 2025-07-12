import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId;

    if (await deviceInfo.deviceInfo is AndroidDeviceInfo) {
      final info = await deviceInfo.androidInfo;
      deviceId = info.id;
    } else {
      final info = await deviceInfo.iosInfo;
      deviceId = info.identifierForVendor ?? 'unknown';
    }

    return deviceId;
  }

  Future<bool> login(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCred.user?.uid;
      if (uid == null) {
        log('Login error: User UID is null');
        return false;
      }
      final currentDeviceId = await getDeviceId();

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'deviceId': currentDeviceId,
        'lastLogin': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        // หรือ 'user-not-found', 'wrong-password'
        log('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
      } else if (e.code == 'user-disabled') {
        log('บัญชีผู้ใช้ถูกปิดใช้งาน');
      } else {
        log('เกิดข้อผิดพลาดในการเข้าสู่ระบบ: ${e.message}');
      }
      return false;
    } catch (e, stack) {
      log('Login error: $e', stackTrace: stack);
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String? getUserId() => _auth.currentUser?.uid;

  String getUserName() {
    String uname = '';
    if (_auth.currentUser != null) {
      try {
        uname = _auth.currentUser!.email!.substring(
          0,
          _auth.currentUser!.email!.indexOf('@'),
        );
      } catch (e) {
        return uname;
      }
    }
    return uname;
  }
}
