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
          border: TableBorder.all(color: Colors.white),
          children: [
            TableRow(
                decoration: BoxDecoration(color: Colors.amberAccent.shade100),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(children: [
                      Text(DateFormat('dd/MM/yy, hh:mm a')
                          .format(_sensorDataModel.timestamp!)
                          .toString())
                    ]),
                  ),
                  Column(children: [Text('${_sensorDataModel.bpm}b')]),
                  Column(children: [Text('${_sensorDataModel.spo2}%')]),
                  Column(children: [Text('${_sensorDataModel.tempC}°C')]),
                  Column(children: [Text('${_sensorDataModel.tempF}°F')]),
                ]),
          ],
        ),
      ),
    ]));
  }
}
