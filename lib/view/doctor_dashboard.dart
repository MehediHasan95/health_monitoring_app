import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorDashboard';

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final user = AuthService.currentUser;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Object> _dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          'Doctor Portal',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                // suffixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchFromDB,
                ),
                hintText: 'Search UID',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          PatientDataList()
          // Expanded(
          //   child: Column(
          //     children: [
          //       PatientDataList(),
          //     ],
          //   ),
          //   // child: ListView.builder(
          //   //   scrollDirection: Axis.vertical,
          //   //   shrinkWrap: true,
          //   //   itemCount: _dataList.length,
          //   //   itemBuilder: (context, index) {
          //   //     final getValue = _dataList[index] as SensorDataModel;
          //   //     return ListTile(
          //   //       title: Text(getValue.bpm!),
          //   //       subtitle: Text(getValue.spo2!),
          //   //       trailing: Text(getValue.tempC!),
          //   //     );
          //   //   },
          //   // ),
          // )
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

  void _searchFromDB() async {
    var data = await DatabaseHelper.db
        .collection('sensorData')
        .doc(_searchController.text)
        .collection('userData')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _dataList =
          List.from(data.docs.map((doc) => SensorDataModel.fromSnapshot(doc)));
      _searchController.clear();
    });
  }

  // ignore: non_constant_identifier_names
  Widget PatientDataList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _dataList.length,
      itemBuilder: (context, index) {
        final getValue = _dataList[index] as SensorDataModel;
        return ListTile(
          title: Text(getValue.bpm!),
          subtitle: Text(getValue.spo2!),
          trailing: Text(getValue.tempC!),
        );
      },
    );
  }
}
