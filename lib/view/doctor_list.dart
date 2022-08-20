import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/provider/doctor_provider.dart';
import 'package:provider/provider.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorList';

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  final uid = AuthService.currentUser?.uid;

  late DoctorProvider _doctorDataProvider;

  @override
  void didChangeDependencies() {
    _doctorDataProvider = Provider.of<DoctorProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Available Doctors'),
      ),
      body: ListView.builder(
        itemCount: _doctorDataProvider.getValueFromDB.length,
        itemBuilder: (context, index) {
          final doctorInfo = _doctorDataProvider.getValueFromDB[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      doctorInfo.name!,
                      style:
                          TextStyle(fontSize: 25, color: Colors.grey.shade800),
                    ),
                    Text(
                      doctorInfo.specialist!,
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade800),
                    ),
                    Text(
                      doctorInfo.email!,
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade800),
                    ),
                    Text(
                      doctorInfo.uid!,
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade800),
                    ),
                    ElevatedButton(
                      onPressed: _contactWithDoctor,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Contact'),
                    ),
                  ],
                ),
              ),
            ),
          );

          // return ListTile(
          //   title: Text(sensorValue.name!),
          //   subtitle: Text(sensorValue.email!),
          //   trailing: Text(sensorValue.specialist!),
          // );
        },
      ),
    );
  }

  void _contactWithDoctor() {
    // print(uid);
  }
}
