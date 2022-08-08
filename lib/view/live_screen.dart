import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/controller/load_data.dart';
import 'package:health_monitoring_app/model/sensor_data.dart';
import 'package:health_monitoring_app/view/dash_screen.dart';
import 'package:health_monitoring_app/view/not_found.dart';
import 'package:health_monitoring_app/view/send_database.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);
  static const String routeNames = '/LiveScreen';

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final StreamController<SensorData> _streamController = StreamController();
  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getSensorData();
    });
  }

  Future<void> getSensorData() async {
    _streamController.sink.add(await LoadData().loadSensorData());
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
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        margin: const EdgeInsets.only(top: 60.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/live.png',
                    height: 60,
                  ),
                  Text(
                    'DATA',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
              const SizedBox(
                height: 00,
              ),
              Expanded(
                child: GridView.count(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/heart-beat.png',
                            height: 60,
                          ),
                          Text(
                            'Heart-beat',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Text(
                            '${sensorData.bpm}',
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/oxygen.png',
                            height: 60,
                          ),
                          Text(
                            'Oxygen Level',
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
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/thermometer.png',
                            height: 60,
                          ),
                          Text(
                            'Body TempC',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Text(
                            '${sensorData.bodyTempC}°c',
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/room-temperature.png',
                            height: 60,
                          ),
                          Text(
                            'Room TempC',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Text(
                            '${sensorData.roomTempC}°c',
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, SendDatabase.routeNames);
                    },
                    child: const Text('Send to Database'),
                  ),
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
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
