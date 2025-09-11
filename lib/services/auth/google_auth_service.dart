import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google Sign-In process');
      
      // ล้าง cache ก่อน
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint('Google Sign-In was cancelled by user');
        return {'cancelled': true};
      }

      debugPrint('Google user signed in: ${googleUser.email}');
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      debugPrint('Access Token: ${googleAuth.accessToken != null ? 'Available' : 'Null'}');
      debugPrint('ID Token: ${googleAuth.idToken != null ? 'Available' : 'Null'}');
      
      return {
        'name': googleUser.displayName ?? 'Google User',
        'email': googleUser.email,
        'id': googleUser.id,
        'photoUrl': googleUser.photoUrl,
        'cancelled': false,
        'hasTokens': googleAuth.accessToken != null && googleAuth.idToken != null,
      };
    } on PlatformException catch (e) {
      debugPrint('Google Sign-In PlatformException: ${e.code} - ${e.message}');
      debugPrint('Details: ${e.details}');
      return {'error': e.code, 'message': e.message};
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return {'error': 'unknown', 'message': e.toString()};
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  static GoogleSignInAccount? getCurrentUser() {
    return _googleSignIn.currentUser;
  }
}