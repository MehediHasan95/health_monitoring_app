import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'After [$dayCount] days your average value',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/heart-beat.png',
                    height: 50,
                  ),
                  Text(
                    'Heart-rate',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
                  Text(
                    '${averageBpm.toStringAsFixed(2)}bpm',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/oxygen.png',
                    height: 50,
                  ),
                  Text(
                    'Oxygen',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
                  Text(
                    '${averageSpo2.toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/celsius.png',
                    height: 50,
                  ),
                  Text(
                    'Celsius',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
                  Text(
                    '${averageTempC.toStringAsFixed(2)}°C',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/fahrenheit.png',
                    height: 50,
                  ),
                  Text(
                    'Fahrenheit',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
                  Text(
                    '${averageTempF.toStringAsFixed(2)}°F',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                )),
                Text(
                  'Data Sheets',
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                )),
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

      // body: ListView.builder(
      //   scrollDirection: Axis.vertical,
      //   shrinkWrap: true,
      //   itemCount: _dataList.length,
      //   itemBuilder: (context, index) {
      //     // final getValue = _dataList[index] as SensorDataModel;
      //     return UserDataList(_dataList[index] as SensorDataModel);
      //   },
      // ),
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
