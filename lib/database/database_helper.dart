import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class DatabaseHelper {
  static const _sensorDataCollection = 'sensorData';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addSensorData(SensorDataModel sensorDataModel) {
    final writeBatch = _db.batch();
    final sensorDoc = _db.collection(_sensorDataCollection).doc();
    sensorDataModel.id = sensorDoc.id;
    writeBatch.set(sensorDoc, sensorDataModel.toMap());
    return writeBatch.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllSensorData() =>
      _db.collection(_sensorDataCollection).snapshots();
}
