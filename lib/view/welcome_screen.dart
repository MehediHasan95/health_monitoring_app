import 'package:flutter/material.dart';
import 'package:health_monitoring_app/view/doctor_screen.dart';
import 'package:health_monitoring_app/view/signin_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String routeNames = '/WelcomeScreen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero, () {
  //     if (AuthService.currentUser == null) {
  //       Navigator.pushReplacementNamed(context, WelcomeScreen.routeNames);
  //     } else {
  //       Navigator.pushReplacementNamed(context, LiveScreen.routeNames);
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Form(
              child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            shrinkWrap: true,
            children: [
              const Text(
                'WELCOME',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "It’s a Good Day to Have a Good Day!",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Image.asset('assets/welcome.png'),
              LottieBuilder.asset(
                'assets/welcome.json',
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, SignInScreen.routeNames);
                },
                child: const Text('USER'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, DoctorScreen.routeNames);
                },
                child: const Text('DOCTOR'),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
