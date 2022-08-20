import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/view/about_screen.dart';
import 'package:health_monitoring_app/view/chart.dart';
import 'package:health_monitoring_app/view/doctor_list.dart';
import 'package:health_monitoring_app/view/health_tips_screen.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/user_data_list.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUsersDataList();
    getAverageValue();
    getUserProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Dashboard'),
      ),
      body: Column(
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
                                  progressColor: Colors.red,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.heartPulse,
                                        color: Colors.redAccent,
                                      ),
                                      Text(averageBpm.toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800)),
                                      Text('BPM',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800))
                                    ],
                                  ),
                                  footer: Text('Heart-rate',
                                      style: TextStyle(
                                          color: Colors.grey.shade800)),
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
                                  progressColor: Colors.orange,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.droplet,
                                        color: Colors.orange,
                                      ),
                                      Text(averageSpo2.toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800)),
                                      Text('%',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800))
                                    ],
                                  ),
                                  footer: Text('Oxygen',
                                      style: TextStyle(
                                          color: Colors.grey.shade800)),
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
                                  progressColor: Colors.blue,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.temperatureFull,
                                        color: Colors.blue,
                                      ),
                                      Text(averageTempC.toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800)),
                                      Text('°C',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800))
                                    ],
                                  ),
                                  footer: Text('Celsius',
                                      style: TextStyle(
                                          color: Colors.grey.shade800)),
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
                                  progressColor: Colors.green,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.temperatureHalf,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        averageTempF.toStringAsFixed(2),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800),
                                      ),
                                      Text('°F',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800))
                                    ],
                                  ),
                                  footer: Text('Fahrenheit',
                                      style: TextStyle(
                                          color: Colors.grey.shade800)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        const Text('AVERAGE', style: TextStyle(fontSize: 20)),
                        const Text('VALUE', style: TextStyle(fontSize: 20)),
                        AvatarGlow(
                          endRadius: 50,
                          glowColor: Colors.green,
                          child: Text('${dayCount ?? 00}',
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink.shade800)),
                        ),
                        const Text('AFTER', style: TextStyle(fontSize: 20)),
                        const Text('DAYS', style: TextStyle(fontSize: 20)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          // Second part
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Text(
                  'Daily activity report:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                          decoration:
                              const BoxDecoration(color: Colors.amberAccent),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Date & Time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800))
                                  ]),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('HR',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('OL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('BTC',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'BTF',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800),
                                  ),
                                ]),
                          ]),
                    ],
                  ),
                ),
              ],
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  // image: const DecorationImage(
                  //   image: AssetImage("assets/heart-beat.png"),
                  // )
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      gender,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${userInfo?.email}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ))),
            ListTile(
              onTap: (() {
                Navigator.pushReplacementNamed(context, LiveScreen.routeNames);
              }),
              leading: const Icon(Icons.online_prediction),
              title: const Text('Live'),
            ),
            ListTile(
              onTap: () {
                Navigator.popAndPushNamed(context, HealthTipsScreen.routeNames);
              },
              leading: const Icon(Icons.tips_and_updates),
              title: const Text('Health Tips'),
            ),
            ListTile(
              onTap: () {
                Navigator.popAndPushNamed(context, DoctorList.routeNames);
              },
              leading: const Icon(Icons.local_hospital),
              title: const Text('Doctor List'),
            ),
            ListTile(
              onTap: (() {
                Navigator.popAndPushNamed(context, AboutScreen.routeNames);
              }),
              leading: const Icon(Icons.attribution),
              title: const Text('About us'),
            ),
            ListTile(
              onTap: (() {
                Navigator.popAndPushNamed(context, Chart.routeNames);
              }),
              leading: const Icon(Icons.chat_rounded),
              title: const Text('Chart'),
            ),
            ListTile(
              onTap: _signOut,
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
            ),
          ],
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
  Future getAverageValue() async {
    await DatabaseHelper.db.collection('sensorData/$uid/userData').get().then(
      (querySnapshot) {
        int totalElements = querySnapshot.docs.length;
        dayCount = totalElements;
        for (var elements in querySnapshot.docs) {
          totalBpm = totalBpm + double.parse(elements.data()['bpm']);
          averageBpm = totalBpm / totalElements;
        }
        for (var elements in querySnapshot.docs) {
          totalSpo2 = totalSpo2 + double.parse(elements.data()['spo2']);
          averageSpo2 = totalSpo2 / totalElements;
        }
        for (var elements in querySnapshot.docs) {
          totalTempC = totalTempC + double.parse(elements.data()['tempC']);
          averageTempC = totalTempC / totalElements;
        }
        for (var elements in querySnapshot.docs) {
          totaltempF = totaltempF + double.parse(elements.data()['tempF']);
          averageTempF = totaltempF / totalElements;
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
}
