import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/doctor_advice_model.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class DoctorAdvice extends StatefulWidget {
  const DoctorAdvice({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorAdvice';

  @override
  State<DoctorAdvice> createState() => _DoctorAdviceState();
}

class _DoctorAdviceState extends State<DoctorAdvice> {
  final uid = AuthService.currentUser?.uid;
  List<Object> _doctorAdviceList = [];

  @override
  void initState() {
    _getAllDoctorAdvice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Doctor Advice'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: _doctorAdviceList.length,
                    itemBuilder: (context, index) {
                      final getAdvice =
                          _doctorAdviceList[index] as DoctorAdviceModel;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          color: Colors.white70,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    getAdvice.doctorName!,
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  getAdvice.doctorGender == "Male"
                                      ? const Icon(Icons.male)
                                      : const Icon(Icons.female)
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ReadMoreText(
                                    getAdvice.message!,
                                    trimLines: 5,
                                    textAlign: TextAlign.justify,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: "more ",
                                    trimExpandedText: " Close ",
                                    lessStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple.shade900,
                                    ),
                                    moreStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple.shade900,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        DateFormat('dd MMMM yyyy, hh:mm a')
                                            .format(getAdvice.time!)
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

// get doctor advice method
  void _getAllDoctorAdvice() async {
    var data = await DatabaseHelper.db
        .collection("doctorAdvice")
        .doc(uid)
        .collection("message")
        .orderBy('time', descending: true)
        .get();
    setState(() {
      _doctorAdviceList = List.from(
          data.docs.map((doc) => DoctorAdviceModel.fromSnapshot(doc)));
    });
  }
}
