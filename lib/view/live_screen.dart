import 'dart:async' show StreamController, Timer;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/controller/load_data.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/dash_screen.dart';
import 'package:health_monitoring_app/view/not_found.dart';
import 'package:lottie/lottie.dart';
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
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      _streamController.sink.add(await LoadData().loadSensorData());
    });
    super.initState();
    getUserProfileInfo();
    greetingMessage();
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
    bool isButtonActive;
    bool isFingerTop;
    final isBpmTrue = sensorData.bpm;
    final isSpO2True = sensorData.spo2;

    if (isBpmTrue! >= 60.0 && isSpO2True! >= 90) {
      isButtonActive = true;
      isFingerTop = false;
      startTimer();
    } else {
      isButtonActive = false;
      isFingerTop = true;
    }

    // Life health condition check
    String heartHealthMsg = "";
    if (sensorData.bpm! > 180 && sensorData.spo2! > 100) {
      heartHealthMsg = "High";
    } else if (sensorData.bpm! >= 60 &&
        sensorData.bpm! <= 100 &&
        sensorData.avgSpo2! >= 95 &&
        sensorData.spo2! <= 100) {
      heartHealthMsg = "Excellent";
    } else if (sensorData.bpm! < 60 &&
        sensorData.bpm! > 42 &&
        sensorData.spo2! < 95 &&
        sensorData.spo2! > 88) {
      heartHealthMsg = "Low";
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          welcomeMsg,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              username,
                              textStyle: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              speed: const Duration(milliseconds: 250),
                            ),
                          ],
                          totalRepeatCount: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 50,
                        child: LottieBuilder.asset('assets/live.json')),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Heart Condition: ${heartHealthMsg == '' ? '?' : heartHealthMsg}",
                      style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold)),
                ),
                Visibility(
                  visible: isFingerTop,
                  child: const Text(
                    "PUT YOUR FINGER ON THE SENSOR",
                    style: TextStyle(color: Colors.amberAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
                Visibility(
                  visible: isButtonActive,
                  child: AvatarGlow(
                    endRadius: 50,
                    glowColor: Colors.white,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        final sensorDataModel = SensorDataModel(
                          bpm: sensorData.bpm.toString(),
                          spo2: sensorData.spo2.toString(),
                          tempC: sensorData.bodyTempC.toString(),
                          tempF: sensorData.bodyTempF.toString(),
                          timestamp: DateTime.now(),
                        );
                        Provider.of<SensorDataProvider>(context, listen: false)
                            .saveSensorData(sensorDataModel)
                            .then((value) {
                          setState(() {
                            isButtonActive == false;
                          });
                          showFlushBar(
                            context,
                            "Your record has been saved successfully",
                          );
                        }).catchError((error) {
                          showFlushBar(context, error);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(25),
                      ),
                      child: const Text("SAVE"),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(25.0),
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink.shade200,
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
      ),
    );
  }

// Show user profile info
  String username = '';
  Future getUserProfileInfo() async {
    final uid = AuthService.currentUser?.uid;
    await DatabaseHelper.db.collection('userProfileInfo').doc(uid).get().then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
      },
    );
    setState(() {
      if (username.isNotEmpty) {
        username;
      }
    });
  }

// Show greeting message
  String welcomeMsg = '';
  void greetingMessage() {
    var hour = DateTime.now().hour;
    if (hour <= 12) {
      welcomeMsg = 'Good Morning';
    } else if ((hour > 12) && (hour <= 16)) {
      welcomeMsg = 'Good Afternoon';
    } else if ((hour > 16) && (hour < 20)) {
      welcomeMsg = 'Good Evening';
    } else {
      welcomeMsg = 'Good Night';
    }
  }

  int timeLeft = 10;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }
}
