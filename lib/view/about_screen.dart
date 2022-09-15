import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const String routeNames = '/AboutScreen';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/healthcare.png', height: 80),
                const Text(
                  'Health Corner',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "The Heart Rate observation system is developed mistreatment IoT technology with the target of detective work on the heartbeat of the patient to watch the danger of heart failure and additionally the regular medical checkup.",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text('Version: 1.0.0',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
