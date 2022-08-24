import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/view/about_screen.dart';
import 'package:health_monitoring_app/view/barcode_generator.dart';
import 'package:health_monitoring_app/view/health_tips_screen.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/user_data_list.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({Key? key}) : super(key: key);
  static const String routeNames = '/DashScreen';

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  final userInfo = AuthService.currentUser;
  final uid = AuthService.currentUser?.uid;
  // ignore: prefer_typing_uninitialized_variables
  var dayCount;
  double totalBpm = 0;
  double totalSpo2 = 0;
  double totalTempC = 0;
  double totaltempF = 0;
  double averageBpm = 0;
  double averageSpo2 = 0;
  double averageTempC = 0;
  double averageTempF = 0;
  List<Object> _dataList = [];
  bool isVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUsersDataList();
    getAverageValue();
    getUserProfileInfo();
    getDateDifference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Dashboard'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Tooltip(
                                  message: "Heart rate",
                                  showDuration: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      radius: 55,
                                      lineWidth: 15,
                                      percent: averageBpm / 180,
                                      progressColor: Colors.pink,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.heartPulse,
                                            color: Colors.pink,
                                          ),
                                          Text(averageBpm.toStringAsFixed(2),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          const Text('BPM',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ],
                                      ),
                                      footer: const Text('Heart-rate',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                Tooltip(
                                  message: "Oxygen Level",
                                  showDuration: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      radius: 55,
                                      lineWidth: 15,
                                      percent: averageSpo2 / 120,
                                      progressColor: Colors.deepPurple,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.droplet,
                                            color: Colors.deepPurple,
                                          ),
                                          Text(averageSpo2.toStringAsFixed(2),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          const Text('%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ],
                                      ),
                                      footer: const Text('Oxygen',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // part - 2
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Tooltip(
                                  message: "Body temperature Celcius",
                                  showDuration: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      radius: 55,
                                      lineWidth: 15,
                                      percent: averageTempC / 100,
                                      progressColor: Colors.deepOrange,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.temperatureFull,
                                            color: Colors.deepOrange,
                                          ),
                                          Text(averageTempC.toStringAsFixed(2),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          const Text('°C',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ],
                                      ),
                                      footer: const Text('Celsius',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                Tooltip(
                                  message: "Body temperature Fahrenheit",
                                  showDuration: const Duration(seconds: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularPercentIndicator(
                                      animation: true,
                                      animationDuration: 1000,
                                      radius: 55,
                                      lineWidth: 15,
                                      percent: averageTempF / 200,
                                      progressColor: Colors.cyan.shade900,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.temperatureHalf,
                                            color: Colors.cyan.shade900,
                                          ),
                                          Text(
                                            averageTempF.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          const Text('°F',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ],
                                      ),
                                      footer: const Text('Fahrenheit',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: isVisible,
                              child: Container(
                                  color: Colors.white24,
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      healthConditionMsg,
                                      style: GoogleFonts.signikaNegative(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellowAccent,
                                      ),
                                      // style: const TextStyle(
                                      //   fontWeight: FontWeight.bold,
                                      //   color: Colors.white,
                                      // ),

                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            const Text('AVERAGE',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            const Text('VALUE',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            AvatarGlow(
                              endRadius: 50,
                              glowColor: Colors.yellowAccent,
                              child: Text('${dayCount ?? 00}',
                                  style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellowAccent)),
                            ),
                            const Text('AFTER',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            const Text('DAYS',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // Second part
              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Row(
                    children: const [
                      Text(
                        'Daily activity report:',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(0.36),
                            1: FlexColumnWidth(0.16),
                            2: FlexColumnWidth(0.16),
                            3: FlexColumnWidth(0.16),
                            4: FlexColumnWidth(0.16),
                          },
                          border:
                              TableBorder.all(width: 0, color: Colors.white),
                          children: [
                            TableRow(
                                decoration:
                                    const BoxDecoration(color: Colors.pink),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text('Date & Time',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ]),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('HR',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('OL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('BTC',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'BTF',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    // final getValue = _dataList[index] as SensorDataModel;
                    return UserDataList(_dataList[index] as SensorDataModel);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade900,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Gender: $gender",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Email: ${userInfo?.email}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                    ],
                  )),
              ListTile(
                onTap: (() {
                  Navigator.pushReplacementNamed(
                      context, LiveScreen.routeNames);
                }),
                leading: const Icon(Icons.online_prediction),
                title: const Text('Live'),
              ),
              ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(
                      context, HealthTipsScreen.routeNames);
                },
                leading: const Icon(Icons.tips_and_updates),
                title: const Text('Health Tips'),
              ),
              ListTile(
                onTap: (() {
                  Navigator.popAndPushNamed(
                      context, BarcodeGenerate.routeNames);
                }),
                leading: const Icon(Icons.qr_code),
                title: const Text('QR Code'),
              ),
              ListTile(
                onTap: (() {
                  Navigator.popAndPushNamed(context, AboutScreen.routeNames);
                }),
                leading: const Icon(Icons.attribution),
                title: const Text('About'),
              ),
              ListTile(
                onTap: _signOut,
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

// SignOut method
  void _signOut() {
    AuthService.signOut().then((_) {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeNames);
    });
  }

  //Get User Data List
  Future getUsersDataList() async {
    var data = await DatabaseHelper.db
        .collection('sensorData')
        .doc(uid)
        .collection('userData')
        .orderBy('timestamp', descending: true)
        .get();

    if (data.docs.isNotEmpty) {
      isVisible = true;
    }

    setState(() {
      _dataList =
          List.from(data.docs.map((doc) => SensorDataModel.fromSnapshot(doc)));
    });
  }

  String username = '';
  String gender = '';
  Future getUserProfileInfo() async {
    final uid = AuthService.currentUser?.uid;
    await DatabaseHelper.db.collection('userProfileInfo').doc(uid).get().then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
        gender = querySnapshot.data()!['gender'];
      },
    );
    setState(() {
      username;
      gender;
    });
  }

// Calculate average value
  String healthConditionMsg = '';
  Future getAverageValue() async {
    await DatabaseHelper.db.collection('sensorData/$uid/userData').get().then(
      (querySnapshot) {
        int totalElements = querySnapshot.docs.length;
        // dayCount = totalElements;
        for (var elements in querySnapshot.docs) {
          totalBpm = totalBpm + double.parse(elements.data()['bpm']);
          totalSpo2 = totalSpo2 + double.parse(elements.data()['spo2']);
          totalTempC = totalTempC + double.parse(elements.data()['tempC']);
          totaltempF = totaltempF + double.parse(elements.data()['tempF']);
          averageBpm = totalBpm / totalElements;
          averageSpo2 = totalSpo2 / totalElements;
          averageTempC = totalTempC / totalElements;
          averageTempF = totaltempF / totalElements;

          // Checking health condition
          if (averageBpm.round() > 120 &&
              averageSpo2.round() > 110 &&
              averageTempC.round() > 40) {
            healthConditionMsg = 'Very High';
          } else if ((averageBpm.round() > 55 && averageBpm.round() < 100) &&
              (averageSpo2.round() > 90 && averageSpo2.round() < 100) &&
              (averageTempC.round() > 35 && averageTempC.round() < 45)) {
            healthConditionMsg = 'Excellent';
          } else if (averageBpm.round() < 55 &&
              averageSpo2.round() < 90 &&
              averageTempC.round() < 30) {
            healthConditionMsg = "Very Low";
          } else {
            healthConditionMsg = 'Normal';
          }
        }
        setState(() {
          averageBpm;
          averageSpo2;
          averageTempC;
          averageTempF;
        });
      },
    );
  }

  // Difference between two days
  void getDateDifference() {
    final accountCreateDate = userInfo?.metadata.creationTime;
    DateFormat('yyyy-MM-dd').format(accountCreateDate!);
    final today = DateTime.now();
    dayCount = today.difference(accountCreateDate).inDays;
  }
}
