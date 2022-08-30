import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class DatabaseHelper {
  static const _usersProfileCollection = 'userProfileInfo';
  static const _sensorDataCollection = 'sensorData';
  static const _doctorCollection = 'doctor';
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final _user = AuthService.currentUser;

  // Create User Database
  static Future<void> createUserProfileInfo(String username, String gender,
      String email, DateTime dateOfBirth) async {
    return await db.collection(_usersProfileCollection).doc(_user?.uid).set({
      "uid": _user?.uid,
      "username": username,
      "gender": gender,
      "email": email,
      "birthday": dateOfBirth,
      "create": _user?.metadata.creationTime,
    });
  }

  static Future<void> addSensorData(SensorDataModel sensorDataModel) {
    final uid = AuthService.currentUser?.uid;
    return db
        .collection(_sensorDataCollection)
        .doc(uid)
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUserData() => db
      .collection(_usersProfileCollection)
      .orderBy('create', descending: true)
      .snapshots();
}
