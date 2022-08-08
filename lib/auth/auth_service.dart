import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

  static Future<String?> signInUser(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user?.uid;
  }

  static Future<String?> signUpUser(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user?.uid;
  }

  static Future<void> signOut() {
    return _auth.signOut();
  }

  static Future<void> passwordReset(String email) async {
    final credential = await _auth.sendPasswordResetEmail(email: email);
    return credential;
  }
}
