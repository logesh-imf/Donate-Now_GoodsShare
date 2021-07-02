import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices with ChangeNotifier {
  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  String _errorMessage;
  String get errorMessage => _errorMessage;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> register(String email, String password, context) async {
    try {
      setLoading(true);
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;
      setMessage('success');
      setLoading(false);
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        setMessage('The account Already exists');
        setLoading(false);
      } else if (e.code == 'weak-password') {
        setMessage('The password provided is too weak.');
        setLoading(false);
      }
    }
  }

  Future<dynamic> login(String email, String password, context) async {
    try {
      setLoading(true);

      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = authResult.user;
      setMessage('success');
      setLoading(false);
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setMessage('user not found');
        setLoading(false);
      } else if (e.code == 'wrong-password') {
        setMessage('Wrong password provided for that user');
        setLoading(false);
      }
    } catch (e) {}
  }

  Future logout() async {
    firebaseAuth.signOut();
    notifyListeners();
  }

  void setLoading(val) {
    _isSigningIn = val;
    notifyListeners();
  }

  void setMessage(val) {
    _errorMessage = val;
    notifyListeners();
  }

  Stream<User> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
