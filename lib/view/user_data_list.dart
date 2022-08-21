import 'package:flutter/material.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:intl/intl.dart';

class UserDataList extends StatelessWidget {
  final SensorDataModel _sensorDataModel;
  // ignore: use_key_in_widget_constructors
  const UserDataList(this._sensorDataModel);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(0.36),
            1: FlexColumnWidth(0.16),
            2: FlexColumnWidth(0.16),
            3: FlexColumnWidth(0.16),
            4: FlexColumnWidth(0.16),
          },
          border: TableBorder.all(width: 0, color: Colors.white),
          children: [
            TableRow(
                decoration: BoxDecoration(color: Colors.pink.shade200),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(children: [
                      Text(
                          DateFormat('dd/MM/yy, hh:mm a')
                              .format(_sensorDataModel.timestamp!)
                              .toString(),
                          style: const TextStyle(color: Colors.white))
                    ]),
                  ),
                  Column(children: [
                    Text('${_sensorDataModel.bpm}b',
                        style: const TextStyle(color: Colors.white))
                  ]),
                  Column(children: [
                    Text('${_sensorDataModel.spo2}%',
                        style: const TextStyle(color: Colors.white))
                  ]),
                  Column(children: [
                    Text('${_sensorDataModel.tempC}°C',
                        style: const TextStyle(color: Colors.white))
                  ]),
                  Column(children: [
                    Text('${_sensorDataModel.tempF}°F',
                        style: const TextStyle(color: Colors.white))
                  ]),
                ]),
          ],
        ),
      ),
    ]));
  }
}
