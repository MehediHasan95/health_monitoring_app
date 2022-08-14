import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/view/about_screen.dart';
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
  final user = AuthService.currentUser;

  // late SensorDataProvider _sensorDataProvider;
  // @override
  // void didChangeDependencies() {
  //   getUsersDataList();
  //   _sensorDataProvider = Provider.of<SensorDataProvider>(context);
  //   super.didChangeDependencies();
  // }

  List<Object> _dataList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUsersDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          return UserDataList(_dataList[index] as SensorDataModel);
        },
      ),

      // body: ListView.builder(
      //   itemCount: _sensorDataProvider.getValueFromDB.length,
      //   itemBuilder: (context, index) {
      //     final sensorValue = _sensorDataProvider.getValueFromDB[index];
      //     return ListTile(
      //       title: Text(sensorValue.bpm!),
      //       subtitle: Text(sensorValue.spo2!),
      //       trailing: Text(sensorValue.tempC!),
      //     );
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
                    '${user?.email}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
            ListTile(
              onTap: (() {
                Navigator.popAndPushNamed(context, LiveScreen.routeNames);
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
              onTap: _signOut,
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
            )
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
    final uid = AuthService.currentUser?.uid;
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
}
