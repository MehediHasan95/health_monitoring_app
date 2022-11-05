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
import 'package:slide_countdown/slide_countdown.dart';

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
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showExitWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
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
      ),
    );
  }

// ignore: non_constant_identifier_names
  Widget DisplayDataWidget(SensorData sensorData) {
    bool isButtonActive;
    bool isFingerTop;
    final isBpmTrue = sensorData.bpm;
    final isSpO2True = sensorData.spo2;

    if (isBpmTrue! >= 42.0 && isSpO2True! >= 88) {
      isButtonActive = true;
      isFingerTop = false;
    } else {
      isButtonActive = false;
      isFingerTop = true;
    }

    // Heart health condition check
    String heartHealthMsg = "";
    if (sensorData.bpm! > 180 && sensorData.spo2! > 100) {
      heartHealthMsg = " High";
    } else if (sensorData.bpm! >= 60 &&
        sensorData.bpm! <= 100 &&
        sensorData.avgSpo2! >= 95 &&
        sensorData.spo2! <= 100) {
      heartHealthMsg = " Normal";
    } else if (sensorData.bpm! < 60 &&
        sensorData.bpm! > 42 &&
        sensorData.spo2! < 95 &&
        sensorData.spo2! > 88) {
      heartHealthMsg = " Low";
    } else if ((sensorData.bpm! < 42 &&
        sensorData.bpm! > 10 &&
        sensorData.spo2! < 88 &&
        sensorData.spo2! > 10)) {
      heartHealthMsg = " Extreme low";
    }

    // body temperature health condition check
    String tempHealthMsg = "";
    if (sensorData.bodyTempC! > 39.1) {
      tempHealthMsg = "High fever";
    } else if (sensorData.bodyTempC! > 37.8 && sensorData.bodyTempC! < 39.0) {
      tempHealthMsg = "Light fever";
    } else if (sensorData.bodyTempC! >= 35.9 && sensorData.bodyTempC! <= 37.5) {
      tempHealthMsg = "Normal";
    } else if (sensorData.bodyTempC! >= 36.2 && sensorData.bodyTempC! <= 35.8) {
      tempHealthMsg = "Low";
    } else if ((sensorData.bodyTempC! < 35.0 &&
        sensorData.bodyTempC! >= 30.0)) {
      tempHealthMsg = "Extreme low";
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
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              'Hello, $username',
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                              speed: const Duration(milliseconds: 250),
                            ),
                          ],
                          totalRepeatCount: 1,
                        ),
                        Text(
                          welcomeMsg,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 30,
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Heart: ",
                              style: TextStyle(color: Colors.white)),
                          Text(heartHealthMsg == '' ? '?' : heartHealthMsg,
                              style:
                                  const TextStyle(color: Colors.amberAccent)),
                          const Text(" || ",
                              style: TextStyle(color: Colors.white)),
                          const Text("Temp: ",
                              style: TextStyle(color: Colors.white)),
                          Text(tempHealthMsg == '' ? '?' : tempHealthMsg,
                              style: const TextStyle(color: Colors.amberAccent))
                        ],
                      ),
                    ],
                  ),
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
                          Provider.of<SensorDataProvider>(context,
                                  listen: false)
                              .saveSensorData(sensorDataModel)
                              .then((value) {
                            setState(() {
                              isButtonActive == false;
                            });
                            showConfirmAlert(context);
                          }).catchError((error) {
                            showFlushBar(context, error);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(25),
                        ),
                        child: const SlideCountdown(
                            duration: Duration(seconds: 20),
                            replacement: Text('SAVE'),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.zero,
                                color: Colors.pink))),
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
                        backgroundColor: Colors.pink.shade200,
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
}
