import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/view/about_screen.dart';
import 'package:health_monitoring_app/view/health_tips_screen.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:provider/provider.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({Key? key}) : super(key: key);
  static const String routeNames = '/DashScreen';

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  // int touchedIndex = -1;
  final user = AuthService.currentUser;
  late SensorDataProvider _sensorDataProvider;

  @override
  void didChangeDependencies() {
    _sensorDataProvider = Provider.of<SensorDataProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: _sensorDataProvider.submitDataList.length,
        itemBuilder: (context, index) {
          final sensorValue = _sensorDataProvider.submitDataList[index];
          return ListTile(
            title: Text(sensorValue.bpm!),
            subtitle: Text(sensorValue.spo2!),
            trailing: Text(sensorValue.tempC!),
          );
        },
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
                    '${user?.email}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
            ListTile(
              onTap: (() {
                Navigator.pushReplacementNamed(context, LiveScreen.routeNames);
              }),
              leading: const Icon(Icons.stream),
              title: const Text('Live'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, HealthTipsScreen.routeNames);
              },
              leading: const Icon(Icons.tips_and_updates),
              title: const Text('Health Tips'),
            ),
            ListTile(
              onTap: (() {
                Navigator.pushReplacementNamed(context, AboutScreen.routeNames);
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
}
