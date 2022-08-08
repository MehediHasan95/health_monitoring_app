import 'dart:convert';
import 'package:health_monitoring_app/model/sensor_data.dart';
import 'package:http/http.dart' as http;

class LoadData {
  Future<SensorData> loadSensorData() async {
    var url = Uri.parse('http://192.168.0.102/');
    final response = await http.get(url);
    final databody = json.decode(response.body).first;
    SensorData sensorData = SensorData.fromJson(databody);
    return sensorData;
  }
}
