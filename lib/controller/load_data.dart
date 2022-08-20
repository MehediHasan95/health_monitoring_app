import 'dart:convert' show json;
import 'package:health_monitoring_app/model/sensor_data.dart';
import 'package:http/http.dart' as http;

class LoadData {
  Future<SensorData> loadSensorData() async {
    final url = Uri.parse('http://192.168.0.103/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final databody = json.decode(response.body).first;
        SensorData sensorData = SensorData.fromJson(databody);
        return sensorData;
      }
    } catch (error) {
      rethrow;
    }
    // ignore: null_check_always_fails
    return null!;
  }
}
