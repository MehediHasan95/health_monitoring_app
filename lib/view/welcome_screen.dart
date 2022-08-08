import 'package:flutter/material.dart';
import 'package:health_monitoring_app/view/doctor_screen.dart';
import 'package:health_monitoring_app/view/signin_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String routeNames = '/WelcomeScreen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
            child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          shrinkWrap: true,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.blue.shade900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "It’s a Good Day to Have a Good Day!",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Image.asset('assets/welcome.jpg'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.shade900,
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
                primary: Colors.blue.shade900,
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
    );
  }
}
