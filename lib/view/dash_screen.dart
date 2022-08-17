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
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:intl/intl.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({Key? key}) : super(key: key);
  static const String routeNames = '/DashScreen';

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  final userInfo = AuthService.currentUser;
  final uid = AuthService.currentUser?.uid;
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
          Text(averageBpm.toStringAsFixed(2),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(averageSpo2.toStringAsFixed(2),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _dataList.length,
            itemBuilder: (context, index) {
              final getValue = _dataList[index] as SensorDataModel;
              // return UserDataList(_dataList[index] as SensorDataModel);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.blue.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 30),
                        child: Row(
                          children: [
                            // Icon(Icons.alarm),
                            const FaIcon(FontAwesomeIcons.clock,
                                color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat('dd/MM/yyyy, hh:mm a')
                                  .format(getValue.timestamp!)
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              // Icon(Icons.favorite),
                              const FaIcon(FontAwesomeIcons.heartPulse,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(getValue.bpm!,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          Row(
                            children: [
                              // Icon(Icons.water_drop),
                              const FaIcon(FontAwesomeIcons.droplet,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text('${getValue.spo2!}%',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              // Icon(Icons.thermostat),
                              const FaIcon(FontAwesomeIcons.temperatureFull,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text('${getValue.tempC}°C',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          Row(
                            children: [
                              // Icon(Icons.thermostat),
                              const FaIcon(FontAwesomeIcons.temperatureFull,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text('${getValue.tempF}°F',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
                  child: Text(
                    '${userInfo?.email}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
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
              leading: const Icon(Icons.attribution),
              title: const Text('Pie Chart'),
            ),
            ListTile(
              onTap: _signOut,
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
            ),
            ListTile(
              onTap: getAverageValue,
              leading: const Icon(Icons.local_activity),
              title: const Text('Get Sum'),
            ),
          ],
        ),
      ),
    );
  }

  void _signOut() {
    AuthService.signOut().then((_) {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeNames);
    });
  }

  //user data
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

  Future getAverageValue() async {
    await DatabaseHelper.db.collection('sensorData/$uid/userData').get().then(
      (querySnapshot) {
        for (var result in querySnapshot.docs) {
          totalBpm = totalBpm + double.parse(result.data()['bpm']);
          averageBpm = totalBpm / 5;
        }
        for (var result in querySnapshot.docs) {
          totalSpo2 = totalSpo2 + double.parse(result.data()['spo2']);
          averageSpo2 = totalSpo2 / 5;
        }
        for (var result in querySnapshot.docs) {
          totalTempC = totalTempC + double.parse(result.data()['tempC']);
          averageTempC = totalTempC / 5;
        }
        for (var result in querySnapshot.docs) {
          totaltempF = totaltempF + double.parse(result.data()['tempF']);
          averageTempF = totaltempF / 5;
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
