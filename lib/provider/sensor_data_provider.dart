import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class SensorDataProvider extends ChangeNotifier {
  // List<SensorDataModel> getValueFromDB = [];

  Future<void> saveSensorData(SensorDataModel sensorDataModel) {
    return DatabaseHelper.addSensorData(sensorDataModel);
  }

  // void getAllSensorData() {
  //   DatabaseHelper.fetchAllDoctorData().listen((event) {
  //     getValueFromDB = List.generate(event.docs.length,
  //         (index) => SensorDataModel.fromMap(event.docs[index].data()));
  //     notifyListeners();
  //   });
  // }
}
