import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_monitoring_app/view/doctor_dashboard.dart';
import 'package:lottie/lottie.dart';

class DoctorRegistrationSuccess extends StatefulWidget {
  const DoctorRegistrationSuccess({Key? key}) : super(key: key);
  static const String routeNames = '/DoctorRegistrationSuccess';

  @override
  State<DoctorRegistrationSuccess> createState() =>
      _DoctorRegistrationSuccessState();
}

class _DoctorRegistrationSuccessState extends State<DoctorRegistrationSuccess> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          DoctorDashboard.routeNames, (Route<dynamic> route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset('assets/doctorRegistrationSuccess.json'),
            ],
          ),
        ));
  }
}
