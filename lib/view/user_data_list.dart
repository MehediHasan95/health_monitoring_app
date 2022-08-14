import 'package:flutter/material.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:intl/intl.dart';

class UserDataList extends StatelessWidget {
  final SensorDataModel _sensorDataModel;

  // ignore: use_key_in_widget_constructors
  const UserDataList(this._sensorDataModel);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date & Time:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  DateFormat('dd/MM/yyyy, hh:mm a')
                      .format(_sensorDataModel.timestamp!)
                      .toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Heart-rate:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  '${_sensorDataModel.bpm}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Icon(Icons.favorite),
                const Text(
                  'Oxygen-level:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  '${_sensorDataModel.spo2}%',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Icon(Icons.favorite),
                const Text(
                  'Temperature:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  '${_sensorDataModel.tempC}°C',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
