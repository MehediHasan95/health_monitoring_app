import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class DatabaseHelper {
  static const _usersProfileCollection = 'userProfileInfo';
  static const _sensorDataCollection = 'sensorData';
  static const _doctorCollection = 'doctor';
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final _userID = AuthService.currentUser?.uid;

  // Create User Database
  static Future<void> createUserProfileInfo(String username, String gender,
      String email, DateTime dateOfBirth) async {
    return await db.collection(_usersProfileCollection).doc(_userID).set({
      "uid": _userID,
      "username": username,
      "gender": gender,
      "email": email,
      "birthday": dateOfBirth,
    });
  }

  static Future<void> addSensorData(SensorDataModel sensorDataModel) {
    return db
        .collection(_sensorDataCollection)
        .doc(_userID)
        .collection('userData')
        .add(sensorDataModel.toJson());
  }

// Doctor login method
  static Future<bool> isDoctor(String email) async {
    final snapshot = await db
        .collection(_doctorCollection)
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

// User login method
  static Future<bool> isUser(String email) async {
    final snapshot = await db
        .collection(_usersProfileCollection)
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

// Get all user data
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUserData() =>
      db.collection(_usersProfileCollection).snapshots();
}
