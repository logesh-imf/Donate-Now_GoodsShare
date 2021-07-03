import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigned;
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
    _isSigned = false;
  }

  bool get isSigningIn => _isSigningIn;
  bool get isSigned => _isSigned;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _isSigned = true;
      isSigningIn = false;
    }
  }

  void logout() async {
    _isSigned = false;
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
