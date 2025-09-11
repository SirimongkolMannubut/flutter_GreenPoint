import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    signInOption: SignInOption.standard,
    serverClientId: '537093431389-v3uojqh1214if9pab6l40fqcch5jik78.apps.googleusercontent.com',
  );

  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Sign out first to ensure clean state
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint('Google Sign-In was cancelled by user');
        return {'cancelled': true};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint('Failed to get Google authentication tokens');
        return null;
      }
      
      // Return user data without Firebase for now
      return {
        'name': googleUser.displayName ?? 'Google User',
        'email': googleUser.email,
        'id': googleUser.id,
        'photoUrl': googleUser.photoUrl,
        'cancelled': false,
      };
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return null;
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