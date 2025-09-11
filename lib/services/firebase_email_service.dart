import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEmailService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('ไม่สามารถส่งอีเมลยืนยันได้: $e');
    }
  }
  
  static Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }
}