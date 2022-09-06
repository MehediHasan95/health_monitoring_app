import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/view/doctor_advice.dart';
import 'package:health_monitoring_app/view/doctor_list.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/provider/doctor_provider.dart';
import 'package:health_monitoring_app/view/about_screen.dart';
import 'package:health_monitoring_app/view/barcode_generator.dart';
import 'package:health_monitoring_app/view/health_tips_screen.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/user_data_list.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({Key? key}) : super(key: key);
  static const String routeNames = '/DashScreen';

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  late DoctorProvider _doctorProvider;

  final userInfo = AuthService.currentUser;
  final uid = AuthService.currentUser?.uid;
  // ignore: prefer_typing_uninitialized_variables
  var dayCount;
  // ignore: prefer_typing_uninitialized_variables
  var myAge;
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
    _doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    _doctorProvider.getAllDoctorData();
    getUsersDataList();
    getUserProfileInfo();
    getAverageValue();
    getDateDifference();
    super.didChangeDependencies();
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
              Row(
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
                                        style: TextStyle(color: Colors.white)),
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
                                    percent: averageSpo2 / 110,
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
                                        style: TextStyle(color: Colors.white)),
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
                                    percent: averageTempC / 50,
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
                                        style: TextStyle(color: Colors.white)),
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
                                    percent: averageTempF / 122,
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
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: isVisible,
                            child: Container(
                                color: Colors.white24,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Text(
                                    healthConditionMsg,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          const Text('VALUE',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          AvatarGlow(
                            endRadius: 50,
                            glowColor: Colors.lightGreen,
                            child: Text('$dayCount',
                                style: const TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightGreen)),
                          ),
                          const Text('AFTER',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          const Text('DAYS',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              // Second part
              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Daily Activity Reports',
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Divider(
                            color: Colors.white,
                          ),
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
                      gender == "Male"
                          ? Image.asset('assets/man.png', height: 80)
                          : Image.asset('assets/woman.png', height: 80),
                      Text(
                        username!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        gender!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Text(
                      //   'Age: $myAge',
                      //   style: const TextStyle(color: Colors.white),
                      // ),
                    ],
                  )),
              ListTile(
                onTap: (() {
                  Navigator.pushReplacementNamed(
                      context, LiveScreen.routeNames);
                }),
                leading: const Icon(Icons.sensors),
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
                onTap: () {
                  Navigator.popAndPushNamed(context, DoctorList.routeNames);
                },
                leading: const Icon(Icons.health_and_safety),
                title: const Text('Doctor List'),
              ),
              ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(context, DoctorAdvice.routeNames);
                },
                leading: const Icon(Icons.message),
                title: const Text('Doctor Advice'),
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
      Navigator.of(context).pushNamedAndRemoveUntil(
          WelcomeScreen.routeNames, (Route<dynamic> route) => false);
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

  String? username = '';
  String? gender = '';
  DateTime? age;
  Future getUserProfileInfo() async {
    final uid = AuthService.currentUser?.uid;
    await DatabaseHelper.db.collection('userProfileInfo').doc(uid).get().then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
        gender = querySnapshot.data()!['gender'];
        age = querySnapshot.data()!['birthday'].toDate();
      },
    );
    final today = DateTime.now();
    double diffAge = today.difference(age!).inDays / 365;
    myAge = diffAge.round();
    setState(() {
      username;
      gender;
      age;
    });
  }

// Calculate average value
  String healthConditionMsg = '';
  Future getAverageValue() async {
    await DatabaseHelper.db.collection('sensorData/$uid/userData').get().then(
      (querySnapshot) {
        int totalElements = querySnapshot.docs.length;
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
          if (averageBpm.round() >= 180 &&
              averageSpo2.round() >= 100 &&
              averageTempC.round() >= 38) {
            healthConditionMsg = 'You need to go hospital';
          } else if ((averageBpm.round() >= 60 && averageBpm.round() <= 100) &&
              (averageSpo2.round() >= 95 && averageSpo2.round() <= 100) &&
              (averageTempC.round() >= 36 && averageTempC.round() <= 37)) {
            healthConditionMsg = 'Health Condition is Normal';
          } else if (averageBpm.round() < 60 &&
              averageSpo2.round() < 88 &&
              averageTempC.round() < 35) {
            healthConditionMsg = "You need to go hospital";
          } else {
            healthConditionMsg = 'Health Condition is Average';
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

  // Difference between days
  void getDateDifference() {
    final accountCreateDate = userInfo?.metadata.creationTime;
    DateFormat('yyyy-MM-dd').format(accountCreateDate!);
    final today = DateTime.now();
    dayCount = today.difference(accountCreateDate).inDays;
  }
}
