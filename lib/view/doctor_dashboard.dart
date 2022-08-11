import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:provider/provider.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorDashboard';

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
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
      ),
      body: ListView.builder(
        itemCount: _sensorDataProvider.getValueFromDB.length,
        itemBuilder: (context, index) {
          final sensorValue = _sensorDataProvider.getValueFromDB[index];
          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(10),
            color: Colors.lightGreen,
            child: Column(
              children: [
                Text('User: ${sensorValue.id!}'),
                Text('Heart-rate: ${sensorValue.bpm!}'),
                Text('Oxygen-level: ${sensorValue.spo2!}'),
                Text('Body-temp: ${sensorValue.tempC!}'),
              ],
            ),
          );
          // return Row(
          //   children: [
          //     Column(
          //       children: [
          //         Text(sensorValue.id!),
          //         Text(sensorValue.bpm!),
          //         Text(sensorValue.spo2!),
          //         Text(sensorValue.tempC!),
          //       ],
          //     )
          //   ],
          // );
          // return ListTile(
          //   title: Text(sensorValue.bpm!),
          //   subtitle: Text(sensorValue.spo2!),
          //   trailing: Text(sensorValue.tempC!),
          // );
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
              onTap: _doctorSignOut,
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }

  void _doctorSignOut() {
    AuthService.signOut().then((_) {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeNames);
    });
  }
}
