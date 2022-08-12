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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Date: ${DateFormat('dd/MM/yyyy, hh:mm a').format(_sensorDataModel.timestamp!).toString()}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Heart-rate: ${_sensorDataModel.bpm}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Text('Oxygen-level: ${_sensorDataModel.spo2}',
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              children: [
                Text('Temperature: ${_sensorDataModel.tempC}',
                    style: const TextStyle(fontSize: 20)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
