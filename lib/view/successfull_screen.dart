import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:lottie/lottie.dart';

class SuccessfullScreen extends StatefulWidget {
  const SuccessfullScreen({Key? key}) : super(key: key);
  static const String routeNames = '/SuccessfullScreen';

  @override
  State<SuccessfullScreen> createState() => _SuccessfullScreenState();
}

class _SuccessfullScreenState extends State<SuccessfullScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          LiveScreen.routeNames, (Route<dynamic> route) => false);
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
              LottieBuilder.asset('assets/successfull.json'),
            ],
          ),
        ));
  }
}
