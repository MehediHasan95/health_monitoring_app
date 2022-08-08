import 'package:flutter/material.dart';
import 'package:health_monitoring_app/view/dash_screen.dart';
import 'package:lottie/lottie.dart';

class NotFound extends StatefulWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  State<NotFound> createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: LottieBuilder.asset("assets/notFound.json"),
              ),
              const Text(
                'Please connect your device',
                style: TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 20.0),
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, DashScreen.routeNames);
                    },
                    child: const Text('Dashboard'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
