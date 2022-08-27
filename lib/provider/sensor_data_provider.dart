import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';

class SensorDataProvider extends ChangeNotifier {
  Future<void> saveSensorData(SensorDataModel sensorDataModel) {
    return DatabaseHelper.addSensorData(sensorDataModel);
  }
}
