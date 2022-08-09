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
          const Text('SignOut'),
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
                decoration: BoxDecoration(color: Colors.blue.shade900),
                child: const Center(
                  child: Text(
                    'Health Corner',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                )),
            const ListTile(
              leading: Icon(Icons.tips_and_updates),
              title: Text('Tips'),
            ),
            const ListTile(
              leading: Icon(Icons.attribution),
              title: Text('About'),
            ),
            const ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact'),
            )
          ],
        ),
      ),
    );
  }
}
