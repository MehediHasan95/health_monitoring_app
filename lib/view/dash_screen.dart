import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:provider/provider.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({Key? key}) : super(key: key);
  static const String routeNames = '/DashScreen';

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.signOut().then((_) {
                Navigator.pushReplacementNamed(
                    context, WelcomeScreen.routeNames);
              });
            },
          )
        ],
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
            const ListTile(
              leading: Icon(Icons.stream),
              title: Text('Live'),
            ),
            const ListTile(
              leading: Icon(Icons.tips_and_updates),
              title: Text('Health Tips'),
            ),
            const ListTile(
              leading: Icon(Icons.attribution),
              title: Text('About us'),
            ),
            const ListTile(
              leading: Icon(Icons.contact_support),
              title: Text('Contact us'),
            ),
            const ListTile(
              leading: Icon(Icons.logo_dev),
              title: Text('Developer Info'),
            ),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
