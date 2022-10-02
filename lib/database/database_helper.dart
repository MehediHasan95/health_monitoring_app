import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class DatabaseHelper {
  static const _usersProfileCollection = 'userProfileInfo';
  static const _sensorDataCollection = 'sensorData';
  static const _doctorCollection = 'doctor';
  static const _specialistCollection = 'Specialist';
  static const _hospitalCollection = 'Hospital';

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
      "status": "Offline"
    });
  }

// Create Doctor Database
  static Future<void> createDoctorProfileInfo(
      String uniqueId,
      String username,
      String email,
      String password,
      String gender,
      String specialist,
      String hospital) async {
    return await db.collection(_doctorCollection).doc(_userID).set({
      "uid": _userID,
      "uniqueId": uniqueId,
      "name": username,
      "email": email,
      "gender": gender,
      "specialist": specialist,
      "hospital": hospital,
      "status": "Offline"
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

// Get all doctor data
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllDoctorData() =>
      db.collection(_doctorCollection).snapshots();

// Get all Specialist list
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllSpecialist() =>
      db.collection(_specialistCollection).snapshots();

// Get all hospital list
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllHospital() =>
      db.collection(_hospitalCollection).snapshots();
}
