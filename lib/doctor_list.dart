import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/provider/doctor_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';

import 'package:provider/provider.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorList';

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late DoctorProvider _doctorProvider;
  final uid = AuthService.currentUser?.uid;
  Map<String, dynamic>? shareData;

  @override
  void didChangeDependencies() {
    _doctorProvider = Provider.of<DoctorProvider>(context);
    super.didChangeDependencies();
    _isUserAddedOrNot();
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    if (shareData != null) {
      setState(() {
        isActive = true;
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Available Doctor'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _doctorProvider.doctorList.length,
                itemBuilder: (context, index) {
                  final doctorProfile = _doctorProvider.doctorList[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: Colors.white70,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListTile(
                        leading: doctorProfile.gender == 'Male'
                            ? Image.asset('assets/man-doctor.png', height: 50)
                            : Image.asset('assets/woman-doctor.png',
                                height: 50),
                        title: Text(
                          doctorProfile.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800),
                        ),
                        subtitle: Text(doctorProfile.email!),
                        trailing: IconButton(
                            onPressed: _shareWithDoctor,
                            icon: isActive == true
                                ? const Icon(
                                    Icons.done_all,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: Colors.red,
                                  )),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// Check is value not null
  void _isUserAddedOrNot() async {
    final doctorUID = _doctorProvider.doctorList.first.uid;
    await DatabaseHelper.db
        .collection("sendToDoctor")
        .doc(doctorUID)
        .collection("userList")
        .doc(uid)
        .get()
        .then((querySnapshot) {
      shareData = querySnapshot.data();
    });
    setState(() {
      if (shareData != null) {
        shareData;
      }
    });
  }

// Data share with doctor
  void _shareWithDoctor() async {
    final doctorUID = _doctorProvider.doctorList.first.uid;
    await DatabaseHelper.db
        .collection("userProfileInfo")
        .doc(uid)
        .get()
        .then((querySnapshot) {
      shareData = querySnapshot.data();
    });
    DatabaseHelper.db
        .collection("sendToDoctor")
        .doc(doctorUID)
        .collection("userList")
        .doc(uid)
        .set(shareData!);
    setState(() {
      shareData;
    });
    // ignore: use_build_context_synchronously
    showFlushBar(context, 'Your record send succefully');
  }
}
