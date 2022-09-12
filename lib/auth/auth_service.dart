import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_monitoring_app/database/database_helper.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

// SignIn method
  static Future<String?> signInUser(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user?.uid;
  }

// user SignUp method
  static Future<String?> signUpUser(String username, String gender,
      DateTime dateOfBirth, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await DatabaseHelper.createUserProfileInfo(
        username, gender, email, dateOfBirth);
    return credential.user?.uid;
  }

  // Doctor SignUp method
  static Future<String?> doctorSignUpUser(
      String uniqueId,
      String name,
      String email,
      String password,
      String gender,
      String specialist,
      String hospital) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await DatabaseHelper.createDoctorProfileInfo(
        uniqueId, name, email, password, gender, specialist, hospital);
    return credential.user?.uid;
  }

// SignOut method
  static Future<void> signOut() async {
    return await _auth.signOut();
  }

// Reset password method
  static Future<void> passwordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
