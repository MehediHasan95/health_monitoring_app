import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/doctor_model.dart';
import 'package:health_monitoring_app/provider/doctor_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:health_monitoring_app/view/user_chat_room.dart';
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
  }

  @override
  Widget build(BuildContext context) {
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
                        subtitle: Text(doctorProfile.specialist!),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _shareWithDoctor(doctorProfile.uid);
                            showFlushBar(
                                context, "Your Data share successfully");
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.pink.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Icon(Icons.add),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserChatRoom(
                                  value: doctorProfile.uid.toString())));
                        },
                        onLongPress: () {
                          _getDoctorProfile(doctorProfile);
                        },
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

// Data share with doctor
  void _shareWithDoctor(String? doctorID) async {
    await DatabaseHelper.db
        .collection("userProfileInfo")
        .doc(uid)
        .get()
        .then((querySnapshot) {
      shareData = querySnapshot.data();
    });
    await DatabaseHelper.db
        .collection("sendToDoctor")
        .doc(doctorID)
        .collection("userList")
        .doc(uid)
        .set(shareData!);
  }

  void _getDoctorProfile(DoctorModel doctorProfile) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Column(
                children: [
                  doctorProfile.gender == "Male"
                      ? Image.asset('assets/man-doctor.png', height: 150)
                      : Image.asset('assets/woman-doctor.png', height: 150),
                  const SizedBox(height: 10),
                  Text("${doctorProfile.name}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900)),
                ],
              ),
              content: Column(
                children: [
                  Text("(${doctorProfile.specialist})",
                      style: TextStyle(color: Colors.grey.shade900)),
                  Text("${doctorProfile.hospital}",
                      style: TextStyle(color: Colors.grey.shade900)),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('CLOSE',
                      style: TextStyle(color: Colors.redAccent)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
