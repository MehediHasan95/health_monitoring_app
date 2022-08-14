import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class DatabaseHelper {
  static const _sensorDataCollection = 'sensorData';
  static const _doctorCollection = 'doctors';
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // static Future<void> addSensorData(SensorDataModel sensorDataModel) {
  //   final writeBatch = _db.batch();
  //   final sensorDoc = _db.collection(_sensorDataCollection).doc();
  //   sensorDataModel.id = sensorDoc.id;
  //   writeBatch.set(sensorDoc, sensorDataModel.toMap());
  //   return writeBatch.commit();
  // }

  static Future<void> addSensorData(SensorDataModel sensorDataModel) {
    final uid = AuthService.currentUser?.uid;
    return db
        .collection(_sensorDataCollection)
        .doc(uid)
        .collection('userData')
        .add(sensorDataModel.toJson());
  }

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
