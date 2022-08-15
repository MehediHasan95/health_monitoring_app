import 'package:flutter/material.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:intl/intl.dart';

class UserDataList extends StatelessWidget {
  final SensorDataModel _sensorDataModel;

  // ignore: use_key_in_widget_constructors
  const UserDataList(this._sensorDataModel);

  @override
  Widget build(BuildContext context) {
    // final myNumber = double.parse(_sensorDataModel.bpm!) +
    //     double.parse(_sensorDataModel.bpm!) +
    // print(myNumber);

    // List<String?> sum = [];
    // sum.add(_sensorDataModel.bpm);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.alarm,
                    color: Colors.black87,
                  ),
                  const Text(
                    '',
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy, hh:mm a')
                        .format(_sensorDataModel.timestamp!)
                        .toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.black87),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.black87,
                  ),
                  // const Text(
                  //   'Heart-rate:',
                  //   style: TextStyle(fontSize: 20, color: Colors.black87),
                  // ),
                  Text(
                    '${_sensorDataModel.bpm}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.water_drop,
                    color: Colors.black87,
                  ),
                  // const Text(
                  //   'Oxygen-level:',
                  //   style: TextStyle(fontSize: 20, color: Colors.black87),
                  // ),
                  Text(
                    '${_sensorDataModel.spo2}%',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.thermostat,
                    color: Colors.black87,
                  ),
                  // const Text(
                  //   'Temperature:',
                  //   style: TextStyle(fontSize: 20, color: Colors.black87),
                  // ),
                  Text(
                    '${_sensorDataModel.tempC}°C',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
