import 'dart:async' show StreamController, Timer;
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/controller/load_data.dart';
import 'package:health_monitoring_app/model/sensor_data.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/dash_screen.dart';
import 'package:health_monitoring_app/view/not_found.dart';
import 'package:provider/provider.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);
  static const String routeNames = '/LiveScreen';

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final StreamController<SensorData> _streamController = StreamController();

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 250), (timer) async {
      _streamController.sink.add(await LoadData().loadSensorData());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<SensorData>(
          stream: _streamController.stream,
          builder: (context, snapdata) {
            switch (snapdata.connectionState) {
              case ConnectionState.waiting:
                return const NotFound();
              default:
                if (snapdata.hasError) {
                  return const Center(
                      child: Text(
                    'Something went wrong!',
                    style: TextStyle(color: Colors.redAccent),
                  ));
                } else {
                  return DisplayDataWidget(snapdata.data!);
                }
            }
          },
        ),
      ),
    );
  }

// ignore: non_constant_identifier_names
  Widget DisplayDataWidget(SensorData sensorData) {
    bool isButtonActive = false;
    final isBpmTrue = sensorData.bpm;
    final isSpO2True = sensorData.spo2;

    if (isBpmTrue! > 65.0 || isSpO2True! > 80) {
      isButtonActive = true;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/live.png',
                    height: 60,
                  ),
                  Text(
                    '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    Card(
                      color: Colors.white70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/heart-beat.png',
                            height: 60,
                          ),
                          Text(
                            'Heart Rate',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${sensorData.bpm}',
                                    style: TextStyle(
                                        fontSize: 38,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: const [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'BPM',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            'Avgerage: ${sensorData.avgBpm} BPM',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/oxygen.png',
                            height: 60,
                          ),
                          Text(
                            'Oxygen Saturation',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Text(
                            '${sensorData.spo2}%',
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Avgerage: ${sensorData.avgSpo2}%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/celsius.png',
                            height: 60,
                          ),
                          Text(
                            'Celsius',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Text(
                            '${sensorData.bodyTempC}°C',
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Avgerage: ${sensorData.avgBodyTempC}°C',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.white70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/fahrenheit.png',
                            height: 60,
                          ),
                          Text(
                            'Fahrenheit',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Text(
                            '${sensorData.bodyTempF}°F',
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Avgerage: ${sensorData.avgBodyTempF}°F',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isButtonActive == true
                    ? () {
                        final sensorDataModel = SensorDataModel(
                          bpm: sensorData.bpm.toString(),
                          spo2: sensorData.spo2.toString(),
                          tempC: sensorData.bodyTempC.toString(),
                          timestamp: DateTime.now(),
                        );
                        Provider.of<SensorDataProvider>(context, listen: false)
                            .saveSensorData(sensorDataModel)
                            .then((value) {
                          setState(() {
                            isButtonActive == false;
                          });
                          showFlushBar(context, "Succufully");
                        }).catchError((error) {
                          showFlushBar(context, error);
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(30),
                ),
                child: const Icon(Icons.done_all),
              ),
              const SizedBox(height: 50),
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(25.0),
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, DashScreen.routeNames);
                    },
                    child: const Text('Dashboard'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _saveSensorDataToDatabase() {
  //   if (_formKey.currentState!.validate()) {
  //     final sensorDataModel = SensorDataModel(
  //       bpm: _bpmController.text,
  //       spo2: _spo2Controller.text,
  //       tempC: _tempCController.text,
  //       timestamp: DateTime.now(),
  //     );
  //     Provider.of<SensorDataProvider>(context, listen: false)
  //         .saveSensorData(sensorDataModel)
  //         .then((value) {
  //       setState(() {
  //         _bpmController.clear();
  //         _spo2Controller.clear();
  //         _tempCController.clear();
  //       });
  //       showMsg(context, 'SUBMITTED SUCCESSFULLY');
  //     }).catchError((error) {
  //       showMsg(context, error);
  //     });
  //   }
  // }

}
