import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/view/live_screen.dart';
import 'package:health_monitoring_app/view/welcome_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeNames = '/SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      if (AuthService.currentUser == null) {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeNames);
      } else {
        Navigator.pushReplacementNamed(context, LiveScreen.routeNames);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          LottieBuilder.asset(
            'assets/splash.json',
          ),
          Column(
            children: const [
              Text(
                'Health Corner',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Live healthy, Stay young at heart',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
