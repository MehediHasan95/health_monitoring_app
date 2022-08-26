import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class DatabaseHelper {
  static const _usersProfileCollection = 'userProfileInfo';
  static const _sensorDataCollection = 'sensorData';
  static const _doctorCollection = 'doctor';
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Create User Database
  static Future<void> createUserProfileInfo(
      String username, String gender, String email) async {
    final uid = AuthService.currentUser?.uid;
    return await db.collection(_usersProfileCollection).doc(uid!).set({
      "username": username,
      "gender": gender,
      "email": email,
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllDoctorData() =>
      db.collection(_doctorCollection).snapshots();
}
