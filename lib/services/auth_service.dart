import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedId = prefs.getString('deviceId');

    if (savedId != null) return savedId;

    final deviceInfo = DeviceInfoPlugin();
    String deviceId;

    if (await deviceInfo.deviceInfo is AndroidDeviceInfo) {
      final info = await deviceInfo.androidInfo;
      deviceId = info.id;
    } else {
      final info = await deviceInfo.iosInfo;
      deviceId = info.identifierForVendor ?? 'unknown';
    }

    await prefs.setString('deviceId', deviceId);
    return deviceId;
  }

  Future<bool> login(String email, String password) async {
    try {
      // Login firebase
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCred.user!.uid;
      String currentDeviceId = await getDeviceId();

      // Force update: บันทึก deviceId ใหม่ → เตะเครื่องเก่าออก
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'deviceId': currentDeviceId,
        'lastLogin': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
